import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  filter() {
    const url = new URL(this.formTarget.action);
    const formData = new FormData(this.formTarget);

    const params = new URLSearchParams(
      Array.from(formData.entries()).filter(([_, value]) => value !== "")
    );

    url.search = params.toString();

    Turbo.visit(url, { action: "replace", frame: "content" });
  }
}
