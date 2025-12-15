import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { provideTransloco } from '@jsverse/transloco';
import { TranslocoHttpLoader } from '@services/transloco-loader.service';

// Global test providers that can be imported in test files
export const globalTestProviders = [
  provideHttpClient(),
  provideHttpClientTesting(),
  provideTransloco({
    config: {
      availableLangs: ['en', 'sk'],
      defaultLang: 'sk',
      reRenderOnLangChange: true,
      prodMode: true,
    },
    loader: TranslocoHttpLoader
  }),
];
