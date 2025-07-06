import { Component, computed, input, Input, signal } from '@angular/core';
import { NgIf, NgOptimizedImage } from '@angular/common';
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
    NgOptimizedImage, MatListModule, MatIconModule, RouterModule
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
    ]);

  profilePicSize = computed(() => this.sideNavCollapsed() ? '32' : '100');
}
