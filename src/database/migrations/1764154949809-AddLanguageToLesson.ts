import { MigrationInterface, QueryRunner } from "typeorm";

export class AddLanguageToLesson1764154949809 implements MigrationInterface {
    name = 'AddLanguageToLesson1764154949809'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lesson" ADD "languageId" integer`);
        await queryRunner.query(`ALTER TABLE "lesson" ADD CONSTRAINT "FK_d56e101695dc9292af226db76b2" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lesson" DROP CONSTRAINT "FK_d56e101695dc9292af226db76b2"`);
        await queryRunner.query(`ALTER TABLE "lesson" DROP COLUMN "languageId"`);
    }

}
