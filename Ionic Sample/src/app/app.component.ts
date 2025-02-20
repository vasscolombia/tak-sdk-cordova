import { Component } from '@angular/core';

declare var TAK: any;
import { Platform } from '@ionic/angular';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
})
export class AppComponent {
  constructor(private platform: Platform) {
    this.platform.ready().then(() => {
      if (!TAK) {
        alert("TAK plugin is not available");
      }
    });
  }
}
