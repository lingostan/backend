import { MigrationInterface, QueryRunner } from "typeorm";

export class AddAvatarToUser1761309143096 implements MigrationInterface {
    name = 'AddAvatarToUser1761309143096'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" ADD "avatar" character varying`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "avatar"`);
    }

}
