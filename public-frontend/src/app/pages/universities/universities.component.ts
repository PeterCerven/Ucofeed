import {Component, inject, OnInit, signal} from '@angular/core';
import { Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';
import { CommonModule } from '@angular/common';
import { TranslocoDirective } from '@jsverse/transloco';
import {UniversityService} from '@services/university.service';
import {UniversityModel} from '@models/university.model';

@Component({
  selector: 'app-universities',
  standalone: true,
  imports: [CommonModule, EntityCardComponent, TranslocoDirective],
  templateUrl: './universities.component.html',
  styleUrls: ['./universities.component.scss']
})
export class UniversitiesComponent implements OnInit {
  private router = inject(Router);
  private universityService = inject(UniversityService);

  universities = signal<UniversityModel[]>([]);

  ngOnInit() {
    console.log(this.universityService);
    this.loadUniversities();
  }

  private loadUniversities() {
    this.universityService.getUniversities().subscribe(data => {
      console.log('Loaded universities:', data);
      this.universities.set(data);
    });
  }

  onUniversityClick(universityId: number) {
    this.router.navigate(['/universities', universityId, 'faculties']);
  }
}
