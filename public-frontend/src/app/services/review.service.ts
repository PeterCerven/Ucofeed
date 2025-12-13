import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, catchError } from 'rxjs';
import { ReviewModel, ReviewFilterOptions, CreateReviewDto, UpdateReviewDto } from '@models/review.model';
import { CommentModel } from '@models/comment.model';
import { ProgramDetailsModel } from '@models/program-details.model';
import { environment } from '@env/environment.production';

@Injectable({
  providedIn: 'root',
})
export class ReviewService {
  private http = inject(HttpClient);
  private baseUrl = environment.apiUrl;

  // Mock data for comments
  private mockComments: { [reviewId: number]: CommentModel[] } = {
    1: [
      {
        id: 1,
        userName: 'Sarah Williams',
        commentText: 'I totally agree about the career support! Got my job through their career fair.',
        createdAt: '2024-03-16T09:00:00',
        updatedAt: '2024-03-16T09:00:00',
        isEdited: false,
      },
      {
        id: 2,
        userName: 'Tom Anderson',
        commentText: 'Which professors would you recommend for the advanced courses?',
        createdAt: '2024-03-17T14:30:00',
        updatedAt: '2024-03-17T14:30:00',
        isEdited: false,
      },
      {
        id: 3,
        userName: 'John Doe',
        commentText: 'Dr. Smith and Dr. Johnson are excellent for advanced topics!',
        createdAt: '2024-03-18T10:15:00',
        updatedAt: '2024-03-18T10:20:00',
        isEdited: true,
      },
    ],
    2: [
      {
        id: 4,
        userName: 'Lisa Davis',
        commentText: 'Thanks for the honest review. Good to know about the labs.',
        createdAt: '2023-06-21T11:00:00',
        updatedAt: '2023-06-21T11:00:00',
        isEdited: false,
      },
    ],
    3: [
      {
        id: 5,
        userName: 'Chris Martinez',
        commentText: 'Can you share more about the internship opportunities?',
        createdAt: '2024-08-11T08:30:00',
        updatedAt: '2024-08-11T08:30:00',
        isEdited: false,
      },
      {
        id: 6,
        userName: 'Alex Johnson',
        commentText: 'Sure! Most students intern at top tech companies. The program has partnerships with Google, Microsoft, and local startups.',
        createdAt: '2024-08-11T12:00:00',
        updatedAt: '2024-08-11T12:00:00',
        isEdited: false,
      },
      {
        id: 7,
        userName: 'Emily White',
        commentText: 'That sounds amazing! Definitely applying for next year.',
        createdAt: '2024-08-12T09:15:00',
        updatedAt: '2024-08-12T09:15:00',
        isEdited: false,
      },
      {
        id: 8,
        userName: 'David Lee',
        commentText: 'What about international internships?',
        createdAt: '2024-08-13T15:45:00',
        updatedAt: '2024-08-13T15:45:00',
        isEdited: false,
      },
      {
        id: 9,
        userName: 'Alex Johnson',
        commentText: 'Yes, there are opportunities in Europe and Asia through exchange programs!',
        createdAt: '2024-08-14T10:00:00',
        updatedAt: '2024-08-14T10:00:00',
        isEdited: false,
      },
    ],
    4: [
      {
        id: 10,
        userName: 'Robert Taylor',
        commentText: 'I had a similar experience. The workload was intense.',
        createdAt: '2022-12-06T16:20:00',
        updatedAt: '2022-12-06T16:20:00',
        isEdited: false,
      },
      {
        id: 11,
        userName: 'Maria Garcia',
        commentText: 'Yes, time management is crucial for this program.',
        createdAt: '2022-12-07T11:30:00',
        updatedAt: '2022-12-07T11:30:00',
        isEdited: false,
      },
    ],
  };

  // Mock program details for different programs
  private mockProgramDetails: { [programId: number]: ProgramDetailsModel } = {
    1: {
      id: 1,
      name: 'Computer Science',
      description:
        'Comprehensive CS curriculum covering algorithms, data structures, software engineering, artificial intelligence, and more. This program prepares students for careers in software development, research, and technology innovation.',
      faculty_name: 'Faculty of Informatics',
      university_name: 'Slovak University of Technology',
      averageRating: 7.9,
      totalReviews: 5,
      ratingDistribution: {
        6: 1,
        7: 1,
        8: 1,
        9: 2,
      },
      tags: {
        title: 'Bc.',
        studyDegree: 1, // Bachelor
        studyFormat: 'Full-time / Part-time',
        studyDuration: 3,
        languageGroup: 'Slovak / English',
      },
    },
    2: {
      id: 2,
      name: 'Information Systems',
      description:
        'Focus on business information systems and enterprise solutions with emphasis on database management, system analysis, and IT project management.',
      faculty_name: 'Faculty of Informatics',
      university_name: 'Slovak University of Technology',
      averageRating: 8.0,
      totalReviews: 3,
      ratingDistribution: {
        7: 1,
        8: 1,
        9: 1,
      },
      tags: {
        title: 'Bc.',
        studyDegree: 1, // Bachelor
        studyFormat: 'Full-time',
        studyDuration: 3,
        languageGroup: 'Slovak',
      },
    },
    3: {
      id: 3,
      name: 'Software Engineering',
      description:
        'Modern software development practices and methodologies including agile development, DevOps, cloud computing, and software architecture.',
      faculty_name: 'Faculty of Informatics',
      university_name: 'Slovak University of Technology',
      averageRating: 8.5,
      totalReviews: 4,
      ratingDistribution: {
        8: 2,
        9: 2,
      },
      tags: {
        title: 'Ing.',
        studyDegree: 2, // Master
        studyFormat: 'Full-time',
        studyDuration: 2,
        languageGroup: 'Slovak / English',
      },
    },
  };

  /**
   * Get program details with statistics
   */
  getProgramDetails(programId: number): Observable<ProgramDetailsModel> {
    const details = this.mockProgramDetails[programId] || this.mockProgramDetails[1];
    return of(details).pipe(delay(300)); // Simulate network delay
  }

  /**
   * Get reviews for a program from backend (with fallback to mock data)
   */
  getReviews(
    programId: number,
    filters?: ReviewFilterOptions
  ): Observable<ReviewModel[]> {
    // Try backend first
    return this.http.get<ReviewModel[]>(
      `${this.baseUrl}/public/review/program/${programId}`,
      { withCredentials: true }
    ).pipe(
      catchError(error => {
        // Backend not implemented yet - return empty array for now
        if (error.status === 404) {
          console.warn('Review endpoints not implemented yet, returning empty array');
          return of([]);
        }
        // // For other errors, fallback to mock data
        console.error('Error fetching reviews:', error);
        // return of(this.getMockReviews(programId, filters));
        return of([]);
      })
    );
  }

  /**
   * Get mock reviews (fallback for development)
   */
  // private getMockReviews(
  //   programId: number,
  //   filters?: ReviewFilterOptions
  // ): ReviewModel[] {
  //   let reviews = [...this.mockReviews];
  //
  //   // Apply sorting
  //   if (filters) {
  //     switch (filters.sortBy) {
  //       case 'newest':
  //         reviews.sort(
  //           (a, b) =>
  //             new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
  //         );
  //         break;
  //       case 'oldest':
  //         reviews.sort(
  //           (a, b) =>
  //             new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
  //         );
  //         break;
  //       case 'highest':
  //         reviews.sort((a, b) => b.rating - a.rating);
  //         break;
  //       case 'lowest':
  //         reviews.sort((a, b) => a.rating - b.rating);
  //         break;
  //       case 'edited':
  //         reviews.sort(
  //           (a, b) =>
  //             new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
  //         );
  //         break;
  //     }
  //   }
  //
  //   return reviews;
  // }

  /**
   * Get comments for a specific review
   */
  getComments(reviewId: number): Observable<CommentModel[]> {
    const comments = [];
    return of().pipe(delay(300)); // Simulate network delay
  }

  /**
   * Create a new review (calls backend API)
   */
  createReview(reviewDto: CreateReviewDto): Observable<ReviewModel> {
    return this.http.post<ReviewModel>(
      `${this.baseUrl}/public/review`,
      reviewDto,
      { withCredentials: true }
    );
  }

  /**
   * Update an existing review (requires authentication and ownership)
   */
  updateReview(reviewId: number, reviewDto: UpdateReviewDto): Observable<ReviewModel> {
    return this.http.put<ReviewModel>(
      `${this.baseUrl}/public/review/${reviewId}`,
      reviewDto,
      { withCredentials: true }
    );
  }

  /**
   * Delete a review (requires authentication and ownership)
   */
  deleteReview(reviewId: number): Observable<void> {
    return this.http.delete<void>(
      `${this.baseUrl}/public/review/${reviewId}`,
      { withCredentials: true }
    );
  }

  /**
   * Check if current user can create a review for a study program
   */
  canCreateReview(studyProgramId: number): Observable<boolean> {
    return this.http.get<boolean>(
      `${this.baseUrl}/public/review/can-review/${studyProgramId}`,
      { withCredentials: true }
    );
  }

  /**
   * Create a new comment (future implementation - requires auth)
   */
  createComment(
    reviewId: number,
    commentText: string
  ): Observable<CommentModel> {
    const newComment: CommentModel = {
      id: Date.now(),
      userName: 'Current User',
      commentText,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      isEdited: false,
    };
    return of(newComment).pipe(delay(500));
  }
}
