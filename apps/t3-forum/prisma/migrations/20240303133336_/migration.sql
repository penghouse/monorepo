/*
  Warnings:

  - The primary key for the `Post` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- CreateEnum
CREATE TYPE "DeviceType" AS ENUM ('Landline', 'Mobile');

-- CreateEnum
CREATE TYPE "CallerType" AS ENUM ('Interviewer', 'ARS');

-- CreateEnum
CREATE TYPE "PhoneNumberType" AS ENUM ('RDD', 'Virtual');

-- CreateEnum
CREATE TYPE "QuestionType" AS ENUM ('PoliticianApproval', 'PartyApproval', 'PresidentApproval');

-- AlterTable
ALTER TABLE "Post" DROP CONSTRAINT "Post_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Post_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Post_id_seq";

-- CreateTable
CREATE TABLE "SurveyMethod" (
    "id" TEXT NOT NULL,
    "device_type" "DeviceType" NOT NULL,
    "caller_type" "CallerType" NOT NULL,
    "phone_number_type" "PhoneNumberType" NOT NULL,
    "percentage" DOUBLE PRECISION NOT NULL,
    "response_rate" DOUBLE PRECISION NOT NULL,
    "survey_id" TEXT,

    CONSTRAINT "SurveyMethod_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SurveyOrg" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "short_name" TEXT,

    CONSTRAINT "SurveyOrg_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClientOrg" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "ClientOrg_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Party" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Party_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartyApproval" (
    "id" TEXT NOT NULL,
    "approval_rating" DOUBLE PRECISION NOT NULL,
    "disapproval_rating" DOUBLE PRECISION,
    "party_id" TEXT NOT NULL,
    "party_approval_result_id" TEXT,

    CONSTRAINT "PartyApproval_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartyApprovalResult" (
    "id" TEXT NOT NULL,
    "survey_result_id" TEXT NOT NULL,

    CONSTRAINT "PartyApprovalResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Politician" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "party_id" TEXT NOT NULL,

    CONSTRAINT "Politician_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PoliticianApproval" (
    "id" TEXT NOT NULL,
    "approval_rating" DOUBLE PRECISION NOT NULL,
    "disapproval_rating" DOUBLE PRECISION,
    "politician_id" TEXT NOT NULL,
    "politician_approval_result_id" TEXT,

    CONSTRAINT "PoliticianApproval_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PoliticianApprovalResult" (
    "id" TEXT NOT NULL,
    "survey_result_id" TEXT NOT NULL,

    CONSTRAINT "PoliticianApprovalResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "President" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "party_id" TEXT NOT NULL,

    CONSTRAINT "President_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PresidentApprovalResult" (
    "id" TEXT NOT NULL,
    "approval_rating" DOUBLE PRECISION NOT NULL,
    "disapproval_rating" DOUBLE PRECISION NOT NULL,
    "survey_result_id" TEXT NOT NULL,
    "presidentId" TEXT,

    CONSTRAINT "PresidentApprovalResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SurveyResult" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "type" "QuestionType" NOT NULL,
    "survey_id" TEXT,

    CONSTRAINT "SurveyResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SampleInfo" (
    "id" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "characteristics" TEXT NOT NULL,
    "confidence_level" DOUBLE PRECISION NOT NULL,
    "margin_of_error" DOUBLE PRECISION NOT NULL,
    "survey_id" TEXT NOT NULL,

    CONSTRAINT "SampleInfo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Survey" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "survey_org_id" TEXT NOT NULL,
    "clieng_org_id" TEXT,
    "sample_info_id" INTEGER,

    CONSTRAINT "Survey_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SurveyOrg_name_key" ON "SurveyOrg"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Party_name_key" ON "Party"("name");

-- CreateIndex
CREATE UNIQUE INDEX "PartyApprovalResult_survey_result_id_key" ON "PartyApprovalResult"("survey_result_id");

-- CreateIndex
CREATE UNIQUE INDEX "PoliticianApprovalResult_survey_result_id_key" ON "PoliticianApprovalResult"("survey_result_id");

-- CreateIndex
CREATE UNIQUE INDEX "President_party_id_key" ON "President"("party_id");

-- CreateIndex
CREATE UNIQUE INDEX "PresidentApprovalResult_survey_result_id_key" ON "PresidentApprovalResult"("survey_result_id");

-- CreateIndex
CREATE UNIQUE INDEX "SampleInfo_survey_id_key" ON "SampleInfo"("survey_id");

-- AddForeignKey
ALTER TABLE "SurveyMethod" ADD CONSTRAINT "SurveyMethod_survey_id_fkey" FOREIGN KEY ("survey_id") REFERENCES "Survey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartyApproval" ADD CONSTRAINT "PartyApproval_party_id_fkey" FOREIGN KEY ("party_id") REFERENCES "Party"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartyApproval" ADD CONSTRAINT "PartyApproval_party_approval_result_id_fkey" FOREIGN KEY ("party_approval_result_id") REFERENCES "PartyApprovalResult"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartyApprovalResult" ADD CONSTRAINT "PartyApprovalResult_survey_result_id_fkey" FOREIGN KEY ("survey_result_id") REFERENCES "SurveyResult"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Politician" ADD CONSTRAINT "Politician_party_id_fkey" FOREIGN KEY ("party_id") REFERENCES "Party"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PoliticianApproval" ADD CONSTRAINT "PoliticianApproval_politician_id_fkey" FOREIGN KEY ("politician_id") REFERENCES "Politician"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PoliticianApproval" ADD CONSTRAINT "PoliticianApproval_politician_approval_result_id_fkey" FOREIGN KEY ("politician_approval_result_id") REFERENCES "PoliticianApprovalResult"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PoliticianApprovalResult" ADD CONSTRAINT "PoliticianApprovalResult_survey_result_id_fkey" FOREIGN KEY ("survey_result_id") REFERENCES "SurveyResult"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "President" ADD CONSTRAINT "President_party_id_fkey" FOREIGN KEY ("party_id") REFERENCES "Party"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresidentApprovalResult" ADD CONSTRAINT "PresidentApprovalResult_survey_result_id_fkey" FOREIGN KEY ("survey_result_id") REFERENCES "SurveyResult"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresidentApprovalResult" ADD CONSTRAINT "PresidentApprovalResult_presidentId_fkey" FOREIGN KEY ("presidentId") REFERENCES "President"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurveyResult" ADD CONSTRAINT "SurveyResult_survey_id_fkey" FOREIGN KEY ("survey_id") REFERENCES "Survey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SampleInfo" ADD CONSTRAINT "SampleInfo_survey_id_fkey" FOREIGN KEY ("survey_id") REFERENCES "Survey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Survey" ADD CONSTRAINT "Survey_survey_org_id_fkey" FOREIGN KEY ("survey_org_id") REFERENCES "SurveyOrg"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Survey" ADD CONSTRAINT "Survey_clieng_org_id_fkey" FOREIGN KEY ("clieng_org_id") REFERENCES "ClientOrg"("id") ON DELETE SET NULL ON UPDATE CASCADE;
