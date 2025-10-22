import { IsString, IsArray, IsNotEmpty, ArrayMinSize } from 'class-validator';

export class CreateLanguageDto {
  @IsString()
  @IsNotEmpty()
  code: string;

  @IsString()
  @IsNotEmpty()
  name: string;

  @IsArray()
  @ArrayMinSize(1)
  @IsString({ each: true })
  alphabet: string[];
}
