import { Controller } from "@hotwired/stimulus"
import intlTelInput from "intl-tel-input/intlTelInputWithUtils"

// Connects to data-controller="phone"
export default class extends Controller {
  static targets = ["phone"];

  connect() {
      const input = this.phoneTarget;
      if (input) {
        this.phone_number = intlTelInput(input, {
          initialCountry: "br",
          separateDialCode: true,
          hiddenInput: () => ({ phone: "full_phone", country: "country_code" }),
        });
      }
  }
}
