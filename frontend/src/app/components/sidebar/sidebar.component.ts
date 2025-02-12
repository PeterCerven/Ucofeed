import {Component} from '@angular/core';
import {CommonModule, NgOptimizedImage} from '@angular/common';
import {FormsModule} from '@angular/forms';
import {faChevronLeft, faChevronRight} from '@fortawesome/free-solid-svg-icons';
import {FaIconComponent} from '@fortawesome/angular-fontawesome';

@Component({
  selector: 'app-sidebar',
  imports: [CommonModule, FormsModule, NgOptimizedImage, FaIconComponent],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css'
})
export class SidebarComponent {
  isSidebarOpen = true;
  faChevronLeft = faChevronLeft;
  faChevronRight = faChevronRight;

  toggleSidebar() {
    this.isSidebarOpen = !this.isSidebarOpen;
  }
}
