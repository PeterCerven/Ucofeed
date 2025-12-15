import { TestBed } from '@angular/core/testing';
import { HttpTestingController } from '@angular/common/http/testing';
import { DataService } from './data.service';
import { UniversityData } from '@models/csv-uni-data.model';
import { environment } from '@env/environment.production';
import { globalTestProviders } from '../../test-setup';

describe('DataService', () => {
  let service: DataService;
  let httpMock: HttpTestingController;
  const apiUrl = `${environment.apiUrl}/private`;

  const mockUniversityData: UniversityData[] = [
    {
      programmeName: 'Computer Science',
      academyTitle: 'Bachelor',
      studyForm: 'Full-time',
      universityName: 'Test University',
      facultyName: 'Faculty of Informatics',
      studyField: 'Computer Science',
      language: 'English'
    },
    {
      programmeName: 'Mathematics',
      academyTitle: 'Master',
      studyForm: 'Part-time',
      universityName: 'Test University',
      facultyName: 'Faculty of Mathematics',
      studyField: 'Mathematics',
      language: 'Slovak'
    }
  ];

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [...globalTestProviders]
    });
    service = TestBed.inject(DataService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('parseFile', () => {
    it('should send file to backend and return parsed data', () => {
      const mockFile = new File(['test content'], 'test.csv', { type: 'text/csv' });

      service.parseFile(mockFile).subscribe(data => {
        expect(data).toEqual(mockUniversityData);
        expect(data.length).toBe(2);
      });

      const req = httpMock.expectOne(`${apiUrl}/parse-file`);
      expect(req.request.method).toBe('POST');
      expect(req.request.body instanceof FormData).toBe(true);
      expect(req.request.body.has('file')).toBe(true);

      req.flush(mockUniversityData);
    });

    it('should handle file with correct FormData structure', () => {
      const mockFile = new File(['data'], 'universities.csv', { type: 'text/csv' });

      service.parseFile(mockFile).subscribe();

      const req = httpMock.expectOne(`${apiUrl}/parse-file`);
      const formData = req.request.body as FormData;
      const file = formData.get('file') as File;

      expect(file).toBeTruthy();
      expect(file.name).toBe('universities.csv');
      expect(file.type).toBe('text/csv');

      req.flush([]);
    });

    it('should handle empty response', () => {
      const mockFile = new File([''], 'empty.csv', { type: 'text/csv' });

      service.parseFile(mockFile).subscribe(data => {
        expect(data).toEqual([]);
      });

      const req = httpMock.expectOne(`${apiUrl}/parse-file`);
      req.flush([]);
    });

    it('should handle error response', () => {
      const mockFile = new File(['invalid'], 'invalid.csv', { type: 'text/csv' });
      const errorMessage = 'Invalid file format';

      service.parseFile(mockFile).subscribe({
        next: () => expect.fail('should have failed with error'),
        error: (error) => {
          expect(error.status).toBe(400);
          expect(error.error).toBe(errorMessage);
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/parse-file`);
      req.flush(errorMessage, { status: 400, statusText: 'Bad Request' });
    });
  });

  describe('saveData', () => {
    it('should send data to backend and return success message', () => {
      const successMessage = 'Data saved successfully';

      service.saveData(mockUniversityData).subscribe(response => {
        expect(response).toBe(successMessage);
      });

      const req = httpMock.expectOne(`${apiUrl}/upload-data`);
      expect(req.request.method).toBe('POST');
      expect(req.request.body).toEqual(mockUniversityData);
      expect(req.request.responseType).toBe('text');

      req.flush(successMessage);
    });

    it('should handle empty data array', () => {
      const successMessage = 'No data to save';

      service.saveData([]).subscribe(response => {
        expect(response).toBe(successMessage);
      });

      const req = httpMock.expectOne(`${apiUrl}/upload-data`);
      expect(req.request.body).toEqual([]);

      req.flush(successMessage);
    });

    it('should handle error response when saving data', () => {
      const errorMessage = 'Failed to save data';

      service.saveData(mockUniversityData).subscribe({
        next: () => expect.fail('should have failed with error'),
        error: (error) => {
          expect(error.status).toBe(500);
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/upload-data`);
      req.flush(errorMessage, { status: 500, statusText: 'Internal Server Error' });
    });
  });

  describe('showData', () => {
    it('should retrieve data from backend', () => {
      service.showData().subscribe(data => {
        expect(data).toEqual(mockUniversityData);
        expect(data.length).toBe(2);
      });

      const req = httpMock.expectOne(`${apiUrl}/data`);
      expect(req.request.method).toBe('GET');

      req.flush(mockUniversityData);
    });

    it('should handle empty data response', () => {
      service.showData().subscribe(data => {
        expect(data).toEqual([]);
      });

      const req = httpMock.expectOne(`${apiUrl}/data`);
      req.flush([]);
    });

    it('should handle error when retrieving data', () => {
      service.showData().subscribe({
        next: () => expect.fail('should have failed with error'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/data`);
      req.flush('Not found', { status: 404, statusText: 'Not Found' });
    });

    it('should handle network error', () => {
      const errorEvent = new ProgressEvent('error');

      service.showData().subscribe({
        next: () => expect.fail('should have failed with network error'),
        error: (error) => {
          expect(error.error).toBeTruthy();
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/data`);
      req.error(errorEvent);
    });
  });
});