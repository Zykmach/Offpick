-- Offpick schema. Offers are NOT stored: they come live from Cuelinks through
-- the "offers" Edge Function. The database only keeps the catalog (stores,
-- categories, interests) and each user's own choices.

-- ---------------------------------------------------------------------------
-- Catalog (public, read only)
-- ---------------------------------------------------------------------------

create table public.stores (
  id text primary key,
  name text not null,
  monogram text not null,
  search_url text not null,              -- '{q}' is replaced with the search text
  featured boolean not null default false,
  sort_order int not null default 0
);

create table public.categories (
  id text primary key,
  name text not null,
  icon text not null,
  tint text not null,
  groups text[] not null default '{}',   -- e.g. {men,women} for Fashion
  sort_order int not null default 0
);

create table public.subcategories (
  id text primary key,
  category_id text not null references public.categories (id) on delete cascade,
  name text not null,
  group_id text not null default '',
  icon text not null,
  tint text not null,
  sort_order int not null default 0
);

create table public.interests (
  id text primary key,
  label text not null,
  icon text not null,
  match_keys text[] not null,            -- category, subcategory or 'category:group' ids
  sort_order int not null default 0
);

create table public.trending_searches (
  rank int primary key,
  title text not null,
  query text not null,
  max_discount int not null default 0
);

-- ---------------------------------------------------------------------------
-- Per-user data (only ids and settings, never offer details)
-- ---------------------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  name text not null default '',
  email text not null default '',
  phone text not null default '',
  interest_ids text[] not null default '{}',
  store_ids text[] not null default '{}',
  interests_done boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.saved_offers (
  user_id uuid not null references auth.users (id) on delete cascade,
  offer_id text not null,
  created_at timestamptz not null default now(),
  primary key (user_id, offer_id)
);

create table public.tracked_products (
  user_id uuid not null references auth.users (id) on delete cascade,
  offer_id text not null,
  position int not null default 0,
  primary key (user_id, offer_id)
);

create table public.alerts (
  user_id uuid not null references auth.users (id) on delete cascade,
  id text not null,
  target text not null check (target in ('product', 'category')),
  target_id text not null,
  title text not null,
  detail text not null default '',
  icon text not null,
  tint text not null,
  triggers text[] not null default '{}',
  is_active boolean not null default true,
  position int not null default 0,
  primary key (user_id, id)
);

-- Written only by the server after a payment is verified.
create table public.subscriptions (
  user_id uuid primary key references auth.users (id) on delete cascade,
  plan text not null check (plan in ('monthly', 'yearly')),
  status text not null default 'active',  -- active, cancelled, expired
  provider text not null,
  payment_id text not null,
  expires_at timestamptz not null,
  updated_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Row level security
-- ---------------------------------------------------------------------------

alter table public.stores enable row level security;
alter table public.categories enable row level security;
alter table public.subcategories enable row level security;
alter table public.interests enable row level security;
alter table public.trending_searches enable row level security;
alter table public.profiles enable row level security;
alter table public.saved_offers enable row level security;
alter table public.tracked_products enable row level security;
alter table public.alerts enable row level security;
alter table public.subscriptions enable row level security;

create policy "Catalog is public" on public.stores for select using (true);
create policy "Catalog is public" on public.categories for select using (true);
create policy "Catalog is public" on public.subcategories for select using (true);
create policy "Catalog is public" on public.interests for select using (true);
create policy "Catalog is public" on public.trending_searches for select using (true);

create policy "Own profile" on public.profiles
  for all to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

create policy "Own saved offers" on public.saved_offers
  for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "Own tracked products" on public.tracked_products
  for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "Own alerts" on public.alerts
  for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "Read own subscription" on public.subscriptions
  for select to authenticated using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- New user -> profile row
-- ---------------------------------------------------------------------------

create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name', ''),
    coalesce(new.email, '')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Replace-the-whole-list helpers the app calls after each change
-- ---------------------------------------------------------------------------

create function public.set_saved_offers(offer_ids text[])
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from public.saved_offers where user_id = auth.uid();
  insert into public.saved_offers (user_id, offer_id)
  select auth.uid(), unnest(offer_ids);
$$;

create function public.set_tracked_products(offer_ids text[])
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from public.tracked_products where user_id = auth.uid();
  insert into public.tracked_products (user_id, offer_id, position)
  select auth.uid(), list.offer_id, list.position::int
  from unnest(offer_ids) with ordinality as list (offer_id, position);
$$;

create function public.set_alerts(items jsonb)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from public.alerts where user_id = auth.uid();
  insert into public.alerts (user_id, id, target, target_id, title, detail, icon, tint, triggers, is_active, position)
  select
    auth.uid(),
    item ->> 'id',
    item ->> 'target',
    item ->> 'targetId',
    item ->> 'title',
    coalesce(item ->> 'detail', ''),
    item ->> 'icon',
    item ->> 'tint',
    array(select jsonb_array_elements_text(item -> 'triggers')),
    coalesce((item ->> 'isActive')::boolean, true),
    list.position::int
  from jsonb_array_elements(items) with ordinality as list (item, position);
$$;

-- ---------------------------------------------------------------------------
-- Views shaped like the app's JSON models (camelCase keys)
-- ---------------------------------------------------------------------------

create view public.category_feed with (security_invoker = true) as
select
  categories.id,
  categories.name,
  categories.icon,
  categories.tint,
  categories.groups,
  categories.sort_order,
  coalesce((
    select jsonb_agg(jsonb_build_object(
      'id', subcategories.id,
      'name', subcategories.name,
      'categoryId', subcategories.category_id,
      'groupId', subcategories.group_id,
      'icon', subcategories.icon,
      'tint', subcategories.tint
    ) order by subcategories.sort_order)
    from public.subcategories
    where subcategories.category_id = categories.id
  ), '[]'::jsonb) as subcategories
from public.categories;

create view public.store_feed with (security_invoker = true) as
select id, name, monogram, featured, search_url as "searchUrl", sort_order
from public.stores;

create view public.interest_feed with (security_invoker = true) as
select id, label, icon, match_keys as "matchKeys", sort_order
from public.interests;

create view public.trending_feed with (security_invoker = true) as
select rank, title, query, max_discount as "maxDiscount"
from public.trending_searches;

-- ---------------------------------------------------------------------------
-- Grants (RLS above still decides which rows are visible)
-- ---------------------------------------------------------------------------

grant select on
  public.stores, public.categories, public.subcategories, public.interests, public.trending_searches,
  public.category_feed, public.store_feed, public.interest_feed, public.trending_feed
to anon, authenticated;

grant select, insert, update, delete on
  public.profiles, public.saved_offers, public.tracked_products, public.alerts
to authenticated;

grant select on public.subscriptions to authenticated;

revoke execute on function public.set_saved_offers(text[]) from public, anon;
revoke execute on function public.set_tracked_products(text[]) from public, anon;
revoke execute on function public.set_alerts(jsonb) from public, anon;
grant execute on function public.set_saved_offers(text[]) to authenticated;
grant execute on function public.set_tracked_products(text[]) to authenticated;
grant execute on function public.set_alerts(jsonb) to authenticated;
