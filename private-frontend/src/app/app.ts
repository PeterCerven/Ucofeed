import { Component, computed, signal, effect, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { CustomSidenav } from '@components/custom-sidenav/custom-sidenav';
import { TranslocoService } from '@jsverse/transloco';


@Component({
  selector: 'app-root',
  imports: [RouterOutlet, MatToolbar, MatIcon, MatIconModule, MatButtonModule,
    MatSidenavModule, CustomSidenav],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App {
  private translocoService = inject(TranslocoService);
  collapsed = signal(false);
  sideNavWidth = computed(() => this.collapsed() ? '60px' : '250px');
  isDarkMode = signal(false);
  currentLanguage = signal('SK')

  toggleDarkMode() {
    this.isDarkMode.update(v => !v);

    if (this.isDarkMode()) {
      document.body.classList.add('dark-mode');
    } else {
      document.body.classList.remove('dark-mode');
    }
  }

  switchLanguage() {
    this.translocoService.setActiveLang(this.currentLanguage() === 'SK' ? 'en' : 'sk');
    this.currentLanguage.set(this.currentLanguage() === 'SK' ? 'EN' : 'SK');
  }
}
