import { Survey } from "@prisma/client";

interface Props {
  survey: Survey;
}

function InfoContainer({ survey }: Props) {
  return (
    <div>
      <h1>Info Container</h1>
      <pre>{JSON.stringify(survey, null, 2)}</pre>
    </div>
  );
}

export default InfoContainer;
