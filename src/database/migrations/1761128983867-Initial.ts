import { MigrationInterface, QueryRunner } from "typeorm";

export class Initial1761128983867 implements MigrationInterface {
    name = 'Initial1761128983867'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" ADD "phone" character varying`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "phone"`);
    }

}
