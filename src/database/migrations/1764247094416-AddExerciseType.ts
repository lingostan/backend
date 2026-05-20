import { MigrationInterface, QueryRunner } from "typeorm";

export class AddExerciseType1764247094416 implements MigrationInterface {
    name = 'AddExerciseType1764247094416'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TYPE "public"."exercise_type_enum" RENAME TO "exercise_type_enum_old"`);
        await queryRunner.query(`CREATE TYPE "public"."exercise_type_enum" AS ENUM('MULTIPLE_CHOICE', 'MULTIPLE_CHOICE_IMGS', 'MATCHING', 'MATCHING_AUDIO', 'TRANSLATION', 'LISTENING', 'SPEAKING', 'FILL_BLANK', 'REORDER', 'TRUE_FALSE')`);
        await queryRunner.query(`ALTER TABLE "exercise" ALTER COLUMN "type" DROP DEFAULT`);
        await queryRunner.query(`ALTER TABLE "exercise" ALTER COLUMN "type" TYPE "public"."exercise_type_enum" USING "type"::"text"::"public"."exercise_type_enum"`);
        await queryRunner.query(`ALTER TABLE "exercise" ALTER COLUMN "type" SET DEFAULT 'MULTIPLE_CHOICE'`);
        await queryRunner.query(`DROP TYPE "public"."exercise_type_enum_old"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."exercise_type_enum_old" AS ENUM('MULTIPLE_CHOICE', 'MULTIPLE_CHOICE_IMGS', 'MATCHING', 'TRANSLATION', 'LISTENING', 'SPEAKING', 'FILL_BLANK', 'REORDER', 'TRUE_FALSE')`);
        await queryRunner.query(`ALTER TABLE "exercise" ALTER COLUMN "type" DROP DEFAULT`);
        await queryRunner.query(`ALTER TABLE "exercise" ALTER COLUMN "type" TYPE "public"."exercise_type_enum_old" USING "type"::"text"::"public"."exercise_type_enum_old"`);
        await queryRunner.query(`ALTER TABLE "exercise" ALTER COLUMN "type" SET DEFAULT 'MULTIPLE_CHOICE'`);
        await queryRunner.query(`DROP TYPE "public"."exercise_type_enum"`);
        await queryRunner.query(`ALTER TYPE "public"."exercise_type_enum_old" RENAME TO "exercise_type_enum"`);
    }

}
