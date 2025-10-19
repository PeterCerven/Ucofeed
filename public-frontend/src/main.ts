import { bootstrapApplication } from '@angular/platform-browser';
import { provideRouter } from '@angular/router';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideHttpClient } from '@angular/common/http';
import { TranslocoHttpLoader } from '@services/transloco-loader.service';
import { provideTransloco } from '@jsverse/transloco';
import { App } from '@app/app';
import { routes } from '@app/app.routes';

bootstrapApplication(App, {
  providers: [
    provideRouter(routes),
    provideAnimationsAsync(),
    provideHttpClient(),
    provideTransloco({
      config: {
        availableLangs: ['en', 'sk'],
        defaultLang: 'sk',
        reRenderOnLangChange: true,
        prodMode: false,
      },
      loader: TranslocoHttpLoader
    })
  ]
}).catch(err => console.error(err));
