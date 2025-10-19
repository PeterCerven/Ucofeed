import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { EntityCardComponent } from '@components/entity-card/entity-card.component';

@Component({
  selector: 'app-programs',
  standalone: true,
  imports: [EntityCardComponent],
  templateUrl: './programs.component.html',
  styleUrl: './programs.component.scss'
})
export class ProgramsComponent implements OnInit {
  facultyId!: number;
  facultyName = 'Faculty of Informatics';

  constructor(private route: ActivatedRoute) {}

  ngOnInit() {
    this.facultyId = Number(this.route.snapshot.paramMap.get('id'));
    // Load programs from service based on facultyId
  }
}
