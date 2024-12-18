import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product"
export default class extends Controller {
  static targets = ["productSelect", "quantityDisplay"]
  connect() {
    console.log("product connected");
  }

  async updateStock(event) {
    const productId = event.target.value
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

    if (productId) {
      try {
        // Fetch available stock from the server
        const response = await fetch(`/nile_products/available_stock?id=${productId}`, {
          headers: { "X-CSRF-Token": token }
        })
        const data = await response.json()

        // Locate the corresponding quantity display element
        const row = event.target.closest(".nested-form-wrapper")
        const quantityDisplay = row.querySelector("[data-product-target='quantityDisplay']")

        // Update the quantity display
        if (quantityDisplay) {
          quantityDisplay.innerText = `Available Stock: ${data.available_stock}`
        }
      } catch (error) {
        console.error("Error fetching available stock:", error)
      }
    } else {
      console.log("Invalid product id: " + productId)
    }
  }
}