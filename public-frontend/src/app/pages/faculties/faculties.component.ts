import { Component, effect, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { toSignal } from '@angular/core/rxjs-interop';
import { ActivatedRoute } from '@angular/router';
import {FacultyModel} from '@models/faculty.model';

@Component({
  selector: 'app-faculties',
  standalone: true,
  imports: [EntityCardComponent],
  templateUrl: './faculties.component.html',
  styleUrl: './faculties.component.scss'
})
export class FacultiesComponent {
  private route = inject(ActivatedRoute);
  private router = inject(Router);

  private paramMap = toSignal(this.route.paramMap);

  // TODO: (dynamic in future)
  universityName = signal('STU');
  faculties = signal<FacultyModel[]>([]);

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
    // Load faculties from service based on universityId
  }

  onFacultyClick(facultyId: number) {
    this.router.navigate(['/faculties', facultyId, 'programs']);
  }
}
