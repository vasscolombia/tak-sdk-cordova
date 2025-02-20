import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { OthersPage } from './others.page';

const routes: Routes = [
  {
    path: '',
    component: OthersPage,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class OthersPageRoutingModule {}
