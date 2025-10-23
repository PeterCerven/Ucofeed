import {Component, effect, inject, signal} from '@angular/core';
import { Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { CommonModule } from '@angular/common';
import {UniversityService} from '@services/university.service';
import {UniversityModel} from '@models/university.model';

@Component({
  selector: 'app-universities',
  standalone: true,
  imports: [CommonModule, EntityCardComponent],
  templateUrl: './universities.component.html',
  styleUrls: ['./universities.component.scss']
})
export class UniversitiesComponent {
  // Inject the Router using the new inject() function
  private router = inject(Router);
  private universityService = inject(UniversityService);

  // universities = signal<any[]>([]);

  // dummy data
  universities = signal<UniversityModel[]>([
    { id: 1, name: 'STU', image: '', entityType: 'university', review: 9, description: 'Slovak University of Technology in Bratislava' },
    { id: 2, name: 'STU', image: 'images/stu-logo.png', entityType: 'university', review: 9, description: 'Slovak University of Technology in Bratislava' },
    { id: 3, name: 'STU', image: 'images/stu-logo.png', entityType: 'university', review: 9, description: 'Slovak University of Technology in Bratislava' },
    { id: 4, name: 'STU', image: '', entityType: 'university', review: 6, description: 'Slovak University of Technology in Bratislava' },
    { id: 5, name: 'STU', image: 'images/stu-logo.png', entityType: 'university', review: 9, description: 'Slovak University of Technology in Bratislava' },
    { id: 6, name: 'STU', image: 'images/stu-logo.png', entityType: 'university', review: 5, description: 'Slovak University of Technology in Bratislava' },
    { id: 7, name: 'STU', image: 'images/stu-logo.png', entityType: 'university', review: 9, description: 'Slovak University of Technology in Bratislava' },
    { id: 8, name: 'STU', image: 'images/stu-logo.png', entityType: 'university', review: 2, description: 'Slovak University of Technology in Bratislava' },
  ]);

  constructor() {
    effect(() => {
      this.loadUniversities();
    });
  }

  private loadUniversities() {
    this.universityService.getUniversities().subscribe(data => {
      this.universities.set(data);
    });
  }

  onUniversityClick(universityId: number) {
    this.router.navigate(['/universities', universityId, 'faculties']);
  }
}
