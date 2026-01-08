import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '@/core/database/prisma.service';
import { StripeService } from '@/core/stripe/stripe.service';
import { EmailService } from '@/core/email/email.service';
import { CreateEventDto, UpdateEventDto, QueryEventDto, RegisterEventDto } from './dto';
import { createPaginatedResponse, PaginatedResult } from '@/common/types/pagination.interface';
import { EventStatus, PaymentStatus, Prisma } from '@prisma/client';
import * as QRCode from 'qrcode';
import { randomBytes } from 'crypto';

/**
 * Events Service - Handles event management, registration, and QR codes
 */
@Injectable()
export class EventsService {
  constructor(
    private prisma: PrismaService,
    private stripeService: StripeService,
    private emailService: EmailService,
  ) {}

  /**
   * Create a new event with QR code
   */
  async create(createDto: CreateEventDto, organizationId: string, userId: string) {
    // Validate dates
    const startDate = new Date(createDto.startDate);
    const endDate = new Date(createDto.endDate);

    if (endDate <= startDate) {
      throw new BadRequestException('End date must be after start date');
    }

    if (createDto.registrationDeadline) {
      const deadline = new Date(createDto.registrationDeadline);
      if (deadline >= startDate) {
        throw new BadRequestException('Registration deadline must be before event start date');
      }
    }

    // Generate QR code data
    const qrCodeData = this.generateQRCodeData();

    const event = await this.prisma.event.create({
      data: {
        organizationId,
        createdBy: userId,
        title: createDto.title,
        description: createDto.description,
        eventType: createDto.eventType,
        startDate,
        endDate,
        timezone: createDto.timezone,
        location: createDto.location,
        address: createDto.address as any,
        isVirtual: createDto.isVirtual || false,
        virtualLink: createDto.virtualLink,
        requiresRegistration: createDto.requiresRegistration || false,
        maxAttendees: createDto.maxAttendees,
        registrationDeadline: createDto.registrationDeadline
          ? new Date(createDto.registrationDeadline)
          : null,
        registrationFee: createDto.registrationFee
          ? new Prisma.Decimal(createDto.registrationFee)
          : null,
        coverImage: createDto.coverImage,
        qrCode: qrCodeData,
        isPublic: createDto.isPublic !== undefined ? createDto.isPublic : true,
        targetAgeGroups: createDto.targetAgeGroups || [],
        targetRoles: createDto.targetRoles || [],
        status: createDto.status || EventStatus.DRAFT,
      },
      include: {
        creator: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
          },
        },
      },
    });

    return event;
  }

  /**
   * Get all events with filtering and pagination
   */
  async findAll(
    organizationId: string,
    query: QueryEventDto,
  ): Promise<PaginatedResult<any>> {
    const {
      page = 1,
      limit = 20,
      search,
      eventType,
      status,
      startAfter,
      startBefore,
      isVirtual,
      requiresRegistration,
      isPublic,
      sortBy = 'startDate',
      sortOrder = 'asc',
    } = query;

    const where: any = {
      organizationId,
    };

    // Search
    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    // Filters
    if (eventType) where.eventType = eventType;
    if (status) where.status = status;
    if (isVirtual !== undefined) where.isVirtual = isVirtual;
    if (requiresRegistration !== undefined) where.requiresRegistration = requiresRegistration;
    if (isPublic !== undefined) where.isPublic = isPublic;

    // Date range filter
    if (startAfter || startBefore) {
      where.startDate = {};
      if (startAfter) {
        where.startDate.gte = new Date(startAfter);
      }
      if (startBefore) {
        where.startDate.lte = new Date(startBefore);
      }
    }

    // Get total count
    const total = await this.prisma.event.count({ where });

    // Build orderBy
    const orderBy: any = {};
    orderBy[sortBy] = sortOrder;

    // Get paginated results
    const events = await this.prisma.event.findMany({
      where,
      skip: (page - 1) * limit,
      take: limit,
      orderBy,
      select: {
        id: true,
        title: true,
        description: true,
        eventType: true,
        startDate: true,
        endDate: true,
        location: true,
        isVirtual: true,
        requiresRegistration: true,
        maxAttendees: true,
        registrationFee: true,
        coverImage: true,
        isPublic: true,
        status: true,
        createdAt: true,
        creator: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
        _count: {
          select: {
            registrations: true,
          },
        },
      },
    });

    return createPaginatedResponse(events, total, page, limit);
  }

  /**
   * Get single event by ID with registration count
   */
  async findOne(id: string, organizationId: string) {
    const event = await this.prisma.event.findFirst({
      where: {
        id,
        organizationId,
      },
      include: {
        creator: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
          },
        },
        registrations: {
          take: 10,
          orderBy: { registeredAt: 'desc' },
          select: {
            id: true,
            guestName: true,
            attended: true,
            registeredAt: true,
            user: {
              select: {
                id: true,
                firstName: true,
                lastName: true,
                email: true,
              },
            },
          },
        },
        _count: {
          select: {
            registrations: true,
            attendanceRecords: true,
          },
        },
      },
    });

    if (!event) {
      throw new NotFoundException('Event not found');
    }

    return event;
  }

  /**
   * Update event
   */
  async update(
    id: string,
    updateDto: UpdateEventDto,
    organizationId: string,
    userId: string,
  ) {
    const event = await this.prisma.event.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!event) {
      throw new NotFoundException('Event not found');
    }

    // Only creator or admin can update
    // This check should be in the controller with roles guard, but double-check here
    if (event.createdBy !== userId) {
      // Allow admins to update any event (role check in controller)
    }

    // Validate dates if provided
    if (updateDto.startDate || updateDto.endDate) {
      const startDate = updateDto.startDate
        ? new Date(updateDto.startDate)
        : event.startDate;
      const endDate = updateDto.endDate ? new Date(updateDto.endDate) : event.endDate;

      if (endDate <= startDate) {
        throw new BadRequestException('End date must be after start date');
      }
    }

    const updated = await this.prisma.event.update({
      where: { id },
      data: {
        title: updateDto.title,
        description: updateDto.description,
        eventType: updateDto.eventType,
        startDate: updateDto.startDate ? new Date(updateDto.startDate) : undefined,
        endDate: updateDto.endDate ? new Date(updateDto.endDate) : undefined,
        timezone: updateDto.timezone,
        location: updateDto.location,
        address: updateDto.address as any,
        isVirtual: updateDto.isVirtual,
        virtualLink: updateDto.virtualLink,
        requiresRegistration: updateDto.requiresRegistration,
        maxAttendees: updateDto.maxAttendees,
        registrationDeadline: updateDto.registrationDeadline
          ? new Date(updateDto.registrationDeadline)
          : undefined,
        registrationFee: updateDto.registrationFee
          ? new Prisma.Decimal(updateDto.registrationFee)
          : undefined,
        coverImage: updateDto.coverImage,
        isPublic: updateDto.isPublic,
        targetAgeGroups: updateDto.targetAgeGroups,
        targetRoles: updateDto.targetRoles,
        status: updateDto.status,
      },
      include: {
        creator: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    return updated;
  }

  /**
   * Delete event (only if no registrations)
   */
  async remove(id: string, organizationId: string) {
    const event = await this.prisma.event.findFirst({
      where: {
        id,
        organizationId,
      },
      include: {
        _count: {
          select: {
            registrations: true,
          },
        },
      },
    });

    if (!event) {
      throw new NotFoundException('Event not found');
    }

    if (event._count.registrations > 0) {
      throw new BadRequestException(
        'Cannot delete event with existing registrations. Cancel the event instead.',
      );
    }

    await this.prisma.event.delete({
      where: { id },
    });

    return { message: 'Event deleted successfully' };
  }

  /**
   * Register for an event
   */
  async register(
    eventId: string,
    registerDto: RegisterEventDto,
    organizationId: string,
    userId?: string,
  ) {
    const event = await this.prisma.event.findFirst({
      where: {
        id: eventId,
        organizationId,
      },
      include: {
        _count: {
          select: {
            registrations: true,
          },
        },
      },
    });

    if (!event) {
      throw new NotFoundException('Event not found');
    }

    // Check if event is published
    if (event.status !== EventStatus.PUBLISHED) {
      throw new BadRequestException('Event is not open for registration');
    }

    // Check registration deadline
    if (event.registrationDeadline && new Date() > event.registrationDeadline) {
      throw new BadRequestException('Registration deadline has passed');
    }

    // Check if event is full
    if (event.maxAttendees && event._count.registrations >= event.maxAttendees) {
      throw new BadRequestException('Event is full');
    }

    // Validate registration: must have either userId, childId, or guest details
    if (!userId && !registerDto.childId && !registerDto.guestEmail) {
      throw new BadRequestException(
        'Must provide either user authentication, child ID, or guest email',
      );
    }

    // Check for duplicate registration
    if (userId) {
      const existing = await this.prisma.eventRegistration.findFirst({
        where: {
          eventId,
          userId,
        },
      });

      if (existing) {
        throw new ConflictException('You are already registered for this event');
      }
    }

    if (registerDto.guestEmail) {
      const existing = await this.prisma.eventRegistration.findFirst({
        where: {
          eventId,
          guestEmail: registerDto.guestEmail,
        },
      });

      if (existing) {
        throw new ConflictException('This email is already registered for this event');
      }
    }

    // Handle payment if there's a registration fee
    // Payment is OPTIONAL - allow registration without immediate payment (church-friendly)
    let paymentStatus: PaymentStatus = PaymentStatus.PENDING;
    let stripePaymentId: string | null = null;

    if (event.registrationFee && Number(event.registrationFee) > 0) {
      // Only process payment if payment method is provided
      if (registerDto.stripePaymentMethodId) {
        // Process payment with Stripe
        try {
          const paymentIntent = await this.stripeService.createPaymentIntent({
            amount: Number(event.registrationFee),
            currency: 'USD',
            paymentMethodId: registerDto.stripePaymentMethodId,
            metadata: {
              eventId,
              organizationId,
              userId: userId || '',
              eventTitle: event.title,
            },
          });

          paymentStatus = paymentIntent.status === 'succeeded'
            ? PaymentStatus.COMPLETED
            : PaymentStatus.PENDING;
          stripePaymentId = paymentIntent.id;
        } catch (error) {
          // Payment failed - still allow registration with PENDING status
          // Church can follow up on payment later
          paymentStatus = PaymentStatus.PENDING;
        }
      }
      // If no payment method provided, registration proceeds with PENDING status
      // This allows churches to accept registrations and collect payment later
    } else {
      // Free event - mark as completed
      paymentStatus = PaymentStatus.COMPLETED;
    }

    // Create registration
    const registration = await this.prisma.eventRegistration.create({
      data: {
        eventId,
        userId,
        childId: registerDto.childId,
        guestName: registerDto.guestName,
        guestEmail: registerDto.guestEmail,
        guestPhone: registerDto.guestPhone,
        paymentStatus,
        paymentAmount: event.registrationFee,
        stripePaymentId,
      },
      include: {
        event: {
          select: {
            id: true,
            title: true,
            startDate: true,
            location: true,
          },
        },
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
          },
        },
      },
    });

    // Send confirmation email
    await this.sendRegistrationConfirmation(registration);

    return registration;
  }

  /**
   * Cancel event registration
   */
  async cancelRegistration(
    eventId: string,
    organizationId: string,
    userId: string,
  ) {
    const registration = await this.prisma.eventRegistration.findFirst({
      where: {
        eventId,
        userId,
      },
      include: {
        event: true,
      },
    });

    if (!registration) {
      throw new NotFoundException('Registration not found');
    }

    if (registration.event.organizationId !== organizationId) {
      throw new ForbiddenException('Access denied');
    }

    // Check if event has already started
    if (new Date() >= registration.event.startDate) {
      throw new BadRequestException('Cannot cancel registration for events that have started');
    }

    // TODO: Handle refund if payment was made
    // if (registration.paymentStatus === PaymentStatus.COMPLETED && registration.stripePaymentId) {
    //   await this.stripeService.createRefund(registration.stripePaymentId);
    // }

    await this.prisma.eventRegistration.delete({
      where: { id: registration.id },
    });

    return { message: 'Registration cancelled successfully' };
  }

  /**
   * Get QR code for event (as data URL)
   */
  async getQRCode(id: string, organizationId: string): Promise<string> {
    const event = await this.prisma.event.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!event) {
      throw new NotFoundException('Event not found');
    }

    if (!event.qrCode) {
      throw new NotFoundException('QR code not generated for this event');
    }

    // Generate QR code as data URL
    const qrCodeDataUrl = await QRCode.toDataURL(event.qrCode);
    return qrCodeDataUrl;
  }

  /**
   * Get event statistics
   */
  async getStats(organizationId: string) {
    const [
      totalEvents,
      upcomingEvents,
      completedEvents,
      draftEvents,
      totalRegistrations,
      eventsByType,
    ] = await Promise.all([
      // Total events
      this.prisma.event.count({
        where: { organizationId },
      }),

      // Upcoming events
      this.prisma.event.count({
        where: {
          organizationId,
          status: EventStatus.PUBLISHED,
          startDate: { gte: new Date() },
        },
      }),

      // Completed events
      this.prisma.event.count({
        where: {
          organizationId,
          status: EventStatus.COMPLETED,
        },
      }),

      // Draft events
      this.prisma.event.count({
        where: {
          organizationId,
          status: EventStatus.DRAFT,
        },
      }),

      // Total registrations
      this.prisma.eventRegistration.count({
        where: {
          event: { organizationId },
        },
      }),

      // Events by type
      this.prisma.event.groupBy({
        by: ['eventType'],
        where: { organizationId },
        _count: true,
      }),
    ]);

    return {
      totalEvents,
      upcomingEvents,
      completedEvents,
      draftEvents,
      totalRegistrations,
      byType: eventsByType.map((e) => ({
        type: e.eventType,
        count: e._count,
      })),
    };
  }

  // ========================================
  // PRIVATE HELPER METHODS
  // ========================================

  private generateQRCodeData(): string {
    return `EVENT-${randomBytes(16).toString('hex').toUpperCase()}`;
  }

  private async sendRegistrationConfirmation(registration: any) {
    const email = registration.guestEmail || registration.user?.email;

    if (!email) {
      return;
    }

    const name = registration.guestName || `${registration.user?.firstName} ${registration.user?.lastName}`;

    await this.emailService.sendTransactional(email, 'event-registration', {
      name,
      eventTitle: registration.event.title,
      eventDate: registration.event.startDate.toLocaleDateString(),
      eventLocation: registration.event.location || 'TBA',
    });
  }
}
