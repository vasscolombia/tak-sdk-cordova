import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SecureStoragePage } from './secure-storage.page';

const routes: Routes = [
  {
    path: '',
    component: SecureStoragePage,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SecureStoragePageRoutingModule {}
