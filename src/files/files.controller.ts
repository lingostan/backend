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

const uploadPath = join(__dirname, '..', '..', 'public', 'uploads');

@Controller('files')
export class FilesController {
  @Post('upload')
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
  async serveFile(@Param('filename') filename: string, @Res() res: Response) {
    const decodedFilename = decodeURIComponent(filename);

    if (
      !/^[a-zA-Zа-яА-Я0-9\s\-_\.«»()]+\.(mp3|wav|jpg|jpeg|png|gif)$/i.test(
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
