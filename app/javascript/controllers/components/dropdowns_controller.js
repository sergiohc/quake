import { Controller } from "@hotwired/stimulus";
import { Dropdown } from "flowbite";

// Connects to data-controller="components--dropdowns"
export default class extends Controller {
  static targets = ["dropdownMenu", "dropdownButton"];

  connect() {
    this.options = {
      placement: "bottom",
      triggerType: "click",
      offsetSkidding: 0,
      offsetDistance: 10,
      delay: 300,
      ignoreClickOutsideClass: false
    };

    this.dropdown = new Dropdown(this.dropdownMenuTarget, this.dropdownButtonTarget, this.options);
  }

  toggle() {
    this.dropdown.toggle();
  }

  open() {
    this.dropdown.show();
  }

  disconnect() {
    this.dropdown.hide();
  }
}
