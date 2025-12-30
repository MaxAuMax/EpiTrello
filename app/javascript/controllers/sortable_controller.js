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
      animation: 150,
      ghostClass: "task-card-ghost",
      dragClass: "task-card-dragging",
      onEnd: this.handleDrop.bind(this)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
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
    }

    // Update destination column count
    const destColumn = event.to.closest('.board-column')
    const destCount = destColumn?.querySelector(".column-count")
    if (destCount) {
      const currentCount = parseInt(destCount.textContent)
      destCount.textContent = currentCount + 1
    }
  }
}
