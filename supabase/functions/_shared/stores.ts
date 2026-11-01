// Cuelinks campaign -> store shown in the app.
// Big stores use the ids from the stores table (supabase/migrations/*_catalog.sql),
// every other brand gets an id made from its name, e.g. "Sugar Cosmetics" -> "sugar-cosmetics".

export type Store = { id: string; name: string };

const knownStores: { id: string; name: string; campaign: string }[] = [
  { id: 'amazon', name: 'Amazon', campaign: 'amazon india' },
  { id: 'flipkart', name: 'Flipkart', campaign: 'flipkart' },
  { id: 'myntra', name: 'Myntra', campaign: 'myntra' },
  { id: 'ajio', name: 'AJIO', campaign: 'ajio' },
  { id: 'purplle', name: 'Purplle', campaign: 'purplle' },
  { id: 'croma', name: 'Croma', campaign: 'croma' },
];

export function storeFor(campaignName: string): Store {
  const name = campaignName.trim();
  const known = knownStores.find((store) => name.toLowerCase() === store.campaign || name.toLowerCase().startsWith(`${store.campaign} `));
  if (known) return { id: known.id, name: known.name };
  const id = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  return { id, name };
}
