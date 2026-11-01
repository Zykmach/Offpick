import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_ANON_KEY') ?? Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

export class HttpError extends Error {
  constructor(public status: number, message: string) {
    super(message);
  }
}

/// Checks the "Bearer <token>" the app sends and returns the user's id.
export async function requireUser(request: Request): Promise<string> {
  const token = request.headers.get('Authorization')?.replace('Bearer ', '');
  if (!token) throw new HttpError(401, 'Please log in again');

  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data.user) throw new HttpError(401, 'Please log in again');
  return data.user.id;
}

export function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

export function errorResponse(error: unknown) {
  console.error(error);
  if (error instanceof HttpError) return json({ message: error.message }, error.status);
  return json({ message: 'Something went wrong. Please try again.' }, 500);
}
