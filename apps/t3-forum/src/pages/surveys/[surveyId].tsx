import { GetStaticPaths, GetStaticProps, InferGetStaticPropsType } from "next";
import { api } from "src/utils/api";
import { createServerSideHelpers } from "@trpc/react-query/server";
import { appRouter } from "src/server/api/root";
import superjson from "superjson";
import { db } from "src/server/db";
import SurveyHeader from "src/components/surveys/SurveyHeader";
import SearchBar from "src/components/surveys/SearchBar";
import Graph from "src/components/surveys/Graph";
import InfoContainer from "src/components/surveys/InfoContainer";
import Footer from "src/components/surveys/Footer";
import { VStack } from "@chakra-ui/react";

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
    <VStack gap={10}>
      <SurveyHeader />
      <SearchBar />
      <Graph />
      {survey && <InfoContainer survey={survey} />}
      <Footer />
    </VStack>
  );
}
