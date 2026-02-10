import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "list", "template"]

  connect() {
    // Initialize with existing collaborators if editing
    const existingUsers = this.data.get("existing")
    if (existingUsers) {
      const userIds = JSON.parse(existingUsers)
      userIds.forEach(userId => {
        const option = this.dropdownTarget.querySelector(`option[value="${userId}"]`)
        if (option) {
          this.addUser(userId, option.text)
        }
      })
    }
  }

  addCollaborator(event) {
    const select = event.target
    const userId = select.value
    const userName = select.options[select.selectedIndex].text

    if (userId && !this.isUserSelected(userId)) {
      this.addUser(userId, userName)
      select.value = "" // Reset dropdown
    }
  }

  isUserSelected(userId) {
    return this.listTarget.querySelector(`input[value="${userId}"]`) !== null
  }

  addUser(userId, userName) {
    const item = document.createElement('div')
    item.className = 'collaborator-item'
    item.innerHTML = `
      <span class="collaborator-name">${userName}</span>
      <input type="hidden" name="project[user_ids][]" value="${userId}">
      <button type="button" class="btn-remove-collaborator" data-action="click->project-collaborators#removeCollaborator">
        <svg style="width: 16px; height: 16px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <line x1="18" y1="6" x2="6" y2="18"></line>
          <line x1="6" y1="6" x2="18" y2="18"></line>
        </svg>
      </button>
    `
    this.listTarget.appendChild(item)
    this.updateDropdownOptions()
  }

  removeCollaborator(event) {
    event.target.closest('.collaborator-item').remove()
    this.updateDropdownOptions()
  }

  updateDropdownOptions() {
    const selectedIds = Array.from(this.listTarget.querySelectorAll('input[type="hidden"]')).map(input => input.value)
    
    Array.from(this.dropdownTarget.options).forEach(option => {
      if (option.value) {
        option.disabled = selectedIds.includes(option.value)
      }
    })
  }
}
