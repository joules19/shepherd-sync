import { PartialType } from '@nestjs/swagger';
import { CreateEventDto } from './create-event.dto';

/**
 * DTO for updating an event
 * All fields from CreateEventDto are optional
 */
export class UpdateEventDto extends PartialType(CreateEventDto) {}
