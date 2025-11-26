import {
  Controller,
  Post,
  UseInterceptors,
  UploadedFile,
  Get,
  Param,
  Res,
  NotFoundException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { basename, extname, join } from 'path';
import { existsSync } from 'fs';
import { Response, Express } from 'express';
import { v4 as uuidv4 } from 'uuid';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiOperation,
  ApiParam,
  ApiResponse,
} from '@nestjs/swagger';

const uploadPath = join(__dirname, '..', '..', 'public', 'uploads');

@ApiBearerAuth()
@Controller('files')
export class FilesController {
  @Post('upload')
  @ApiOperation({
    summary: 'Загрузка файла',
    description:
      'Загружает файл на сервер. Поддерживаемые форматы: изображения (JPG, JPEG, PNG, GIF) и аудио (MP3, WAV, MPEG)',
  })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    description: 'Файл для загрузки',
    required: true,
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'Файл для загрузки',
        },
      },
    },
  })
  @ApiResponse({
    status: 201,
    description: 'Файл успешно загружен',
    schema: {
      example: {
        url: '/api/files/myimage-5423-123e4567-e89b-12d3-a456-426614174000.jpg',
        filename: 'myimage-5423-123e4567-e89b-12d3-a456-426614174000.jpg',
      },
    },
  })
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: uploadPath,
        filename: (req, file, cb) => {
          const decodedName = Buffer.from(file.originalname, 'latin1').toString(
            'utf8',
          );
          const originalName = basename(decodedName, extname(decodedName));
          const fileExt = extname(decodedName);
          const randomName = uuidv4();

          return cb(null, `${originalName}-5423-${randomName}${fileExt}`);
        },
      }),
      fileFilter: (req, file, cb) => {
        if (!file.mimetype.match(/\/(jpg|jpeg|png|gif|mp3|wav|mpeg)$/)) {
          return cb(new Error('Недопустимый тип файла'), false);
        }
        cb(null, true);
      },
      limits: {
        fileSize: 50 * 1024 * 1024,
      },
    }),
  )
  uploadFile(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new Error('Файл не загружен');
    }
    return {
      url: `/api/files/${file.filename}`,
      filename: file.filename,
    };
  }

  @Get(':filename')
  @ApiOperation({
    summary: 'Получение файла',
    description:
      'Возвращает файл по имени. Поддерживаются русские имена файлов в URL-encoded формате',
  })
  @ApiParam({
    name: 'filename',
    type: String,
    description: 'Имя файла',
    example: 'myimage-5423-123e4567-e89b-12d3-a456-426614174000.jpg',
    required: true,
  })
  @ApiResponse({
    status: 200,
    description: 'Файл найден и возвращен',
    schema: {
      type: 'string',
      format: 'binary',
    },
  })
  async serveFile(@Param('filename') filename: string, @Res() res: Response) {
    const decodedFilename = decodeURIComponent(filename);

    if (
      !/^[\p{L}\p{N}\s\-_\.\(\)%«»]+\.(mp3|wav|jpg|jpeg|png|gif)$/iu.test(
        decodedFilename,
      )
    ) {
      throw new NotFoundException('Недопустимое имя файла');
    }

    const filePath = join(uploadPath, decodedFilename);

    if (!existsSync(filePath)) {
      throw new NotFoundException('Файл не найден');
    }

    return res.sendFile(filePath);
  }
}
