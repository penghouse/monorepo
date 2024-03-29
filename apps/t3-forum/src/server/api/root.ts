import { surveyRouter } from "./routers/survey";
import { postRouter } from "src/server/api/routers/post";
import { createTRPCRouter } from "src/server/api/trpc";

/**
 * This is the primary router for your server.
 *
 * All routers added in /api/routers should be manually added here.
 */
export const appRouter = createTRPCRouter({
  post: postRouter,
  survey: surveyRouter,
});

// export type definition of API
export type AppRouter = typeof appRouter;
