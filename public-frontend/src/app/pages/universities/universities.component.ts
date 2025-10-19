import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-universities',
  standalone: true,
  imports: [CommonModule, EntityCardComponent],
  templateUrl: './universities.component.html',
  styleUrl: './universities.component.scss'
})
export class UniversitiesComponent {
  constructor(private router: Router) {}

  onUniversityClick(universityId: number) {
    this.router.navigate(['/universities', universityId, 'faculties']);
  }
}
