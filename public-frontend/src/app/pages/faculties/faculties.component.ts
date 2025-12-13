import { Component, effect, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { BackNavigationComponent } from '@components/back-navigation/back-navigation.component';
import { toSignal } from '@angular/core/rxjs-interop';
import { ActivatedRoute } from '@angular/router';
import { TranslocoDirective } from '@jsverse/transloco';
import {FacultyModel} from '@models/faculty.model';
import { UniversityService } from '@services/university.service';

@Component({
  selector: 'app-faculties',
  standalone: true,
  imports: [EntityCardComponent, BackNavigationComponent, TranslocoDirective],
  templateUrl: './faculties.component.html',
  styleUrl: './faculties.component.scss'
})
export class FacultiesComponent {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private universityService = inject(UniversityService);

  private paramMap = toSignal(this.route.paramMap);

  universityName = signal('STU');
  faculties = signal<FacultyModel[]>([]);
  isLoading = signal(false);

  constructor() {
    // Effect runs whenever route param 'id' changes
    effect(() => {
      const idStr = this.paramMap()?.get('id');
      const universityId = idStr ? Number(idStr) : null;

      if (universityId !== null) {
        console.log('University ID:', universityId);

        // Load faculties for this university
        this.loadFaculties(universityId);
      }
    });
  }

  private loadFaculties(universityId: number) {
    this.isLoading.set(true);

    // Fetch faculties
    this.universityService.getFacultiesByUniversity(universityId).subscribe({
      next: (faculties) => {
        this.faculties.set(faculties);
        this.isLoading.set(false);
      },
      error: (error) => {
        console.error('Error loading faculties:', error);
        this.isLoading.set(false);
      },
    });

    // Fetch university name
    this.universityService.getUniversityById(universityId).subscribe({
      next: (university) => {
        this.universityName.set(university.name);
      },
      error: (error) => {
        console.error('Error loading university name:', error);
      },
    });
  }

  onFacultyClick(facultyId: number) {
    this.router.navigate(['/faculties', facultyId, 'programs']);
  }
}
