import { ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { CryptoPage } from './crypto.page';

describe('CryptoPage', () => {
  let component: CryptoPage;
  let fixture: ComponentFixture<CryptoPage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CryptoPage],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CryptoPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
