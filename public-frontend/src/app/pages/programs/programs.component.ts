import { Component, effect, inject, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { toSignal } from '@angular/core/rxjs-interop';
import {ProgramModel} from '@models/program.model';
import { UniversityService } from '@services/university.service';

@Component({
  selector: 'app-programs',
  standalone: true,
  imports: [EntityCardComponent],
  templateUrl: './programs.component.html',
  styleUrl: './programs.component.scss'
})
export class ProgramsComponent {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private universityService = inject(UniversityService);

  private paramMap = toSignal(this.route.paramMap);

  facultyName = signal('Faculty of Informatics');
  programs = signal<ProgramModel[]>([]);
  isLoading = signal(false);

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

    // Fetch faculty name
    this.universityService.getFacultyById(facultyId).subscribe({
      next: (faculty) => {
        this.facultyName.set(faculty.name);
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
