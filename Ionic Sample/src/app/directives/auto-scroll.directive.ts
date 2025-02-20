import { Directive, ElementRef, AfterViewChecked } from '@angular/core';

@Directive({
  selector: '[appAutoScroll]'
})
export class AutoScrollDirective implements AfterViewChecked {
  constructor(private el: ElementRef) {}

  ngAfterViewChecked() {
    this.scrollToBottom();
  }

  private scrollToBottom(): void {
    this.el.nativeElement.scrollTop = this.el.nativeElement.scrollHeight;
  }
}