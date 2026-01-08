import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { v2 as cloudinary } from 'cloudinary';

@Injectable()
export class CloudinaryService {
  private readonly logger = new Logger(CloudinaryService.name);

  constructor(private configService: ConfigService) {
    cloudinary.config({
      cloud_name: this.configService.get('CLOUDINARY_CLOUD_NAME'),
      api_key: this.configService.get('CLOUDINARY_API_KEY'),
      api_secret: this.configService.get('CLOUDINARY_API_SECRET'),
    });
  }

  async uploadImage(
    file: any, // TODO: Add @types/multer and use Express.Multer.File
    folder: string,
    organizationId: string,
  ) {
    const uploadFolder = `uploads/${organizationId}/${folder}`;

    try {
      const result = await cloudinary.uploader.upload(file.path, {
        folder: uploadFolder,
        transformation: [
          { width: 1200, height: 1200, crop: 'limit' },
          { quality: 'auto' },
          { fetch_format: 'auto' },
        ],
      });

      return {
        url: result.secure_url,
        publicId: result.public_id,
        cloudinaryId: result.asset_id,
        width: result.width,
        height: result.height,
      };
    } catch (error) {
      this.logger.error('Cloudinary upload failed:', error);
      throw error;
    }
  }

  async deleteImage(publicId: string) {
    try {
      const result = await cloudinary.uploader.destroy(publicId);
      return result;
    } catch (error) {
      this.logger.error('Cloudinary delete failed:', error);
      throw error;
    }
  }
}
