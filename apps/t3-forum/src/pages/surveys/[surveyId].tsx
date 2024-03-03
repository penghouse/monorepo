import { GetStaticPaths, GetStaticProps, InferGetStaticPropsType } from "next";
import { api } from "src/utils/api";
import { createServerSideHelpers } from "@trpc/react-query/server";
import { appRouter } from "src/server/api/root";
import superjson from "superjson";
import { db } from "src/server/db";

export const getStaticProps: GetStaticProps = async (context) => {
  const { surveyId } = context.params ?? {};

  if (typeof surveyId !== "string" || !surveyId) {
    return {
      notFound: true,
    };
  }

  const helpers = createServerSideHelpers({
    router: appRouter,
    ctx: { session: null, db },
    transformer: superjson,
  });

  await helpers.survey.get.prefetch({ surveyId });

  return {
    props: {
      trpcState: helpers.dehydrate(),
      surveyId,
    },
    revalidate: 1,
  };
};

export const getStaticPaths: GetStaticPaths = async () => {
  const surveys = await db.survey.findMany({
    select: {
      id: true,
    },
  });

  return {
    paths: surveys.map((survey) => ({
      params: {
        surveyId: survey.id,
      },
    })),
    fallback: "blocking",
  };
};

export default function Page(
  props: InferGetStaticPropsType<typeof getStaticProps>
) {
  const { surveyId } = props;
  const { data: survey } = api.survey.get.useQuery(
    { surveyId },
    { refetchOnMount: false, refetchOnWindowFocus: false }
  );

  return (
    <div>
      <h1>Survey Info</h1>
      <pre>{JSON.stringify(survey, null, 2)}</pre>
    </div>
  );
}
