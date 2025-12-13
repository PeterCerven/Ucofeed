import { Component, inject, input } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-back-navigation',
  standalone: true,
  imports: [MatButtonModule, MatIconModule, MatTooltipModule],
  templateUrl: './back-navigation.component.html',
  styleUrl: './back-navigation.component.scss'
})
export class BackNavigationComponent {
  private router = inject(Router);

  backRoute = input.required<string>();
  backLabel = input.required<string>();

  navigateBack(): void {
    this.router.navigate([this.backRoute()]);
  }
}
