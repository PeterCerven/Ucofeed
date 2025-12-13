import { Component, inject, input } from '@angular/core';
import { Router } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { CommonModule } from '@angular/common';

export interface BreadcrumbItem {
  label: string;
  route?: string; // If undefined, it's the current page (not clickable)
}

@Component({
  selector: 'app-breadcrumb-navigation',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  templateUrl: './breadcrumb-navigation.component.html',
  styleUrl: './breadcrumb-navigation.component.scss'
})
export class BreadcrumbNavigationComponent {
  private router = inject(Router);

  items = input.required<BreadcrumbItem[]>();

  navigateTo(route: string | undefined): void {
    if (route) {
      this.router.navigate([route]);
    }
  }
}
