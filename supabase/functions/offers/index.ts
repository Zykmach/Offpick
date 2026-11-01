import '@supabase/functions-js/edge-runtime.d.ts';
// GET /functions/v1/offers
// Live offers from Cuelinks for the stores the app supports.
// Nothing is saved in the database, results are only kept in memory for a few minutes.

import { cuelinksGet } from '../_shared/cuelinks.ts';
import { errorResponse, json, requireUser } from '../_shared/http.ts';
import { CuelinksOffer, mapOffer } from '../_shared/offer_mapper.ts';

const cacheMs = 15 * 60 * 1000;
const perPage = 100;
const maxPages = 15;

let cache = { offers: [] as unknown[], savedAt: 0 };

Deno.serve(async (request) => {
  try {
    await requireUser(request);
    if (Date.now() - cache.savedAt > cacheMs) {
      cache = { offers: await fetchLiveOffers(), savedAt: Date.now() };
    }
    return json(cache.offers);
  } catch (error) {
    return errorResponse(error);
  }
});

/// Reads page 1, then the remaining pages side by side.
async function fetchLiveOffers() {
  const first = await cuelinksGet('offers.json', { page: '1', per_page: String(perPage) });
  const pageCount = Math.min(Math.ceil((first.total_count ?? 0) / perPage), maxPages);
  const rest = await Promise.all(
    Array.from({ length: Math.max(pageCount - 1, 0) }, (unused, index) =>
      cuelinksGet('offers.json', { page: String(index + 2), per_page: String(perPage) })
    ),
  );
  const all: CuelinksOffer[] = [first, ...rest].flatMap((page) => page.offers ?? []);
  return all.map(mapOffer).filter((offer) => offer !== null);
}
