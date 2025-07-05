import { Component, computed, Input, signal } from '@angular/core';
import { NgIf, NgOptimizedImage } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';


export type MenuItem = {
  icon: string;
  label: string;
  route?: string;
}

@Component({
  selector: 'custom-sidenav',
  imports: [
    NgOptimizedImage, MatListModule, MatIconModule, NgIf,
  ],
  templateUrl: './custom-sidenav.html',
  styleUrl: './custom-sidenav.scss'
})
export class CustomSidenav {

  sideNavCollapsed = signal(false);
  @Input() set collapsed(value: boolean) {
    this.sideNavCollapsed.set(value);
  }

  menuItems = signal<MenuItem[]>([
    {
      icon: 'dashboard',
      label: 'Dashboard',
      route: 'dashboard'
    },
    {
      icon: 'settings',
      label: 'Settings',
      route: 'settings'
    },
    {
      icon: 'help',
      label: 'Help',
      route: 'help'
    },
    {
      icon: 'info',
      label: 'About',
      route: 'about'
    }
    ]);

  profilePicSize = computed(() => this.sideNavCollapsed() ? '32' : '100');
}
