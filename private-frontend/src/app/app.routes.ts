import { Routes } from '@angular/router';
import { Dashboard } from './pages/dashboard/dashboard';
import { Settings } from './pages/settings/settings';
import { Tables } from './pages/tables/tables';

export const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'dashboard'
  },
  {
    path: 'dashboard',
    component: Dashboard,
  },
  {
    path: 'tables',
    component: Tables,
  },
  {
    path: 'settings',
    component: Settings,
  }
];
