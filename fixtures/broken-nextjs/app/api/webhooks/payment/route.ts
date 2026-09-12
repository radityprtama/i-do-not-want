// SEED: unsigned-payment-webhook
export async function POST(request: Request) {
  const event = await request.json();
  return Response.json({ acceptedEvent: event.type });
}
