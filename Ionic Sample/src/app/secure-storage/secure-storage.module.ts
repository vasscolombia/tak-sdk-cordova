import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SecureStoragePage } from './secure-storage.page';
import { AutoScrollDirectivesModule } from '../directives/auto-scroll.directive.module';
import { SecureStoragePageRoutingModule } from './secure-storage-routing.module';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    SecureStoragePageRoutingModule,
    AutoScrollDirectivesModule
  ],
  declarations: [SecureStoragePage]
})
export class SecureStoragePageModule {}
