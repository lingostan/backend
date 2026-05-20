import { MigrationInterface, QueryRunner } from "typeorm";

export class AddVocabularyToLanguage1764143928742 implements MigrationInterface {
    name = 'AddVocabularyToLanguage1764143928742'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "language" ADD "vocabulary" jsonb`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "language" DROP COLUMN "vocabulary"`);
    }

}
