import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.stopPropagation()
    
    // Close all other open menus
    document.querySelectorAll('.column-menu-dropdown:not(.hidden)').forEach(menu => {
      if (menu !== this.menuTarget) {
        menu.classList.add('hidden')
      }
    })
    
    // Toggle this menu
    this.menuTarget.classList.toggle('hidden')
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
    }
  }

  connect() {
    this.boundHide = this.hide.bind(this)
    document.addEventListener('click', this.boundHide)
  }

  disconnect() {
    document.removeEventListener('click', this.boundHide)
  }
}
