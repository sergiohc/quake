import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login-method"
export default class extends Controller {
  static targets = ["phoneField", "emailField", "select"];

  connect() {
    this.toggleFields();
  }

  toggleFields() {
    const method = this.selectTarget.value;
    if (method === "email") {
      this.phoneFieldTarget.style.display = "none";
      this.emailFieldTarget.style.display = "block";
    } else if (method === "phone") {
      this.phoneFieldTarget.style.display = "block";
      this.emailFieldTarget.style.display = "none";
    }
  }

  selectChange() {
    this.toggleFields();
  }
}