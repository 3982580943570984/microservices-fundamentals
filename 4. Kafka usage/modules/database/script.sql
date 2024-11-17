-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS "Vote";
DROP TABLE IF EXISTS "User";
DROP TABLE IF EXISTS "Poll";

CREATE TABLE "Poll" (
	"id" VARCHAR(191) NOT NULL,
	"question" VARCHAR(191) NOT NULL,
	"userId" VARCHAR(191) NOT NULL,
	"registrationTimestamp" VARCHAR(191) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "User" (
	"id" VARCHAR(191) NOT NULL,
	"name" VARCHAR(191) NOT NULL,
	"email" VARCHAR(191) NOT NULL,
	"registeredObjects" INT NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "Vote" (
	"id" VARCHAR(191) NOT NULL,
	"option" VARCHAR(191) NOT NULL,
	"answers" INT NOT NULL,
	"pollId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("pollId") REFERENCES "Poll"("id"),
	PRIMARY KEY("id")
);


