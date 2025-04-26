import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product"
export default class extends Controller {
  static targets = ["productSelect", "quantityDisplay", "unitPrice", "sellingPrice"]
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

  async fetchProductDetails(event) {
    const selectedProductId = event.target.value;

    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row");
    if (!row) {
      console.error("Row not found for product selection");
      return;
    }

    // Find the `unitPrice` target specific to this row
    const unitPriceField = row.querySelector('[data-product-target="unitPrice"]');
    if (!unitPriceField) {
      console.error("Unit price field not found in this row");
      return;
    }
    // Find the `unitPrice` target specific to this row
    const sellingPriceField = row.querySelector('[data-product-target="sellingPrice"]');
    if (!sellingPriceField) {
      console.error("Selling price field not found in this row");
      return;
    }

    try {
      const response = await fetch(`/nile_products/${selectedProductId}/details`);
      if (!response.ok) throw new Error("Failed to fetch product details");

      const productDetails = await response.json();
      unitPriceField.value = productDetails.unit_price || "";
      sellingPriceField.value = productDetails.selling_price || "";
    } catch (error) {
      console.error(error);
      alert("Could not load product details.");
    }
  }
}