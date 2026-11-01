// The only place that talks to Cuelinks. The API key lives in Supabase
// secrets (CUELINKS_API_KEY) and never reaches the app.
// Docs: https://cuelinks.docs.apiary.io

const baseUrl = 'https://www.cuelinks.com/api/v2';

export async function cuelinksGet(path: string, params: Record<string, string> = {}) {
  const apiKey = Deno.env.get('CUELINKS_API_KEY');
  if (!apiKey) throw new Error('CUELINKS_API_KEY is not set');

  const url = new URL(`${baseUrl}/${path}`);
  for (const [key, value] of Object.entries(params)) {
    if (value) url.searchParams.set(key, value);
  }

  const response = await fetch(url, {
    headers: { Authorization: `Token token=${apiKey}`, 'Content-Type': 'application/json' },
  });
  if (!response.ok) {
    throw new Error(`Cuelinks ${path} failed with ${response.status}: ${await response.text()}`);
  }
  return await response.json();
}
