import { TestBed } from '@angular/core/testing';
import { HttpTestingController } from '@angular/common/http/testing';
import { ReviewService } from './review.service';
import { ReviewModel, CreateReviewDto, UpdateReviewDto, ReviewFilterOptions } from '@models/review.model';
import { CommentModel } from '@models/comment.model';
import { ProgramDetailsModel } from '@models/program-details.model';
import { environment } from '@env/environment.production';
import { globalTestProviders } from '../../test-setup';

describe('ReviewService', () => {
  let service: ReviewService;
  let httpMock: HttpTestingController;
  const baseUrl = environment.apiUrl;

  const mockReview: ReviewModel = {
    id: 1,
    studyProgramId: 101,
    studyProgramName: 'Computer Science',
    studyProgramVariantId: 201,
    language: 'English',
    studyForm: 'Full-time',
    title: 'Bc.',
    rating: 9,
    comment: 'Excellent program with great professors!',
    anonymous: false,
    created_at: '2024-03-15T10:00:00Z',
    updated_at: '2024-03-15T10:00:00Z',
    isEdited: false,
    commentsCount: 5,
    is_owner: true,
    user_email: 'john@example.com',
    user_full_name: 'John Doe'
  };

  const mockReviews: ReviewModel[] = [
    mockReview,
    {
      id: 2,
      studyProgramId: 101,
      studyProgramName: 'Computer Science',
      studyProgramVariantId: 201,
      language: 'English',
      studyForm: 'Full-time',
      title: 'Bc.',
      rating: 7,
      comment: 'Good program but challenging workload.',
      anonymous: true,
      created_at: '2023-06-20T14:30:00Z',
      updated_at: '2023-06-20T14:30:00Z',
      isEdited: false,
      commentsCount: 2,
      is_owner: false
    }
  ];

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [...globalTestProviders]
    });
    service = TestBed.inject(ReviewService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getProgramDetails', () => {
    it('should return program details', async () => {
      const programId = 1;

      const details = await new Promise<ProgramDetailsModel>((resolve) => {
        service.getProgramDetails(programId).subscribe(details => {
          resolve(details);
        });
      });

      expect(details).toBeTruthy();
      expect(details.id).toBe(1);
      expect(details.name).toBe('Computer Science');
      expect(details.rating).toBe(7.9);
      expect(details.totalReviews).toBe(5);
    });

    it('should return default program details for non-existent program', async () => {
      const programId = 999;

      const details = await new Promise<ProgramDetailsModel>((resolve) => {
        service.getProgramDetails(programId).subscribe(details => {
          resolve(details);
        });
      });

      expect(details).toBeTruthy();
      expect(details.id).toBe(1);
    });

    it('should return program details with rating distribution', async () => {
      const programId = 2;

      const details = await new Promise<ProgramDetailsModel>((resolve) => {
        service.getProgramDetails(programId).subscribe(details => {
          resolve(details);
        });
      });

      expect(details.ratingDistribution).toBeTruthy();
      expect(details.rating).toBe(8.0);
      expect(details.totalReviews).toBe(3);
    });

    it('should include program tags', async () => {
      const programId = 3;

      const details = await new Promise<ProgramDetailsModel>((resolve) => {
        service.getProgramDetails(programId).subscribe(details => {
          resolve(details);
        });
      });

      expect(details.tags).toBeTruthy();
      expect(details.tags.titles).toContain('Ing.');
      expect(details.tags.studyDegree).toBe(2);
      expect(details.tags.studyDuration).toBe(2);
    });
  });

  describe('getReviews', () => {
    it('should fetch reviews from backend', () => {
      const programId = 101;

      service.getReviews(programId).subscribe(reviews => {
        expect(reviews).toEqual(mockReviews);
        expect(reviews.length).toBe(2);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/program/${programId}`);
      expect(req.request.method).toBe('GET');
      expect(req.request.withCredentials).toBe(true);
      req.flush(mockReviews);
    });

    it('should handle empty review list', () => {
      const programId = 101;

      service.getReviews(programId).subscribe(reviews => {
        expect(reviews).toEqual([]);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/program/${programId}`);
      req.flush([]);
    });

    it('should return empty array when program not found (404)', () => {
      const programId = 999;
      const consoleSpy = vi.spyOn(console, 'warn').mockImplementation(() => {});

      service.getReviews(programId).subscribe(reviews => {
        expect(reviews).toEqual([]);
        expect(consoleSpy).toHaveBeenCalledWith('Returning empty array');
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/program/${programId}`);
      req.flush('Not found', { status: 404, statusText: 'Not Found' });

      consoleSpy.mockRestore();
    });

    it('should return empty array on server error', () => {
      const programId = 101;
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});

      service.getReviews(programId).subscribe(reviews => {
        expect(reviews).toEqual([]);
        expect(consoleSpy).toHaveBeenCalled();
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/program/${programId}`);
      req.flush('Server error', { status: 500, statusText: 'Internal Server Error' });

      consoleSpy.mockRestore();
    });

    it('should pass filters parameter', () => {
      const programId = 101;
      const filters: ReviewFilterOptions = { sortBy: 'newest' };

      service.getReviews(programId, filters).subscribe();

      const req = httpMock.expectOne(`${baseUrl}/public/review/program/${programId}`);
      req.flush(mockReviews);
    });
  });

  describe('createReview', () => {
    it('should create a new review', () => {
      const createDto: CreateReviewDto = {
        studyProgramId: 101,
        comment: 'Great program!',
        rating: 9,
        anonymous: false
      };

      service.createReview(createDto).subscribe(review => {
        expect(review).toEqual(mockReview);
        expect(review.rating).toBe(9);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review`);
      expect(req.request.method).toBe('POST');
      expect(req.request.withCredentials).toBe(true);
      expect(req.request.body).toEqual(createDto);
      req.flush(mockReview);
    });

    it('should create anonymous review', () => {
      const createDto: CreateReviewDto = {
        studyProgramId: 101,
        comment: 'Honest feedback',
        rating: 7,
        anonymous: true
      };

      service.createReview(createDto).subscribe(review => {
        expect(review.anonymous).toBe(true);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review`);
      expect(req.request.body.anonymous).toBe(true);
      req.flush({ ...mockReview, anonymous: true });
    });

    it('should handle validation error', () => {
      const invalidDto: CreateReviewDto = {
        studyProgramId: 101,
        comment: '',
        rating: 15,
        anonymous: false
      };

      service.createReview(invalidDto).subscribe({
        next: () => expect.fail('should have failed with 400 error'),
        error: (error) => {
          expect(error.status).toBe(400);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review`);
      req.flush('Invalid data', { status: 400, statusText: 'Bad Request' });
    });

    it('should handle unauthorized creation', () => {
      const createDto: CreateReviewDto = {
        studyProgramId: 101,
        comment: 'Test',
        rating: 8,
        anonymous: false
      };

      service.createReview(createDto).subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });

    it('should handle duplicate review error', () => {
      const createDto: CreateReviewDto = {
        studyProgramId: 101,
        comment: 'Another review',
        rating: 9,
        anonymous: false
      };

      service.createReview(createDto).subscribe({
        next: () => expect.fail('should have failed with 409 error'),
        error: (error) => {
          expect(error.status).toBe(409);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review`);
      req.flush('Review already exists', { status: 409, statusText: 'Conflict' });
    });
  });

  describe('updateReview', () => {
    it('should update an existing review', () => {
      const reviewId = 1;
      const updateDto: UpdateReviewDto = {
        rating: 10,
        comment: 'Updated: Even better than I thought!',
        anonymous: false
      };

      const updatedReview = {
        ...mockReview,
        rating: 10,
        comment: 'Updated: Even better than I thought!',
        updated_at: '2024-03-20T12:00:00Z',
        isEdited: true
      };

      service.updateReview(reviewId, updateDto).subscribe(review => {
        expect(review.rating).toBe(10);
        expect(review.comment).toContain('Updated:');
        expect(review.isEdited).toBe(true);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      expect(req.request.method).toBe('PUT');
      expect(req.request.withCredentials).toBe(true);
      expect(req.request.body).toEqual(updateDto);
      req.flush(updatedReview);
    });

    it('should update review anonymity', () => {
      const reviewId = 1;
      const updateDto: UpdateReviewDto = {
        rating: 9,
        comment: 'Great program!',
        anonymous: true
      };

      service.updateReview(reviewId, updateDto).subscribe(review => {
        expect(review.anonymous).toBe(true);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      expect(req.request.body.anonymous).toBe(true);
      req.flush({ ...mockReview, anonymous: true });
    });

    it('should handle unauthorized update', () => {
      const reviewId = 1;
      const updateDto: UpdateReviewDto = {
        rating: 10,
        comment: 'Updated',
        anonymous: false
      };

      service.updateReview(reviewId, updateDto).subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });

    it('should handle forbidden update (not owner)', () => {
      const reviewId = 2;
      const updateDto: UpdateReviewDto = {
        rating: 10,
        comment: 'Updated',
        anonymous: false
      };

      service.updateReview(reviewId, updateDto).subscribe({
        next: () => expect.fail('should have failed with 403 error'),
        error: (error) => {
          expect(error.status).toBe(403);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      req.flush('Forbidden', { status: 403, statusText: 'Forbidden' });
    });

    it('should handle review not found', () => {
      const reviewId = 999;
      const updateDto: UpdateReviewDto = {
        rating: 10,
        comment: 'Updated',
        anonymous: false
      };

      service.updateReview(reviewId, updateDto).subscribe({
        next: () => expect.fail('should have failed with 404 error'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      req.flush('Not found', { status: 404, statusText: 'Not Found' });
    });
  });

  describe('deleteReview', () => {
    it('should delete a review', () => {
      const reviewId = 1;

      service.deleteReview(reviewId).subscribe(response => {
        expect(response).toBeNull();
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      expect(req.request.method).toBe('DELETE');
      expect(req.request.withCredentials).toBe(true);
      req.flush(null);
    });

    it('should handle deletion of different review IDs', () => {
      const reviewId = 42;

      service.deleteReview(reviewId).subscribe();

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      expect(req.request.method).toBe('DELETE');
      expect(req.request.url).toContain('42');
      req.flush(null);
    });

    it('should handle unauthorized deletion', () => {
      const reviewId = 1;

      service.deleteReview(reviewId).subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });

    it('should handle forbidden deletion (not owner)', () => {
      const reviewId = 2;

      service.deleteReview(reviewId).subscribe({
        next: () => expect.fail('should have failed with 403 error'),
        error: (error) => {
          expect(error.status).toBe(403);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      req.flush('Forbidden', { status: 403, statusText: 'Forbidden' });
    });

    it('should handle review not found during deletion', () => {
      const reviewId = 999;

      service.deleteReview(reviewId).subscribe({
        next: () => expect.fail('should have failed with 404 error'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/${reviewId}`);
      req.flush('Not found', { status: 404, statusText: 'Not Found' });
    });
  });

  describe('canCreateReview', () => {
    it('should check if user can create review', () => {
      const studyProgramId = 101;

      service.canCreateReview(studyProgramId).subscribe(canCreate => {
        expect(canCreate).toBe(true);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/can-review/${studyProgramId}`);
      expect(req.request.method).toBe('GET');
      expect(req.request.withCredentials).toBe(true);
      req.flush(true);
    });

    it('should return false when user cannot create review', () => {
      const studyProgramId = 102;

      service.canCreateReview(studyProgramId).subscribe(canCreate => {
        expect(canCreate).toBe(false);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/can-review/${studyProgramId}`);
      req.flush(false);
    });

    it('should handle unauthorized check', () => {
      const studyProgramId = 101;

      service.canCreateReview(studyProgramId).subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/review/can-review/${studyProgramId}`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });
  });

  describe('createComment', () => {
    it('should create a comment', async () => {
      const reviewId = 1;
      const commentText = 'This is a test comment';

      const comment = await new Promise<CommentModel>((resolve) => {
        service.createComment(reviewId, commentText).subscribe(comment => {
          resolve(comment);
        });
      });

      expect(comment).toBeTruthy();
      expect(comment.commentText).toBe(commentText);
      expect(comment.userName).toBe('Current User');
      expect(comment.isEdited).toBe(false);
    });

    it('should create comment with current timestamp', async () => {
      const reviewId = 1;
      const commentText = 'Another comment';

      const beforeTime = Date.now();

      const comment = await new Promise<CommentModel>((resolve) => {
        service.createComment(reviewId, commentText).subscribe(comment => {
          resolve(comment);
        });
      });

      const afterTime = Date.now();
      expect(comment.id).toBeGreaterThanOrEqual(beforeTime);
      expect(comment.id).toBeLessThanOrEqual(afterTime);
    });
  });
});
