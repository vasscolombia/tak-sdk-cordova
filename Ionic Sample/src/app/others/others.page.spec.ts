import { ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { OthersPage } from './others.page';

describe('OthersPage', () => {
  let component: OthersPage;
  let fixture: ComponentFixture<OthersPage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [OthersPage],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(OthersPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
