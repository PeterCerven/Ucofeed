import { TestBed } from '@angular/core/testing';
import { App } from './app';
import { provideTransloco } from '@jsverse/transloco';
import { TranslocoHttpLoader } from '@services/transloco-loader.service';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';

describe('App', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [App],
      providers: [
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
        })
      ]
    }).compileComponents();
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(App);
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

});
