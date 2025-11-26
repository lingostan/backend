import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateLessonProgress1764155523285 implements MigrationInterface {
    name = 'UpdateLessonProgress1764155523285'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" DROP CONSTRAINT "FK_881fed870b83f86385c3d94523c"`);
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" ADD CONSTRAINT "FK_881fed870b83f86385c3d94523c" FOREIGN KEY ("lessonId") REFERENCES "lesson"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" DROP CONSTRAINT "FK_881fed870b83f86385c3d94523c"`);
        await queryRunner.query(`ALTER TABLE "user_lesson_progress" ADD CONSTRAINT "FK_881fed870b83f86385c3d94523c" FOREIGN KEY ("lessonId") REFERENCES "lesson"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
