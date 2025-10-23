import { Component, signal, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { TranslocoService } from '@jsverse/transloco';

@Component({
  selector: 'app-root',
  imports: [
    MatToolbar,
    MatIcon,
    MatIconModule,
    MatButtonModule,
    MatSidenavModule,
    RouterOutlet  // Add RouterOutlet
  ],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App {
  private translocoService = inject(TranslocoService);
  isDarkMode = signal(false);
  currentLanguage = signal('sk');

  toggleDarkMode() {
    this.isDarkMode.update(v => !v);

    if (this.isDarkMode()) {
      document.documentElement.classList.add('dark-mode');
    } else {
      document.documentElement.classList.remove('dark-mode');
    }
  }

  switchLanguage() {
    this.currentLanguage.set(this.currentLanguage() === 'sk' ? 'en' : 'sk');
    this.translocoService.setActiveLang(this.currentLanguage());
  }
}
