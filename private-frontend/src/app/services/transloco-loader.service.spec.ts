import { TestBed } from '@angular/core/testing';
import { HttpTestingController } from '@angular/common/http/testing';
import { TranslocoHttpLoader } from './transloco-loader.service';
import { Translation } from '@jsverse/transloco';
import { globalTestProviders } from '../../test-setup';

describe('TranslocoHttpLoader', () => {
  let service: TranslocoHttpLoader;
  let httpMock: HttpTestingController;

  const mockEnglishTranslation: Translation = {
    'welcome': 'Welcome',
    'login': 'Login',
    'logout': 'Logout',
    'settings': 'Settings'
  };

  const mockSlovakTranslation: Translation = {
    'welcome': 'Vitajte',
    'login': 'Prihlásiť sa',
    'logout': 'Odhlásiť sa',
    'settings': 'Nastavenia'
  };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [...globalTestProviders]
    });
    service = TestBed.inject(TranslocoHttpLoader);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getTranslation', () => {
    it('should load English translation file', () => {
      service.getTranslation('en').subscribe(translation => {
        expect(translation).toEqual(mockEnglishTranslation);
        expect(translation['welcome']).toBe('Welcome');
      });

      const req = httpMock.expectOne('/i18n/en.json');
      expect(req.request.method).toBe('GET');
      req.flush(mockEnglishTranslation);
    });

    it('should load Slovak translation file', () => {
      service.getTranslation('sk').subscribe(translation => {
        expect(translation).toEqual(mockSlovakTranslation);
        expect(translation['welcome']).toBe('Vitajte');
      });

      const req = httpMock.expectOne('/i18n/sk.json');
      expect(req.request.method).toBe('GET');
      req.flush(mockSlovakTranslation);
    });

    it('should load translation for any language code', () => {
      const mockFrenchTranslation: Translation = {
        'welcome': 'Bienvenue'
      };

      service.getTranslation('fr').subscribe(translation => {
        expect(translation).toEqual(mockFrenchTranslation);
      });

      const req = httpMock.expectOne('/i18n/fr.json');
      req.flush(mockFrenchTranslation);
    });

    it('should handle empty translation file', () => {
      const emptyTranslation: Translation = {};

      service.getTranslation('en').subscribe(translation => {
        expect(translation).toEqual({});
        expect(Object.keys(translation).length).toBe(0);
      });

      const req = httpMock.expectOne('/i18n/en.json');
      req.flush(emptyTranslation);
    });

    it('should handle nested translation objects', () => {
      const nestedTranslation: Translation = {
        'common': {
          'welcome': 'Welcome',
          'goodbye': 'Goodbye'
        },
        'auth': {
          'login': 'Login',
          'logout': 'Logout'
        }
      };

      service.getTranslation('en').subscribe(translation => {
        expect(translation).toEqual(nestedTranslation);
        expect(translation['common']['welcome']).toBe('Welcome');
        expect(translation['auth']['login']).toBe('Login');
      });

      const req = httpMock.expectOne('/i18n/en.json');
      req.flush(nestedTranslation);
    });

    it('should handle error when translation file not found', () => {
      service.getTranslation('unknown').subscribe({
        next: () => expect.fail('should have failed with 404 error'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne('/i18n/unknown.json');
      req.flush('File not found', { status: 404, statusText: 'Not Found' });
    });

    it('should handle malformed JSON in translation file', () => {
      service.getTranslation('en').subscribe({
        next: () => expect.fail('should have failed with parse error'),
        error: (error) => {
          expect(error.status).toBe(500);
        }
      });

      const req = httpMock.expectOne('/i18n/en.json');
      req.flush('invalid-json', { status: 500, statusText: 'Internal Server Error' });
    });

    it('should handle network error', () => {
      const errorEvent = new ProgressEvent('error');

      service.getTranslation('en').subscribe({
        next: () => expect.fail('should have failed with network error'),
        error: (error) => {
          expect(error.error).toBeTruthy();
        }
      });

      const req = httpMock.expectOne('/i18n/en.json');
      req.error(errorEvent);
    });

    it('should load translations for multiple languages sequentially', () => {
      // First request for English
      service.getTranslation('en').subscribe(translation => {
        expect(translation).toEqual(mockEnglishTranslation);
      });

      const enReq = httpMock.expectOne('/i18n/en.json');
      enReq.flush(mockEnglishTranslation);

      // Second request for Slovak
      service.getTranslation('sk').subscribe(translation => {
        expect(translation).toEqual(mockSlovakTranslation);
      });

      const skReq = httpMock.expectOne('/i18n/sk.json');
      skReq.flush(mockSlovakTranslation);
    });

    it('should construct correct URL path for translation files', () => {
      service.getTranslation('de').subscribe();

      const req = httpMock.expectOne('/i18n/de.json');
      expect(req.request.url).toBe('/i18n/de.json');
      expect(req.request.urlWithParams).toBe('/i18n/de.json');
      req.flush({});
    });

    it('should handle translation files with special characters in values', () => {
      const specialCharsTranslation: Translation = {
        'message': 'Hello! How are you? 你好',
        'special': 'Špeciálne znaky: č, ť, ž, ý, á, í, é',
        'emoji': 'Welcome 👋 to our app! 🎉'
      };

      service.getTranslation('sk').subscribe(translation => {
        expect(translation['message']).toBe('Hello! How are you? 你好');
        expect(translation['special']).toContain('Špeciálne');
        expect(translation['emoji']).toContain('👋');
      });

      const req = httpMock.expectOne('/i18n/sk.json');
      req.flush(specialCharsTranslation);
    });
  });
});