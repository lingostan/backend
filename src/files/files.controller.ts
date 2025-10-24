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
import { createReadStream, existsSync } from 'fs';
import { Response, Express } from 'express';
import { Multer } from 'multer';

const uploadPath = join(__dirname, '..', '..', 'public', 'uploads');

@Controller('files')
export class FilesController {
  @Post('upload')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: uploadPath,
        filename: (req, file, cb) => {
          const originalName = basename(
            file.originalname,
            extname(file.originalname),
          );
          const fileExt = extname(file.originalname);

          return cb(null, `${originalName}${fileExt}`);
        },
      }),
      fileFilter: (req, file, cb) => {
        console.log(file.mimetype);
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
    if (!/^[a-f0-9]+\.(mp3|wav|jpg|jpeg|png|gif)$/i.test(filename)) {
      throw new NotFoundException('Недопустимое имя файла');
    }

    const filePath = join(uploadPath, filename);

    if (!existsSync(filePath)) {
      throw new NotFoundException('Файл не найден');
    }

    return res.sendFile(filePath);
  }
}
