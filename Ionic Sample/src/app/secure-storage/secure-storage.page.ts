import { Component, ViewChild, ElementRef } from '@angular/core';

declare var TAK: any;

@Component({
  selector: 'app-secure-storage',
  templateUrl: 'secure-storage.page.html',
  styleUrls: ['secure-storage.page.scss']
})
export class SecureStoragePage {
  @ViewChild('logContainer') logContainer!: ElementRef;

  logMessages: string[] = [];
  isRunningTAK: boolean = false;

  constructor() {}

  log(msg: string) {
    const now = new Date();
    const timeFormatted = now.toLocaleTimeString();
    const newMessage = `${timeFormatted}: ${msg}`;
    this.logMessages.push(newMessage);
  }

  async write() {
    this.isRunningTAK = true;
   
    this.log('Writing entry in secure storage...');
    const startTime = Date.now();

    try {
      await TAK.secureStorageWrite('DummySecureStorage', 'DummyKey', 'DummyValue');
      const endTime = Date.now();
      this.log(`Write entry completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error writing in secure storage: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async read() {
    this.isRunningTAK = true;
   
    this.log('Reading entry from secure storage...');
    const startTime = Date.now();

    try {
      let result = await TAK.secureStorageRead('DummySecureStorage', 'DummyKey');
      const endTime = Date.now();
      this.log(`Read entry completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error reading from secure storage: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async deleteEntry() {
    this.isRunningTAK = true;
   
    this.log('Deleting entry from secure storage...');
    const startTime = Date.now();

    try {
      await TAK.secureStorageDeleteEntry('DummySecureStorage', 'DummyKey');
      const endTime = Date.now();
      this.log(`Delete entry completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error deleting entry from secure storage: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async deleteStorage() {
    this.isRunningTAK = true;
   
    this.log('Deleting secure storage...');
    const startTime = Date.now();

    try {
      await TAK.deleteSecureStorage('DummySecureStorage');
      const endTime = Date.now();
      this.log(`Delete secure storage completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error deleting secure storage: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }
}



