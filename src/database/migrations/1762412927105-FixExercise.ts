import { MigrationInterface, QueryRunner } from "typeorm";

export class FixExercise1762412927105 implements MigrationInterface {
    name = 'FixExercise1762412927105'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "exercise" DROP CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb"`);
        await queryRunner.query(`ALTER TABLE "exercise" ADD "languageId" integer`);
        await queryRunner.query(`ALTER TABLE "exercise" ADD CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb" FOREIGN KEY ("lessonId") REFERENCES "lesson"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "exercise" ADD CONSTRAINT "FK_20dd373d7e46d388216b913062b" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "exercise" DROP CONSTRAINT "FK_20dd373d7e46d388216b913062b"`);
        await queryRunner.query(`ALTER TABLE "exercise" DROP CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb"`);
        await queryRunner.query(`ALTER TABLE "exercise" DROP COLUMN "languageId"`);
        await queryRunner.query(`ALTER TABLE "exercise" ADD CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb" FOREIGN KEY ("lessonId") REFERENCES "lesson"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
