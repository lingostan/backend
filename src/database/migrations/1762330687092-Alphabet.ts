import { MigrationInterface, QueryRunner } from "typeorm";

export class Alphabet1762330687092 implements MigrationInterface {
    name = 'Alphabet1762330687092'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "alphabet_item" ("id" SERIAL NOT NULL, "letter" character varying NOT NULL, "transcription" character varying NOT NULL, "audioUrl" character varying, "exampleWord" character varying, "exampleTranslation" character varying, "exampleImageUrl" character varying, "order" integer NOT NULL, "languageId" integer NOT NULL, CONSTRAINT "PK_aec691af3c032eaab355004afd1" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "language" DROP COLUMN "alphabet"`);
        await queryRunner.query(`ALTER TABLE "alphabet_item" ADD CONSTRAINT "FK_e252dd568669d8533409b9a9ff7" FOREIGN KEY ("languageId") REFERENCES "language"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "alphabet_item" DROP CONSTRAINT "FK_e252dd568669d8533409b9a9ff7"`);
        await queryRunner.query(`ALTER TABLE "language" ADD "alphabet" json NOT NULL`);
        await queryRunner.query(`DROP TABLE "alphabet_item"`);
    }

}
