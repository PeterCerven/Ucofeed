import { Component, computed, effect, inject, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { BreadcrumbNavigationComponent, BreadcrumbItem } from '@components/breadcrumb-navigation/breadcrumb-navigation.component';
import { toSignal } from '@angular/core/rxjs-interop';
import { TranslocoDirective } from '@jsverse/transloco';
import {ProgramModel} from '@models/program.model';
import { UniversityService } from '@services/university.service';

@Component({
  selector: 'app-programs',
  standalone: true,
  imports: [EntityCardComponent, BreadcrumbNavigationComponent, TranslocoDirective],
  templateUrl: './programs.component.html',
  styleUrl: './programs.component.scss'
})
export class ProgramsComponent {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private universityService = inject(UniversityService);

  private paramMap = toSignal(this.route.paramMap);

  facultyName = signal('Faculty of Informatics');
  universityName = signal('');
  programs = signal<ProgramModel[]>([]);
  isLoading = signal(false);
  universityId = signal<number | null>(null);

  // Breadcrumb items
  breadcrumbItems = computed<BreadcrumbItem[]>(() => {
    const items: BreadcrumbItem[] = [];
    const univId = this.universityId();
    const univName = this.universityName();
    const facName = this.facultyName();

    if (univId && univName) {
      items.push({ label: univName, route: `/universities/${univId}/faculties` });
      items.push({ label: facName }); // Current page, no route
    }

    return items;
  });

  constructor() {
    effect(() => {
      const id = Number(this.paramMap()?.get('id'));

      if (id) {
        console.log('Faculty ID:', id);
        this.loadPrograms(id);
      }
    });
  }

  private loadPrograms(facultyId: number) {
    this.isLoading.set(true);

    // Fetch programs
    this.universityService.getProgramsByFaculty(facultyId).subscribe({
      next: (programs) => {
        this.programs.set(programs);
        this.isLoading.set(false);
      },
      error: (error) => {
        console.error('Error loading programs:', error);
        this.isLoading.set(false);
      },
    });

    // Fetch faculty name, universityId, and universityName
    this.universityService.getFacultyById(facultyId).subscribe({
      next: (faculty) => {
        this.facultyName.set(faculty.name);
        if (faculty.university_id) {
          this.universityId.set(faculty.university_id);
          // Fetch university name
          this.universityService.getUniversityById(faculty.university_id).subscribe({
            next: (university) => {
              this.universityName.set(university.name);
            },
            error: (error) => {
              console.error('Error loading university name:', error);
            },
          });
        }
        // Alternative: use university_name from faculty if available
        if (faculty.university_name) {
          this.universityName.set(faculty.university_name);
        }
      },
      error: (error) => {
        console.error('Error loading faculty name:', error);
      },
    });
  }

  onProgramClick(programId: number) {
    this.router.navigate(['/programs', programId, 'reviews']);
  }
}
