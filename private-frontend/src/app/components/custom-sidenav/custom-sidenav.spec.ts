import { ComponentFixture, TestBed } from '@angular/core/testing';
import { CustomSidenav } from './custom-sidenav';
import { globalTestProviders } from '../../../test-setup';

describe('CustomSidenav', () => {
  let component: CustomSidenav;
  let fixture: ComponentFixture<CustomSidenav>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CustomSidenav],
      providers: [...globalTestProviders]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CustomSidenav);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
