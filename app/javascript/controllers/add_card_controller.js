import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-card"
export default class extends Controller {
  static targets = ["button", "form"]

  showForm() {
    this.buttonTarget.style.display = 'none'
    this.formTarget.style.display = 'flex'
    // Focus on the title input
    const titleInput = this.formTarget.querySelector('input[type="text"]')
    if (titleInput) {
      titleInput.focus()
    }
  }

  hideForm() {
    this.formTarget.style.display = 'none'
    this.buttonTarget.style.display = 'flex'
    // Clear the form
    this.formTarget.querySelector('form').reset()
  }

  handleKeydown(event) {
    // Close form on Escape key
    if (event.key === 'Escape') {
      this.hideForm()
    }
  }
}
