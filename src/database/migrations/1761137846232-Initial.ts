import { MigrationInterface, QueryRunner } from "typeorm";

export class Initial1761137846232 implements MigrationInterface {
    name = 'Initial1761137846232'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "question" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "type" character varying NOT NULL, "questionText" text NOT NULL, "correctAnswer" text NOT NULL, "options" json, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "moduleId" uuid, CONSTRAINT "PK_21e5786aa0ea704ae185a79b2d5" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user_module_progress" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "completedAt" TIMESTAMP, "score" integer NOT NULL DEFAULT '0', "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "userLanguageId" uuid, "moduleId" uuid, CONSTRAINT "PK_8d9058401cea716db7be56855d9" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "lesson_module" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "title" character varying NOT NULL, "order" integer NOT NULL, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "languageId" uuid, CONSTRAINT "PK_53d2329d64a9274517d7160c29c" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "language" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "code" character varying NOT NULL, "name" character varying NOT NULL, "alphabet" json NOT NULL, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "UQ_465b3173cdddf0ac2d3fe73a33c" UNIQUE ("code"), CONSTRAINT "PK_cc0a99e710eb3733f6fb42b1d4c" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "user_language" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "status" character varying NOT NULL DEFAULT 'not_started', "currentModuleId" character varying, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "userId" uuid, "languageId" uuid, CONSTRAINT "PK_948d2ecd168ffdbb308c1bc8a27" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "users" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "name" character varying(100) NOT NULL, "email" character varying NOT NULL, "password" character varying NOT NULL, "age" integer, "sex" character varying NOT NULL, "phone" character varying, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "role" character varying NOT NULL DEFAULT 'user', CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE ("email"), CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "question" ADD CONSTRAINT "FK_4e03dbbe425761edf505d5a9d51" FOREIGN KEY ("moduleId") REFERENCES "lesson_module"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" ADD CONSTRAINT "FK_9e802f10b337d85d0167a04752a" FOREIGN KEY ("userLanguageId") REFERENCES "user_language"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" ADD CONSTRAINT "FK_331ecb2c203ab1bb5b73c2c695d" FOREIGN KEY ("moduleId") REFERENCES "lesson_module"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lesson_module" ADD CONSTRAINT "FK_e8372fe66edaa397e1f110fc7ec" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_language" ADD CONSTRAINT "FK_43d5b919c56d00a9f61ae8bf4cf" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_language" ADD CONSTRAINT "FK_ce64abf864b84feda3b2d3d923e" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user_language" DROP CONSTRAINT "FK_ce64abf864b84feda3b2d3d923e"`);
        await queryRunner.query(`ALTER TABLE "user_language" DROP CONSTRAINT "FK_43d5b919c56d00a9f61ae8bf4cf"`);
        await queryRunner.query(`ALTER TABLE "lesson_module" DROP CONSTRAINT "FK_e8372fe66edaa397e1f110fc7ec"`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" DROP CONSTRAINT "FK_331ecb2c203ab1bb5b73c2c695d"`);
        await queryRunner.query(`ALTER TABLE "user_module_progress" DROP CONSTRAINT "FK_9e802f10b337d85d0167a04752a"`);
        await queryRunner.query(`ALTER TABLE "question" DROP CONSTRAINT "FK_4e03dbbe425761edf505d5a9d51"`);
        await queryRunner.query(`DROP TABLE "users"`);
        await queryRunner.query(`DROP TABLE "user_language"`);
        await queryRunner.query(`DROP TABLE "language"`);
        await queryRunner.query(`DROP TABLE "lesson_module"`);
        await queryRunner.query(`DROP TABLE "user_module_progress"`);
        await queryRunner.query(`DROP TABLE "question"`);
    }

}
