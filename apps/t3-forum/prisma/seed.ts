import {
  CallerType,
  DeviceType,
  PhoneNumberType,
  PrismaClient,
  QuestionType,
} from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const powerParty = await prisma.party.upsert({
    where: { name: "국민의힘" },
    update: {},
    create: {
      name: "국민의 힘",
    },
  });

  const demoParty = await prisma.party.upsert({
    where: { name: "더불어민주당" },
    update: {},
    create: {
      name: "더불어민주당",
    },
  });

  const etcParty = await prisma.party.upsert({
    where: { name: "기타" },
    update: {},
    create: {
      name: "기타",
    },
  });

  const gallup = await prisma.surveyOrg.upsert({
    where: { name: "한국갤럽조사연구소" },
    update: {},
    create: {
      name: "한국갤럽조사연구소",
      short_name: "갤럽",
    },
  });

  const survey = await prisma.survey.create({
    data: {
      title: "한국갤럽_2024년 2월 5주_정당지지도",
      start_date: new Date("2024-02-27T04:00:00"),
      end_date: new Date("2024-02-29T09:00"),
      methods: {
        create: [
          {
            device_type: DeviceType.Mobile,
            caller_type: CallerType.Interviewer,
            phone_number_type: PhoneNumberType.Virtual,
            percentage: 100,
            response_rate: 15.8,
          },
        ],
      },
      survey_org: {
        connect: gallup,
      },
      sample_info: {
        create: {
          size: 19999,
          characteristics: "전국 만 18세 이상 남녀",
          confidence_level: 95,
          margin_of_error: 3.1,
        },
      },
      results: {
        create: [
          {
            question: "정당 지지도",
            type: QuestionType.PartyApproval,
            party_approval: {
              create: {
                approvals: {
                  create: [
                    {
                      party: {
                        connect: powerParty,
                      },
                      approval_rating: 40,
                    },
                    {
                      party: {
                        connect: demoParty,
                      },
                      approval_rating: 33,
                    },
                    {
                      party: {
                        connect: etcParty,
                      },
                      approval_rating: 27,
                    },
                  ],
                },
              },
            },
          },
        ],
      },
    },
  });
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
