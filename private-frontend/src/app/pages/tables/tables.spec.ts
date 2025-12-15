import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Tables } from './tables';
import { globalTestProviders } from '../../../test-setup';

describe('Tables', () => {
  let component: Tables;
  let fixture: ComponentFixture<Tables>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Tables],
      providers: [...globalTestProviders]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Tables);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
