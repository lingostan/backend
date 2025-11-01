import { MigrationInterface, QueryRunner } from "typeorm";

export class Initial1761984700587 implements MigrationInterface {
    name = 'Initial1761984700587'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "user_exercise_progress" ("id" SERIAL NOT NULL, "completed" boolean NOT NULL DEFAULT false, "score" integer NOT NULL DEFAULT '0', "attempts" integer NOT NULL DEFAULT '0', "userAnswers" jsonb, "timeSpent" integer NOT NULL DEFAULT '0', "startedAt" TIMESTAMP NOT NULL DEFAULT now(), "completedAt" TIMESTAMP, "userId" uuid, "exerciseId" integer, CONSTRAINT "PK_9546a0f74c6871e58d880443221" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."exercise_type_enum" AS ENUM('MULTIPLE_CHOICE', 'MATCHING', 'TRANSLATION', 'LISTENING', 'SPEAKING', 'FILL_BLANK', 'REORDER', 'TRUE_FALSE')`);
        await queryRunner.query(`CREATE TABLE "exercise" ("id" SERIAL NOT NULL, "type" "public"."exercise_type_enum" NOT NULL DEFAULT 'MULTIPLE_CHOICE', "title" character varying NOT NULL, "instructions" text, "content" jsonb NOT NULL, "points" integer NOT NULL DEFAULT '10', "order" integer NOT NULL DEFAULT '1', "hints" jsonb, "explanation" text, "isActive" boolean NOT NULL DEFAULT true, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "lessonId" integer, CONSTRAINT "PK_a0f107e3a2ef2742c1e91d97c14" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user_lesson_progress" ("id" SERIAL NOT NULL, "completed" boolean NOT NULL DEFAULT false, "progress" numeric(5,2) NOT NULL DEFAULT '0', "score" integer NOT NULL DEFAULT '0', "timeSpent" integer NOT NULL DEFAULT '0', "startedAt" TIMESTAMP NOT NULL DEFAULT now(), "completedAt" TIMESTAMP, "userId" uuid, "lessonId" integer, CONSTRAINT "PK_2d52c2d4b5f26e61b3169d3d01a" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "lesson" ("id" SERIAL NOT NULL, "title" character varying NOT NULL, "description" text NOT NULL, "order" integer NOT NULL, "duration" integer NOT NULL DEFAULT '0', "videoUrl" character varying, "vocabulary" jsonb, "grammarNotes" text, "isActive" boolean NOT NULL DEFAULT true, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "modsId" integer, CONSTRAINT "PK_0ef25918f0237e68696dee455bd" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user_module_progress" ("id" SERIAL NOT NULL, "completed" boolean NOT NULL DEFAULT false, "progress" numeric(5,2) NOT NULL DEFAULT '0', "score" integer NOT NULL DEFAULT '0', "timeSpent" integer NOT NULL DEFAULT '0', "startedAt" TIMESTAMP NOT NULL DEFAULT now(), "completedAt" TIMESTAMP, "userId" uuid, "modsId" integer, CONSTRAINT "PK_8d9058401cea716db7be56855d9" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "learning_modules" ("id" SERIAL NOT NULL, "title" character varying NOT NULL, "description" text NOT NULL, "order" integer NOT NULL, "difficulty" character varying NOT NULL DEFAULT 'BEGINNER', "imageUrl" character varying, "estimatedDuration" integer NOT NULL DEFAULT '0', "totalLessons" integer NOT NULL DEFAULT '0', "totalExercises" integer NOT NULL DEFAULT '0', "isActive" boolean NOT NULL DEFAULT true, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "languageId" integer, CONSTRAINT "PK_5884364b4820dc6ee536d3f65ff" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "language" ("id" SERIAL NOT NULL, "code" character varying NOT NULL, "name" character varying NOT NULL, "flagEmoji" character varying, "flagUrl" character varying, "description" text, "difficulty" integer NOT NULL DEFAULT '0', "isActive" boolean NOT NULL DEFAULT true, "totalModules" integer NOT NULL DEFAULT '0', "totalExercises" integer NOT NULL DEFAULT '0', "alphabet" json NOT NULL, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "UQ_465b3173cdddf0ac2d3fe73a33c" UNIQUE ("code"), CONSTRAINT "PK_cc0a99e710eb3733f6fb42b1d4c" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user_language" ("id" SERIAL NOT NULL, "level" integer NOT NULL DEFAULT '1', "progress" numeric(5,2) NOT NULL DEFAULT '0', "isActive" boolean NOT NULL DEFAULT true, "totalPoints" integer NOT NULL DEFAULT '0', "streak" integer NOT NULL DEFAULT '0', "startedAt" TIMESTAMP NOT NULL DEFAULT now(), "lastPracticedAt" TIMESTAMP, "userId" uuid, "languageId" integer, CONSTRAINT "PK_948d2ecd168ffdbb308c1bc8a27" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user_progress" ("id" SERIAL NOT NULL, "overallProgress" numeric(5,2) NOT NULL DEFAULT '0', "totalPoints" integer NOT NULL DEFAULT '0', "completedExercises" integer NOT NULL DEFAULT '0', "totalExercises" integer NOT NULL DEFAULT '0', "completedLessons" integer NOT NULL DEFAULT '0', "totalLessons" integer NOT NULL DEFAULT '0', "completedModules" integer NOT NULL DEFAULT '0', "totalModules" integer NOT NULL DEFAULT '0', "streak" integer NOT NULL DEFAULT '0', "dailyGoal" integer NOT NULL DEFAULT '0', "dailyProgress" integer NOT NULL DEFAULT '0', "lastActivityAt" TIMESTAMP NOT NULL DEFAULT now(), "lastActivityDate" date NOT NULL, "userId" uuid, "languageId" integer, CONSTRAINT "PK_7b5eb2436efb0051fdf05cbe839" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "email" character varying NOT NULL, "password" character varying NOT NULL, "name" character varying(100) NOT NULL, "avatarUrl" character varying, "isActive" boolean NOT NULL DEFAULT true, "age" integer, "sex" character varying, "phone" character varying, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE ("email"), CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "user_exercise_progress" ADD CONSTRAINT "FK_d9794ca634e8d389350c3861f49" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_exercise_progress" ADD CONSTRAINT "FK_67ec8aab514c6c114dfaedc178a" FOREIGN KEY ("exerciseId") REFERENCES "exercise"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "exercise" ADD CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb" FOREIGN KEY ("lessonId") REFERENCES "lesson"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" ADD CONSTRAINT "FK_27792bdc478c840e0b84095bf96" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" ADD CONSTRAINT "FK_881fed870b83f86385c3d94523c" FOREIGN KEY ("lessonId") REFERENCES "lesson"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lesson" ADD CONSTRAINT "FK_8f346da43831459ea8601f5a847" FOREIGN KEY ("modsId") REFERENCES "learning_modules"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" ADD CONSTRAINT "FK_a05dcf2280e8e1b61a0c6eac265" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" ADD CONSTRAINT "FK_a6fa58bb2cad4b99b8ac5796d4f" FOREIGN KEY ("modsId") REFERENCES "learning_modules"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "learning_modules" ADD CONSTRAINT "FK_afe8c5092e31ef6f9c9f7b21398" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_language" ADD CONSTRAINT "FK_43d5b919c56d00a9f61ae8bf4cf" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_language" ADD CONSTRAINT "FK_ce64abf864b84feda3b2d3d923e" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_progress" ADD CONSTRAINT "FK_b5d0e1b57bc6c761fb49e79bf89" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_progress" ADD CONSTRAINT "FK_d45e84b24bb0a4987f7dc7c5bcd" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user_progress" DROP CONSTRAINT "FK_d45e84b24bb0a4987f7dc7c5bcd"`);
        await queryRunner.query(`ALTER TABLE "user_progress" DROP CONSTRAINT "FK_b5d0e1b57bc6c761fb49e79bf89"`);
        await queryRunner.query(`ALTER TABLE "user_language" DROP CONSTRAINT "FK_ce64abf864b84feda3b2d3d923e"`);
        await queryRunner.query(`ALTER TABLE "user_language" DROP CONSTRAINT "FK_43d5b919c56d00a9f61ae8bf4cf"`);
        await queryRunner.query(`ALTER TABLE "learning_modules" DROP CONSTRAINT "FK_afe8c5092e31ef6f9c9f7b21398"`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" DROP CONSTRAINT "FK_a6fa58bb2cad4b99b8ac5796d4f"`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" DROP CONSTRAINT "FK_a05dcf2280e8e1b61a0c6eac265"`);
        await queryRunner.query(`ALTER TABLE "lesson" DROP CONSTRAINT "FK_8f346da43831459ea8601f5a847"`);
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" DROP CONSTRAINT "FK_881fed870b83f86385c3d94523c"`);
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" DROP CONSTRAINT "FK_27792bdc478c840e0b84095bf96"`);
        await queryRunner.query(`ALTER TABLE "exercise" DROP CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb"`);
        await queryRunner.query(`ALTER TABLE "user_exercise_progress" DROP CONSTRAINT "FK_67ec8aab514c6c114dfaedc178a"`);
        await queryRunner.query(`ALTER TABLE "user_exercise_progress" DROP CONSTRAINT "FK_d9794ca634e8d389350c3861f49"`);
        await queryRunner.query(`DROP TABLE "user"`);
        await queryRunner.query(`DROP TABLE "user_progress"`);
        await queryRunner.query(`DROP TABLE "user_language"`);
        await queryRunner.query(`DROP TABLE "language"`);
        await queryRunner.query(`DROP TABLE "learning_modules"`);
        await queryRunner.query(`DROP TABLE "user_module_progress"`);
        await queryRunner.query(`DROP TABLE "lesson"`);
        await queryRunner.query(`DROP TABLE "user_lesson_progress"`);
        await queryRunner.query(`DROP TABLE "exercise"`);
        await queryRunner.query(`DROP TYPE "public"."exercise_type_enum"`);
        await queryRunner.query(`DROP TABLE "user_exercise_progress"`);
    }

}
