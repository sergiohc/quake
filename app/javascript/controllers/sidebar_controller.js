import { Controller } from "@hotwired/stimulus"
import { Drawer } from "flowbite";

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["sidebar", "sidebarButton"]

  connect() {
    this.initializeDrawer();
  }

  initializeDrawer() {
    this.options = { backdrop: false };
    this.sidebar = new Drawer(this.sidebarTarget, this.options);
  }

  toggle() {
    this.sidebar.toggle();
  }

  open() {
    this.sidebar.show();
  }

  disconnect() {
    this.sidebar.hide();
  }
}
