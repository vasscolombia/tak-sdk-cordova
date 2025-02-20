import { Component, ViewChild, ElementRef} from '@angular/core';

declare var TAK: any;

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss']
})
export class HomePage{
  @ViewChild('logContainer') logContainer!: ElementRef;

  logMessages: string[] = [];
  isRunningTAK: boolean = false;

  constructor() {}

  log(msg: string) {
    const now = new Date();
    const timeFormatted = now.toLocaleTimeString();
    const newMessage = `${timeFormatted}: ${msg}`;
    console.log(newMessage);
    this.logMessages.push(newMessage);
  }

  async initialize() {
    this.isRunningTAK = true;
    this.log('Initializing TAK...');

    const startTime = Date.now();

    try {
      await TAK.initialize("www/assets/license.tak");
      const endTime = Date.now();
      this.log(`TAK initialized in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error initializing TAK: ${this.getErrorByValue(error)}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async register() {
    this.isRunningTAK = true;
    
    this.log('Registering TAK...');
    const startTime = Date.now();

    try {
      if (await TAK.isRegistered()) {
        this.log('TAK is already registered! takId: ' + await TAK.getTakIdentifier());
        return;
      }

      let registrationResponse = await TAK.register('11223344');
      const endTime = Date.now();
      this.log('TakId: ' + registrationResponse.takId);
      this.log(`TAK registered in ${endTime - startTime} ms`);
    } 
    catch (error: any) {
      if (error == TAK.TakReturnCode.LICENSE_EXPIRED) {
        await TAK.reset();
        this.log("TAK license is expired. Please, contact Build38!");
      } else {
        this.log(`Error registering TAK: ${this.getErrorByValue(error)}`);
      }
    } finally {
      this.isRunningTAK = false;
    }
  }

  async checkIntegrity() {
    this.isRunningTAK = true;
    let isRegistered = await TAK.isRegistered();
    if (!isRegistered) {
      this.log('TAK is not registered!');
      this.isRunningTAK = false;
      return;
    }
    
    this.log('Checking integrity...');
    const startTime = Date.now();

    try {
      let response = await TAK.checkIntegrity(null);
      if (response.didReRegister) {
        this.log(`Check integrity did a ReRegister! New takId: ${response.takId}`)
      }

      const endTime = Date.now();
      this.log(`Check integrity completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      if (error == TAK.TakReturnCode.CLIENT_CERTIFICATE_EXPIRED) {
        await TAK.reset();
        this.log("Client certificate is expired. It neeeds to register again!");
      } else {
        this.log(`Error checking integrity: ${this.getErrorByValue(error)}`);
      }
    } finally {
      this.isRunningTAK = false;
    }
  } 

  async resetTAK() {
    this.isRunningTAK = true;
   
    this.log('Resetting TAK...');
    const startTime = Date.now();

    try {
      await TAK.reset();
      const endTime = Date.now();
      this.log(`Reset TAK completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error resetting TAK: ${this.getErrorByValue(error)}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async advRootStatus() {
    this.isRunningTAK = true;
   
    this.log('Checking advanced root status...');
    const startTime = Date.now();

    try {
      let result = await TAK.getAdvancedRootStatus();
      const endTime = Date.now();
      this.log(`Advanced root status: ${this.getRootStatus(result)}`);
      this.log(`Advanced root status check completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error checking advanced root status: ${this.getErrorByValue(error)}`);
    } finally {
      this.isRunningTAK = false;
    }
  } 

  async releaseTAK() {
    this.isRunningTAK = true;
   
    this.log('Releasing TAK...');
    const startTime = Date.now();

    try {
      await TAK.release();
      const endTime = Date.now();
      this.log(`TAK released in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error releasing TAK: ${this.getErrorByValue(error)}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  getErrorByValue(value: any) {
    if (Object.values(TAK.TakReturnCode).includes(value)) {
      return Object.keys(TAK.TakReturnCode).find(key => TAK.TakReturnCode[key] === value);
    }

    return value;
  }

  getRootStatus(value: any) {
    return Object.keys(TAK.RootStatus).find(key => TAK.RootStatus[key] === value);
  }
}
