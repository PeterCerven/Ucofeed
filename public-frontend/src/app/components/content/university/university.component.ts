import {Component, Input, OnInit} from '@angular/core';
import {University} from '../../../models/university.model';
import {UniversityService} from '../../../services/university.service';
import {UniversityCardComponent} from './university-card/university-card.component';

@Component({
  selector: 'app-university',
  imports: [
    UniversityCardComponent
  ],
  templateUrl: './university.component.html',
  styleUrl: './university.component.scss'
})
export class UniversityComponent implements OnInit {
  universities!: University[];

  constructor(private universityService: UniversityService) {
  }

  ngOnInit() {
    const obsUnis = this.universityService.getUniversities();
    obsUnis.subscribe((data: University[]) => this.universities = data);
  }

}
