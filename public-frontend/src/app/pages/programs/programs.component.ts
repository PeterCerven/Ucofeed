import { Component, effect, inject, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { toSignal } from '@angular/core/rxjs-interop';
import {ProgramModel} from '@models/program.model';

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

  private paramMap = toSignal(this.route.paramMap);

  facultyName = signal('Faculty of Informatics');
  // programs = signal<ProgramModel[]>([]);

  programs = signal<ProgramModel[]>([
    { id: 1, name: 'Computer Science', entityType: 'program', review: 9, description: 'Comprehensive CS curriculum covering algorithms, data structures, and software engineering' },
    { id: 2, name: 'Information Systems', entityType: 'program', review: 8, description: 'Focus on business information systems and enterprise solutions' },
    { id: 3, name: 'Software Engineering', entityType: 'program', review: 9, description: 'Modern software development practices and methodologies' },
  ]);

  constructor() {
    effect(() => {
      const id = Number(this.paramMap()?.get('id'));

      if (id) {
        console.log('Faculty ID:', id);
        this.loadPrograms(id);
      }
    });
  }

  private loadPrograms(id: number) {
    // Your service call here
    // this.programs.set(result);
  }

  onProgramClick(programId: number) {
    this.router.navigate(['/programs', programId, 'reviews']);
  }
}
