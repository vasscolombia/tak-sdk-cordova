import { ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { SecureStoragePage } from './secure-storage.page';

describe('SecureStoragePage', () => {
  let component: SecureStoragePage;
  let fixture: ComponentFixture<SecureStoragePage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SecureStoragePage],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(SecureStoragePage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
