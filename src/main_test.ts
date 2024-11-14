import { assertEquals } from "./deps.ts";
import { main } from "./main.ts";

Deno.test("hello test", () => {
  const the_answer = 42;
  assertEquals(main(), the_answer);
});
