import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    // Listen for escape key
    this.escapeHandler = this.handleEscape.bind(this)
    document.addEventListener("keydown", this.escapeHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }

  async open(event) {
    event.preventDefault()
    
    // Open the modal first
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    
    // Get the URL from the link
    const url = event.currentTarget.href
    
    // Load content
    await this.loadContent(url)
  }

  async loadContent(url) {
    // Determine which frame to use based on URL
    const isColumnEdit = url.includes('/task_statuses/') && url.includes('/edit')
    const frameId = isColumnEdit ? 'column_edit_details' : 'task_details'
    const frame = document.getElementById(frameId)
    
    // Clear the other frame
    const otherFrameId = isColumnEdit ? 'task_details' : 'column_edit_details'
    const otherFrame = document.getElementById(otherFrameId)
    if (otherFrame) otherFrame.innerHTML = ""
    
    if (frame) {
      frame.innerHTML = '<div class="modal-loading"><div class="modal-spinner"></div></div>'
    }
    
    try {
      const response = await fetch(url, {
        headers: {
          'Accept': 'text/html'
        }
      })
      const html = await response.text()
      
      // Find the turbo-frame in the response
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, 'text/html')
      const frameContent = doc.querySelector(`#${frameId}`)
      
      if (frameContent && frame) {
        frame.innerHTML = frameContent.innerHTML
      }
    } catch (error) {
      console.error('Error loading modal content:', error)
      if (frame) {
        frame.innerHTML = '<div class="modal-error">Failed to load content</div>'
      }
    }
  }

  navigate(event) {
    event.preventDefault()
    const url = event.currentTarget.href
    this.loadContent(url)
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")

    // Clear both frames
    const taskFrame = document.getElementById("task_details")
    const columnFrame = document.getElementById("column_edit_details")
    if (taskFrame) taskFrame.innerHTML = ""
    if (columnFrame) columnFrame.innerHTML = ""
  }

  handleEscape(event) {
    if (event.key === "Escape" && !this.modalTarget.classList.contains("hidden")) {
      this.close()
    }
  }
}
