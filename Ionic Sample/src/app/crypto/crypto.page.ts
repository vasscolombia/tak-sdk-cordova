import { Component, ViewChild, ElementRef } from '@angular/core';

declare var TAK: any;

@Component({
  selector: 'app-crypto',
  templateUrl: 'crypto.page.html',
  styleUrls: ['crypto.page.scss']
})
export class CryptoPage {
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

  async decryptFile() {
    this.isRunningTAK = true;
    this.log('Decrypting file...');

    const startTime = Date.now();

    try {
      let filePath = "www/assets/protected.tak";
      let signatureContent = await TAK.fileProtectorDecryptFile(filePath);
      const endTime = Date.now();
      this.log(`Decrypted data: ${signatureContent }`);
      this.log(`Decrypt file completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error decrypting file: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async encryptDecrypt() {
    this.isRunningTAK = true;
    this.log('Encrypting data...');

    const startTime = Date.now();

    try {
      let dataToEncrypt = "Hello, encrypted TAK!";
      let encryptedData = await TAK.fileProtectorEncryptData(dataToEncrypt);
      this.log(`Encrypted data: ${encryptedData}`);

      this.log('Decrypting data...');
      let decryptedData = await TAK.fileProtectorDecryptData(encryptedData);
      this.log(`Decrypted data: ${decryptedData}`);
      
      const endTime = Date.now();
      this.log(`Encrypting/decrypting data completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error encrypting/decrypting data: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }
}



