import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Connects to data-controller="sortable"
export default class extends Controller {
  static values = {
    status: Number,
    url: String
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: "tasks",
      animation: 0,
      ghostClass: "task-card-ghost",
      dragClass: "task-card-dragging",
      filter: ".column-empty-state",
      onEnd: this.handleDrop.bind(this),
      onRemove: this.handleRemove.bind(this),
      onAdd: this.handleAdd.bind(this)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }

  handleRemove(event) {
    // Check if source column will be empty after this drag completes
    // We check before the DOM updates by looking at visible task cards
    const remainingCards = Array.from(event.from.querySelectorAll('.task-card')).filter(
      card => card !== event.item && card.style.display !== 'none'
    ).length
    
    if (remainingCards === 0) {
      // Show empty state immediately
      this.showEmptyState(event.from)
    }
  }

  handleAdd(event) {
    // Hide empty state when card is added to column
    this.hideEmptyState(event.to)
  }

  handleDrop(event) {
    const taskId = event.item.dataset.taskId
    const newStatusId = event.to.dataset.sortableStatusValue
    const oldStatusId = event.from.dataset.sortableStatusValue

    // Only update if moved to different column
    if (newStatusId !== oldStatusId) {
      this.updateTaskStatus(taskId, newStatusId, event)
    }
  }

  async updateTaskStatus(taskId, statusId, event) {
    const url = `/tasks/${taskId}/update_status`
    
    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          task_status_id: statusId
        })
      })

      if (!response.ok) {
        throw new Error("Failed to update task")
      }

      // Update the count badges
      this.updateCounts(event)
    } catch (error) {
      console.error("Error updating task:", error)
      // Revert the move on error
      if (event.from && event.item) {
        event.from.insertBefore(event.item, event.from.children[event.oldIndex])
      }
    }
  }

  updateCounts(event) {
    // Update source column count
    const sourceColumn = event.from.closest('.board-column')
    const sourceCount = sourceColumn?.querySelector(".column-count")
    if (sourceCount) {
      const currentCount = parseInt(sourceCount.textContent)
      sourceCount.textContent = currentCount - 1
      
      // Show empty state if no cards left
      if (currentCount - 1 === 0) {
        this.showEmptyState(event.from)
      }
    }

    // Update destination column count
    const destColumn = event.to.closest('.board-column')
    const destCount = destColumn?.querySelector(".column-count")
    if (destCount) {
      const currentCount = parseInt(destCount.textContent)
      destCount.textContent = currentCount + 1
      
      // Hide empty state if column now has cards
      if (currentCount === 0) {
        this.hideEmptyState(event.to)
      }
    }
  }

  hideEmptyState(container) {
    const emptyState = container.querySelector('.column-empty-state')
    if (emptyState) {
      emptyState.style.display = 'none'
    }
  }

  showEmptyState(container) {
    let emptyState = container.querySelector('.column-empty-state')
    
    // If empty state doesn't exist, create it
    if (!emptyState) {
      emptyState = document.createElement('div')
      emptyState.className = 'column-empty-state'
      emptyState.innerHTML = `
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <p>No tasks yet</p>
      `
      container.appendChild(emptyState)
    } else {
      emptyState.style.display = 'flex'
    }
  }
}
