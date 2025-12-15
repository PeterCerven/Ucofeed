import { TestBed } from '@angular/core/testing';
import { HttpTestingController } from '@angular/common/http/testing';
import { UserService, UpdateUserRequest, UserResponse, UserEducationResponse } from './user.service';
import { environment } from '@env/environment.production';
import { globalTestProviders } from '../../test-setup';

describe('UserService', () => {
  let service: UserService;
  let httpMock: HttpTestingController;
  const baseUrl = environment.apiUrl;

  const mockEducation: UserEducationResponse = {
    id: 1,
    study_program_id: 101,
    study_program_name: 'Computer Science',
    faculty_id: 10,
    faculty_name: 'Faculty of Informatics',
    university_id: 1,
    university_name: 'Slovak University of Technology',
    study_program_variant_id: 201,
    study_format: 'Full-time',
    language: 'English',
    title: 'Bc.',
    status: 'Active'
  };

  const mockUserResponse: UserResponse = {
    id: 'user-uuid-123',
    full_name: 'John Doe',
    email: 'john.doe@example.com',
    educations: [mockEducation]
  };

  const mockUserWithMultipleEducations: UserResponse = {
    id: 'user-uuid-456',
    full_name: 'Jane Smith',
    email: 'jane.smith@example.com',
    educations: [
      mockEducation,
      {
        id: 2,
        study_program_id: 102,
        study_program_name: 'Software Engineering',
        faculty_id: 10,
        faculty_name: 'Faculty of Informatics',
        university_id: 1,
        university_name: 'Slovak University of Technology',
        study_program_variant_id: 202,
        study_format: 'Part-time',
        language: 'Slovak',
        title: 'Ing.',
        status: 'Completed'
      }
    ]
  };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [...globalTestProviders]
    });
    service = TestBed.inject(UserService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getUserById', () => {
    it('should retrieve user by ID with credentials', () => {
      const userId = 'user-uuid-123';

      service.getUserById(userId).subscribe(user => {
        expect(user).toEqual(mockUserResponse);
        expect(user.id).toBe(userId);
        expect(user.full_name).toBe('John Doe');
        expect(user.educations.length).toBe(1);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      expect(req.request.method).toBe('GET');
      expect(req.request.withCredentials).toBe(true);
      req.flush(mockUserResponse);
    });

    it('should retrieve user with multiple educations', () => {
      const userId = 'user-uuid-456';

      service.getUserById(userId).subscribe(user => {
        expect(user).toEqual(mockUserWithMultipleEducations);
        expect(user.educations.length).toBe(2);
        expect(user.educations[0].status).toBe('Active');
        expect(user.educations[1].status).toBe('Completed');
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush(mockUserWithMultipleEducations);
    });

    it('should retrieve user with no educations', () => {
      const userId = 'user-uuid-789';
      const userWithNoEducations: UserResponse = {
        id: userId,
        full_name: 'New User',
        email: 'new.user@example.com',
        educations: []
      };

      service.getUserById(userId).subscribe(user => {
        expect(user.educations).toEqual([]);
        expect(user.educations.length).toBe(0);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush(userWithNoEducations);
    });

    it('should handle 404 error when user not found', () => {
      const userId = 'non-existent-user';

      service.getUserById(userId).subscribe({
        next: () => expect.fail('should have failed with 404 error'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush('User not found', { status: 404, statusText: 'Not Found' });
    });

    it('should handle unauthorized access', () => {
      const userId = 'user-uuid-123';

      service.getUserById(userId).subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });

    it('should handle network error', () => {
      const userId = 'user-uuid-123';
      const errorEvent = new ProgressEvent('error');

      service.getUserById(userId).subscribe({
        next: () => expect.fail('should have failed with network error'),
        error: (error) => {
          expect(error.error).toBeTruthy();
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.error(errorEvent);
    });
  });

  describe('updateUser', () => {
    it('should update user with new education data', () => {
      const userId = 'user-uuid-123';
      const updateData: UpdateUserRequest = {
        studyProgramId: 102,
        studyProgramVariantId: 202,
        status: 'Active'
      };

      service.updateUser(userId, updateData).subscribe(user => {
        expect(user).toEqual(mockUserResponse);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      expect(req.request.method).toBe('PUT');
      expect(req.request.withCredentials).toBe(true);
      expect(req.request.body).toEqual(updateData);
      req.flush(mockUserResponse);
    });

    it('should handle updating user status', () => {
      const userId = 'user-uuid-456';
      const updateData: UpdateUserRequest = {
        studyProgramId: 101,
        studyProgramVariantId: 201,
        status: 'Completed'
      };

      service.updateUser(userId, updateData).subscribe(user => {
        expect(user.id).toBe(userId);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      expect(req.request.body.status).toBe('Completed');
      req.flush(mockUserWithMultipleEducations);
    });

    it('should handle validation error on update', () => {
      const userId = 'user-uuid-123';
      const invalidUpdateData: UpdateUserRequest = {
        studyProgramId: -1,
        studyProgramVariantId: -1,
        status: 'Invalid'
      };

      service.updateUser(userId, invalidUpdateData).subscribe({
        next: () => expect.fail('should have failed with 400 error'),
        error: (error) => {
          expect(error.status).toBe(400);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush('Invalid data', { status: 400, statusText: 'Bad Request' });
    });

    it('should handle unauthorized update attempt', () => {
      const userId = 'user-uuid-123';
      const updateData: UpdateUserRequest = {
        studyProgramId: 102,
        studyProgramVariantId: 202,
        status: 'Active'
      };

      service.updateUser(userId, updateData).subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });

    it('should handle forbidden update (different user)', () => {
      const userId = 'user-uuid-123';
      const updateData: UpdateUserRequest = {
        studyProgramId: 102,
        studyProgramVariantId: 202,
        status: 'Active'
      };

      service.updateUser(userId, updateData).subscribe({
        next: () => expect.fail('should have failed with 403 error'),
        error: (error) => {
          expect(error.status).toBe(403);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush('Forbidden', { status: 403, statusText: 'Forbidden' });
    });

    it('should handle server error during update', () => {
      const userId = 'user-uuid-123';
      const updateData: UpdateUserRequest = {
        studyProgramId: 102,
        studyProgramVariantId: 202,
        status: 'Active'
      };

      service.updateUser(userId, updateData).subscribe({
        next: () => expect.fail('should have failed with 500 error'),
        error: (error) => {
          expect(error.status).toBe(500);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user/${userId}`);
      req.flush('Server error', { status: 500, statusText: 'Internal Server Error' });
    });
  });

  describe('getAllUsers', () => {
    it('should retrieve all users with credentials', () => {
      const mockUsers: UserResponse[] = [
        mockUserResponse,
        mockUserWithMultipleEducations
      ];

      service.getAllUsers().subscribe(users => {
        expect(users).toEqual(mockUsers);
        expect(users.length).toBe(2);
        expect(users[0].id).toBe('user-uuid-123');
        expect(users[1].id).toBe('user-uuid-456');
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      expect(req.request.method).toBe('GET');
      expect(req.request.withCredentials).toBe(true);
      req.flush(mockUsers);
    });

    it('should handle empty user list', () => {
      service.getAllUsers().subscribe(users => {
        expect(users).toEqual([]);
        expect(users.length).toBe(0);
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      req.flush([]);
    });

    it('should retrieve large list of users', () => {
      const largeUserList: UserResponse[] = Array.from({ length: 100 }, (_, i) => ({
        id: `user-uuid-${i}`,
        full_name: `User ${i}`,
        email: `user${i}@example.com`,
        educations: []
      }));

      service.getAllUsers().subscribe(users => {
        expect(users.length).toBe(100);
        expect(users[0].id).toBe('user-uuid-0');
        expect(users[99].id).toBe('user-uuid-99');
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      req.flush(largeUserList);
    });

    it('should handle unauthorized access to all users', () => {
      service.getAllUsers().subscribe({
        next: () => expect.fail('should have failed with 401 error'),
        error: (error) => {
          expect(error.status).toBe(401);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      req.flush('Unauthorized', { status: 401, statusText: 'Unauthorized' });
    });

    it('should handle forbidden access (insufficient permissions)', () => {
      service.getAllUsers().subscribe({
        next: () => expect.fail('should have failed with 403 error'),
        error: (error) => {
          expect(error.status).toBe(403);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      req.flush('Forbidden', { status: 403, statusText: 'Forbidden' });
    });

    it('should handle server error when fetching all users', () => {
      service.getAllUsers().subscribe({
        next: () => expect.fail('should have failed with 500 error'),
        error: (error) => {
          expect(error.status).toBe(500);
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      req.flush('Server error', { status: 500, statusText: 'Internal Server Error' });
    });

    it('should handle network error', () => {
      const errorEvent = new ProgressEvent('error');

      service.getAllUsers().subscribe({
        next: () => expect.fail('should have failed with network error'),
        error: (error) => {
          expect(error.error).toBeTruthy();
        }
      });

      const req = httpMock.expectOne(`${baseUrl}/public/user`);
      req.error(errorEvent);
    });
  });
});