import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'universities',
    pathMatch: 'full'
  },
  {
    path: 'universities',
    loadComponent: () => import('./pages/universities/universities.component').then(m => m.UniversitiesComponent)
  },
  {
    path: 'universities/:id/faculties',
    loadComponent: () => import('./pages/faculties/faculties.component').then(m => m.FacultiesComponent)
  },
  {
    path: 'faculties/:id/programs',
    loadComponent: () => import('./pages/programs/programs.component').then(m => m.ProgramsComponent)
  },
  {
    path: 'programs/:id/reviews',
    loadComponent: () => import('./pages/reviews/reviews.component').then(m => m.ReviewsComponent)
  }
];
