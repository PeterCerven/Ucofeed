import {Component, OnInit} from '@angular/core';
import {UniversityComponent} from './university/university.component';
import {UniversityService} from '../../services/university.service';
import {Observable} from 'rxjs';
import {University} from '../../models/university.model';

@Component({
  selector: 'app-content',
  imports: [UniversityComponent],
  templateUrl: './content.component.html',
  styleUrl: './content.component.css'
})
export class ContentComponent implements OnInit {
  universities!: University[];

  constructor(private universityService: UniversityService) {
  }

  ngOnInit() {
    const obsUnis = this.universityService.getUniversities();
    obsUnis.subscribe((data: University[]) => this.universities = data);
  }
}
