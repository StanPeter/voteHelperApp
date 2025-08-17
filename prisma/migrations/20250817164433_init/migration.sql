-- CreateTable
CREATE TABLE "public"."Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,
    "refresh_token_expires_in" INTEGER,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "public"."PoliticalParty" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "shortName" TEXT,
    "logo" TEXT,
    "color" TEXT,
    "description" TEXT NOT NULL,
    "ideology" TEXT[],
    "founded" TIMESTAMP(3),
    "website" TEXT,
    "socialLinks" JSONB,
    "leaderName" TEXT,
    "currentSeats" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "PoliticalParty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PolicyArea" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "PolicyArea_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PolicyStance" (
    "id" TEXT NOT NULL,
    "partyId" TEXT NOT NULL,
    "policyAreaId" TEXT NOT NULL,
    "stance" TEXT NOT NULL,
    "sourceUrl" TEXT,
    "lastUpdated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PolicyStance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ElectionResult" (
    "id" TEXT NOT NULL,
    "partyId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "votes" INTEGER NOT NULL,
    "seats" INTEGER NOT NULL,
    "voteShare" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "ElectionResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."HelpResource" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "url" TEXT,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HelpResource_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "public"."Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "public"."Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "public"."VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "public"."VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "ElectionResult_partyId_year_key" ON "public"."ElectionResult"("partyId", "year");

-- AddForeignKey
ALTER TABLE "public"."Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PolicyStance" ADD CONSTRAINT "PolicyStance_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "public"."PoliticalParty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PolicyStance" ADD CONSTRAINT "PolicyStance_policyAreaId_fkey" FOREIGN KEY ("policyAreaId") REFERENCES "public"."PolicyArea"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ElectionResult" ADD CONSTRAINT "ElectionResult_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "public"."PoliticalParty"("id") ON DELETE CASCADE ON UPDATE CASCADE;
