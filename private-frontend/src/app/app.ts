import { Component, computed, signal, effect } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { CustomSidenav } from './components/custom-sidenav/custom-sidenav';


@Component({
  selector: 'app-root',
  imports: [RouterOutlet, MatToolbar, MatIcon, MatIconModule, MatButtonModule,
    MatSidenavModule, CustomSidenav],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App {
  protected title = 'private-frontend';

  constructor() {
    // effect(() => {
    //   console.log(this.collapsed());
    //   console.log(`SideNav width: ${this.sideNavWidth()}`);
    // });
  }


  collapsed = signal(false);

  sideNavWidth = computed(() => this.collapsed() ? '60px' : '250px');
}
