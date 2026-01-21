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
    
    // Get the URL from the link
    const url = event.currentTarget.href
    
    // Show loading state
    const frame = document.getElementById("task_details")
    if (frame) {
      frame.innerHTML = '<div class="modal-loading"><div class="modal-spinner"></div></div>'
    }
    
    // Open the modal
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    
    // Fetch and load the content
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
      const frameContent = doc.querySelector('#task_details')
      
      if (frameContent && frame) {
        frame.innerHTML = frameContent.innerHTML
      }
    } catch (error) {
      console.error('Error loading task details:', error)
      if (frame) {
        frame.innerHTML = '<div class="modal-error">Failed to load task details</div>'
      }
    }
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")

    const frame = document.getElementById("task_details")
    if (frame) frame.innerHTML = ""
  }

  handleEscape(event) {
    if (event.key === "Escape" && !this.modalTarget.classList.contains("hidden")) {
      this.close()
    }
  }
}
