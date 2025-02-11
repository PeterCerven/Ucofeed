import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FacultyCardComponent } from './faculty-card.component';

describe('FacultyCardComponent', () => {
  let component: FacultyCardComponent;
  let fixture: ComponentFixture<FacultyCardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FacultyCardComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FacultyCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
