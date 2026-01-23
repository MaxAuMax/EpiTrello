import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-card"
export default class extends Controller {
  static targets = ["button", "form"]

  connect() {
    this.boundHideOnClickOutside = this.hideOnClickOutside.bind(this)
  }

  disconnect() {
    document.removeEventListener('click', this.boundHideOnClickOutside)
  }

  showForm() {
    this.buttonTarget.style.display = 'none'
    this.formTarget.style.display = 'flex'
    // Focus on the title input
    const titleInput = this.formTarget.querySelector('input[type="text"]')
    if (titleInput) {
      titleInput.focus()
    }
    // Add click listener to close on outside click
    setTimeout(() => {
      document.addEventListener('click', this.boundHideOnClickOutside)
    }, 0)
  }

  hideForm() {
    this.formTarget.style.display = 'none'
    this.buttonTarget.style.display = 'flex'
    // Clear the form
    this.formTarget.querySelector('form').reset()
    // Remove click listener
    document.removeEventListener('click', this.boundHideOnClickOutside)
  }

  hideOnClickOutside(event) {
    // Check if form is visible and click is outside
    if (this.formTarget.style.display !== 'none' && !this.element.contains(event.target)) {
      this.hideForm()
    }
  }

  handleKeydown(event) {
    // Close form on Escape key
    if (event.key === 'Escape') {
      this.hideForm()
    }
  }
}
