// SEED: retry-duplicates-email
export async function POST(request: Request) {
  const job = await request.json();
  await fetch("https://mail.example.invalid/send", {
    method: "POST",
    body: JSON.stringify(job),
  });
  return Response.json({ sent: true });
}
