import { Component, ViewChild, ElementRef } from '@angular/core';

declare var TAK: any;

@Component({
  selector: 'app-others',
  templateUrl: 'others.page.html',
  styleUrls: ['others.page.scss']
})
export class OthersPage {
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

  async generateRandom() {
    this.isRunningTAK = true;
    this.log('Generating random...');

    const startTime = Date.now();

    try {
      let random = await TAK.generateRandom(16); //16 bytes
      this.log(`Random data: ${random}`);
      
      const endTime = Date.now();
      this.log(`Generate random completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error generating random: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async createRtiThread() {
    this.isRunningTAK = true;
   
    this.log('Creating RTI thread...');
    const startTime = Date.now();

    try {
      await TAK.createRuntimeCheckThread(5); // 5 seconds
      const endTime = Date.now();
      this.log(`Creation of runtime check completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error creating runtime check thread: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async isRtiThreadActive() {
    this.isRunningTAK = true;
   
    this.log('Checking if RTI thread is active...');
    const startTime = Date.now();

    try {
      let result = await TAK.isRuntimeThreadActive(false);
      const endTime = Date.now();
      this.log(`Runtime Check Thread active: ${result}`)
      this.log(`Check completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error checking if runtime check thread is acitve: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }

  async stopRtiThread() {
    this.isRunningTAK = true;
   
    this.log('Stopping RTI thread...');
    const startTime = Date.now();

    try {
      await TAK.stopRuntimeThread(); // 5 seconds
      const endTime = Date.now();
      this.log(`Request completed in ${endTime - startTime} ms`);
    } catch (error: any) {
      this.log(`Error stopping runtime check thread: ${error}`);
    } finally {
      this.isRunningTAK = false;
    }
  }
}



