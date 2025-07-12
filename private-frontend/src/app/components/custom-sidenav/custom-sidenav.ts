import { Component, computed, input, signal } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { RouterModule } from '@angular/router';


export type MenuItem = {
  icon: string;
  label: string;
  route?: string;
}

@Component({
  selector: 'custom-sidenav',
  imports: [
    MatListModule, MatIconModule, RouterModule
  ],
  templateUrl: './custom-sidenav.html',
  styleUrl: './custom-sidenav.scss'
})
export class CustomSidenav {

  collapsed = input<boolean>(false);

  menuItems = signal<MenuItem[]>([
    {
      icon: 'dashboard',
      label: 'Dashboard',
      route: 'dashboard'
    },
    {
      icon: 'table_chart',
      label: 'Tables',
      route: 'tables'
    },
    {
      icon: 'settings',
      label: 'Settings',
      route: 'settings'
    },
    ]);

  profilePicSize = computed(() => this.collapsed() ? '32' : '100');
}
