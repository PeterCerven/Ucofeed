import {Component, Input} from '@angular/core';
import { University } from '../../../../models/university.model';

@Component({
  selector: 'app-university-card',
  imports: [],
  templateUrl: './university-card.component.html',
  styleUrl: './university-card.component.css'
})
export class UniversityCardComponent {
  @Input() university!: University;

}
