import {Component, Input} from '@angular/core';

@Component({
  selector: 'app-university',
  imports: [],
  templateUrl: './university.component.html',
  styleUrl: './university.component.css'
})
export class UniversityComponent {
  @Input() university!: any;

}
