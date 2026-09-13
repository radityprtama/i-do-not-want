const syntheticUsers = new Map([["example-user", { id: "example-user" }]]);

// SEED: unauthenticated-admin-mutation
export async function DELETE(request: Request) {
  const id = new URL(request.url).searchParams.get("id") ?? "";
  syntheticUsers.delete(id);
  return Response.json({ deleted: id });
}
