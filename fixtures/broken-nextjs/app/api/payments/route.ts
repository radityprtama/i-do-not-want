// SEED: payment-without-idempotency
// SEED: payment-call-without-timeout
export async function POST(request: Request) {
  const order = await request.json();
  const response = await fetch("https://payments.example.invalid/charges", {
    method: "POST",
    body: JSON.stringify(order),
  });
  return Response.json(await response.json());
}
