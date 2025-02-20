import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TabsPage } from './tabs.page';

const routes: Routes = [
  {
    path: 'tabs',
    component: TabsPage,
    children: [
      {
        path: 'home',
        loadChildren: () => import('../home/home.module').then(m => m.HomePageModule)
      },
      {
        path: 'crypto',
        loadChildren: () => import('../crypto/crypto.module').then(m => m.CryptoPageModule)
      },
      {
        path: 'secure-storage',
        loadChildren: () => import('../secure-storage/secure-storage.module').then(m => m.SecureStoragePageModule)
      },
      {
        path: 'others',
        loadChildren: () => import('../others/others.module').then(m => m.OthersPageModule)
      },
      {
        path: '',
        redirectTo: '/tabs/home',
        pathMatch: 'full'
      }
    ]
  },
  {
    path: '',
    redirectTo: '/tabs/home',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
})
export class TabsPageRoutingModule {}
