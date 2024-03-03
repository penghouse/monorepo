import { TRPCError } from "@trpc/server";
import { z } from "zod";

import { createTRPCRouter, publicProcedure } from "src/server/api/trpc";
import { db } from "src/server/db";

export const surveyRouter = createTRPCRouter({
  get: publicProcedure
    .input(z.object({ surveyId: z.string() }))
    .query(async ({ input }) => {
      const survey = await db.survey.findUnique({
        where: {
          id: input.surveyId,
        },
        include: {
          results: {
            include: {
              politician_approval: {
                include: {
                  approval: true,
                },
              },
              party_approval: {
                include: {
                  approvals: true,
                },
              },
              president_approval: true,
            },
          },
        },
      });

      if (!survey) {
        throw new TRPCError({
          code: "NOT_FOUND",
          message: "Survey not found",
        });
      }

      return survey;
    }),
});
