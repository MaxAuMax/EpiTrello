import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "moveMenu", "moveCardsMenu", "positionSelect", "targetColumnSelect"]
  static values = {
    statusId: Number,
    currentPosition: Number
  }

  toggle(event) {
    event.stopPropagation()
    
    // Close all other open menus
    document.querySelectorAll('.column-menu-dropdown:not(.hidden)').forEach(menu => {
      if (menu !== this.menuTarget && menu !== this.moveMenuTarget) {
        if (this.hasMoveCardsMenuTarget && menu !== this.moveCardsMenuTarget) {
          menu.classList.add('hidden')
        } else if (!this.hasMoveCardsMenuTarget) {
          menu.classList.add('hidden')
        }
      }
    })
    
    // Show main menu, hide submenus
    this.moveMenuTarget.classList.add('hidden')
    if (this.hasMoveCardsMenuTarget) {
      this.moveCardsMenuTarget.classList.add('hidden')
    }
    this.menuTarget.classList.toggle('hidden')
  }

  showMoveMenu(event) {
    event.stopPropagation()
    this.menuTarget.classList.add('hidden')
    if (this.hasMoveCardsMenuTarget) {
      this.moveCardsMenuTarget.classList.add('hidden')
    }
    this.moveMenuTarget.classList.remove('hidden')
  }

  showMoveCardsMenu(event) {
    event.stopPropagation()
    this.menuTarget.classList.add('hidden')
    this.moveMenuTarget.classList.add('hidden')
    if (this.hasMoveCardsMenuTarget) {
      this.moveCardsMenuTarget.classList.remove('hidden')
    }
  }

  showMainMenu(event) {
    event.stopPropagation()
    this.resetPositionSelect()
    this.moveMenuTarget.classList.add('hidden')
    if (this.hasMoveCardsMenuTarget) {
      this.moveCardsMenuTarget.classList.add('hidden')
    }
    this.menuTarget.classList.remove('hidden')
  }

  async moveColumn(event) {
    event.stopPropagation()
    
    const newPosition = parseInt(this.positionSelectTarget.value)
    
    if (newPosition === this.currentPositionValue) {
      // No change, just close menu
      this.hideAll()
      return
    }

    const url = `/task_statuses/${this.statusIdValue}/move`
    
    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          position: newPosition
        })
      })

      if (!response.ok) {
        throw new Error("Failed to move column")
      }

      // Reload page to show new order
      window.location.reload()
    } catch (error) {
      console.error("Error moving column:", error)
      alert("Failed to move column. Please try again.")
    }
  }

  async moveAllCards(event) {
    event.stopPropagation()
    
    const targetColumnId = parseInt(this.targetColumnSelectTarget.value)
    
    if (!targetColumnId) {
      alert("Please select a target column")
      return
    }

    const url = `/task_statuses/${this.statusIdValue}/move_all_cards`
    
    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          target_column_id: targetColumnId
        })
      })

      if (!response.ok) {
        throw new Error("Failed to move cards")
      }

      // Reload page to show changes
      window.location.reload()
    } catch (error) {
      console.error("Error moving cards:", error)
      alert("Failed to move cards. Please try again.")
    }
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.hideAll()
    }
  }

  hideAll() {
    this.resetPositionSelect()
    this.menuTarget.classList.add('hidden')
    this.moveMenuTarget.classList.add('hidden')
  }

  resetPositionSelect() {
    this.positionSelectTarget.value = this.currentPositionValue
  }

  connect() {
    this.boundHide = this.hide.bind(this)
    document.addEventListener('click', this.boundHide)
  }

  disconnect() {
    document.removeEventListener('click', this.boundHide)
  }
}
