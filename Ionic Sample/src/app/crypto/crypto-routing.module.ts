import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CryptoPage } from './crypto.page';

const routes: Routes = [
  {
    path: '',
    component: CryptoPage,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CryptoPageRoutingModule {}
