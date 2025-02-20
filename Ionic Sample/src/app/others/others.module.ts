import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OthersPage } from './others.page';
import { AutoScrollDirectivesModule } from '../directives/auto-scroll.directive.module';
import { OthersPageRoutingModule } from './others-routing.module';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    OthersPageRoutingModule,
    AutoScrollDirectivesModule
  ],
  declarations: [OthersPage]
})
export class OthersPageModule {}
