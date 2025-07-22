import { env } from 'process';
import { config } from 'dotenv';
import { DataSource, DataSourceOptions } from 'typeorm';

type DataSourceTypes = DataSourceOptions & {
  cli: {
    migrationsDir: string;
  };
};

config();

console.log(__dirname + '/../../database/migrations/*.ts');

const MigrationOrmSource = new DataSource({
  type: 'postgres',

  host: env.POSTGRES_HOST,
  port: parseFloat(env.POSTGRES_PORT),
  username: env.POSTGRES_USER,
  password: env.POSTGRES_PASSWORD,
  database: env.POSTGRES_DB,
  entities: [__dirname + '/../**/entities/*.entity.ts'],
  migrations: [__dirname + '/../../database/migrations/*.ts'],
  synchronize: false,
  logging: false,
  migrationsRun: true,

  cli: {
    migrationsDir: 'database/migrations',
  },
} as DataSourceTypes);

const TypeOrmConfig = {
  ...MigrationOrmSource.options,

  autoLoadEntities: true,
};

export { TypeOrmConfig };
export default MigrationOrmSource;
