import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CryptoPage } from './crypto.page';
import { AutoScrollDirectivesModule } from '../directives/auto-scroll.directive.module';
import { CryptoPageRoutingModule } from './crypto-routing.module';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    CryptoPageRoutingModule,
    AutoScrollDirectivesModule
  ],
  declarations: [CryptoPage]
})
export class CryptoPageModule {}
