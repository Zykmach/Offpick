import '@supabase/functions-js/edge-runtime.d.ts';
// POST /functions/v1/go   body: { url, offerId }
// Turns a plain store link into a Cuelinks affiliate link when the user taps
// "Go to store". subid = user id and subid2 = offer id, so every sale in the
// Cuelinks report shows who bought and from which offer.
// If the store's campaign is not approved yet, the plain link comes back
// with tracked: false so the user still reaches the store.

import { cuelinksGet } from '../_shared/cuelinks.ts';
import { errorResponse, HttpError, json, requireUser } from '../_shared/http.ts';

Deno.serve(async (request) => {
  try {
    const userId = await requireUser(request);
    const { url, offerId } = await request.json();
    if (typeof url !== 'string' || !url.startsWith('https://')) {
      throw new HttpError(400, 'This link is not valid');
    }

    try {
      const data = await cuelinksGet('links.json', {
        url,
        subid: userId,
        subid2: typeof offerId === 'string' ? offerId : '',
      });
      return json({ url: data.affiliate_url ?? url, tracked: Boolean(data.affiliate_url) });
    } catch (error) {
      console.error('Cuelinks link failed', url, error);
      return json({ url, tracked: false });
    }
  } catch (error) {
    return errorResponse(error);
  }
});
