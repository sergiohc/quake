import { Controller } from "@hotwired/stimulus";
import { Drawer } from "flowbite";

export default class extends Controller {
  static targets = ["sidebar", "mainContent", "collapseIcon", "expandIcon"];

  connect() {
    this.drawer = new Drawer(this.sidebarTarget);
    this.initializeSidebarState();
  }

  initializeSidebarState() {
    const sidebarState = localStorage.getItem("sidebarExpanded");
    const hoverState = sessionStorage.getItem("sidebarHoverState");

    if (hoverState === "true" && sidebarState === "false") {
      this.expandSidebar(false, true); // Temporarily expand on hover
    } else if (sidebarState === "true") {
      this.expandSidebar(false, true); // Restore permanent expanded state
    } else {
      this.collapseSidebar(false, true); // Restore permanent collapsed state
    }
  }

  toggle() {
    sessionStorage.setItem("sidebarHoverState", "false"); // Reset hover state on click
    sessionStorage.setItem("sidebarMobileState", "false");

    if (this.sidebarTarget.classList.contains("w-64")) {
      this.collapseSidebar();
    } else {
      this.expandSidebar();
    }
  }

  mobileToggle() {
    sessionStorage.setItem("sidebarMobileState", "true");
    sessionStorage.setItem("sidebarMobileState", "true");
    if (this.drawer._visible) {
      this.collapseSidebar();
      this.drawer.hide()
    } else {
      this.expandSidebar();
      this.drawer.show()
    }
  }

  collapseSidebar(save = true, initial = false) {
    document.querySelectorAll("[data-sidebar-collapse-hide]").forEach((el) => {
      el.classList.add("hidden", "opacity-0");
      if (!initial) {
        setTimeout(() => el.classList.remove("opacity-0"), 75);
      }
    });

    document.querySelectorAll("[data-sidebar-collapse-subitem]").forEach((el) => {
      el.classList.remove("pl-10");
    });

    this.sidebarTarget.classList.remove("w-64");
    this.sidebarTarget.classList.add("w-16");
    this.mainContentTarget.classList.remove("lg:ms-64");
    this.mainContentTarget.classList.add("lg:ml-16");

    if (save) {
      this.collapseIconTarget.classList.add("hidden");
      this.expandIconTarget.classList.remove("hidden");
      localStorage.setItem("sidebarExpanded", "false");
    }
  }

  expandSidebar(save = true, initial = false) {
    console.log("expandSidebar")
    document.querySelectorAll("[data-sidebar-collapse-hide]").forEach((el) => {
      el.classList.remove("hidden", "opacity-0");
      if (!initial) {
        setTimeout(() => el.classList.remove("opacity-0"), 75);
      }
    });

    document.querySelectorAll("[data-sidebar-collapse-subitem]").forEach((el) => {
      el.classList.add("pl-10");
    });

    this.sidebarTarget.classList.remove("w-16");
    this.sidebarTarget.classList.add("w-64");

    this.mainContentTarget.classList.remove("lg:ml-16");
    this.mainContentTarget.classList.add("lg:ms-64");

    if (save) {
      this.collapseIconTarget.classList.remove("hidden");
      this.expandIconTarget.classList.add("hidden");
      localStorage.setItem("sidebarExpanded", "true");
    }
  }

  handleMouseEnter() {
    if (this.sidebarTarget.classList.contains("w-16")) {
      sessionStorage.setItem("sidebarHoverState", "true");
      this.expandSidebar(false);
    }
  }

  handleMouseLeave() {
    if (sessionStorage.getItem("sidebarHoverState") === "true") {
      sessionStorage.setItem("sidebarHoverState", "false");
      this.collapseSidebar(false);
    }
  }
}
