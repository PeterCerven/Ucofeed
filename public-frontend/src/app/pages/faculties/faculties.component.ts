import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';

@Component({
  selector: 'app-faculties',
  standalone: true,
  imports: [EntityCardComponent],
  templateUrl: './faculties.component.html',
  styleUrl: './faculties.component.scss'
})
export class FacultiesComponent implements OnInit {
  universityId!: number;
  universityName = 'STU';

  constructor(
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit() {
    this.universityId = Number(this.route.snapshot.paramMap.get('id'));
    // Load faculties from service based on universityId
  }

  onFacultyClick(facultyId: number) {
    this.router.navigate(['/faculties', facultyId, 'programs']);
  }
}
