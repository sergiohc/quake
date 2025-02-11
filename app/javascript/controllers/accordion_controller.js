import { Controller } from "@hotwired/stimulus";
import { Accordion } from "flowbite";

export default class extends Controller {
  connect() {
    this.initializeAccordion();
  }

  initializeAccordion() {
    const accordionElement = document.getElementById('accordion-collapse');
    const triggerEl = document.querySelector('#accordion-collapse-heading-1');
    const targetEl = document.querySelector('#accordion-collapse-body-1');

    if (!accordionElement || !triggerEl || !targetEl) {
      console.error("Accordion elements not found!");
      return;
    }

    const accordionItems = [
      {
        id: 'accordion-collapse-heading-1',
        triggerEl: triggerEl,
        targetEl: targetEl,
        active: false
      }
    ];

    const options = {
      alwaysOpen: false,
      activeClasses: 'bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white',
      inactiveClasses: 'text-gray-500 dark:text-gray-400'
    };

    const accordion = new Accordion(accordionElement, accordionItems, options);
    accordion.init();
  }
}
