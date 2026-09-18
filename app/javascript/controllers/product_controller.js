import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product"
export default class extends Controller {
  static targets = [
    "productSelect",
    "quantityDisplay",
    "unitPrice",
    "sellingPrice"
  ]

  connect() {
    console.log("product connected")

    const row = this.element.closest(".nested-form-wrapper")

    if (row) {
      const quantityField = row.querySelector(".quantity-field")

      if (quantityField) {
        quantityField.addEventListener("input", () => {
          this.validateQuantity(row)
        })
      }
    }
  }

  async updateStock(event) {
    const productId = event.target.value
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content')

    const row = event.target.closest(".nested-form-wrapper")

    if (!row) {
      console.error("Loading order item row not found")
      return
    }

    // Locate the quantity display for this row
    const quantityDisplay = row.querySelector(
      "[data-product-target='quantityDisplay']"
    )

    if (!productId) {
      if (quantityDisplay) {
        quantityDisplay.innerText = "Available Stock: --"
      }

      this.clearQuantityError(row)
      return
    }

    try {
      // Fetch available stock from the server
      const response = await fetch(
        `/nile_products/available_stock?id=${productId}`,
        {
          headers: {
            "X-CSRF-Token": token
          }
        }
      )

      if (!response.ok) {
        throw new Error("Failed to fetch available stock")
      }

      const data = await response.json()

      // Store available stock on the row
      row.dataset.availableStock = data.available_stock

      // Update the quantity display
      if (quantityDisplay) {
        quantityDisplay.innerText =
          `Available Stock: ${data.available_stock}`
      }

      // Validate quantity if user has already entered one
      this.validateQuantity(row)

    } catch (error) {
      console.error("Error fetching available stock:", error)

      if (quantityDisplay) {
        quantityDisplay.innerText =
          "Available Stock: Unable to load"
      }
    }
  }

  validateQuantity(row) {
    if (!row) return

    const quantityField = row.querySelector(
      ".quantity-field"
    )

    if (!quantityField) {
      return
    }

    const quantityLoaded = parseFloat(quantityField.value)
    const availableStock = parseFloat(row.dataset.availableStock)

    // Nothing to validate yet
    if (
      isNaN(quantityLoaded) ||
      isNaN(availableStock)
    ) {
      this.clearQuantityError(row)
      return
    }

    if (quantityLoaded > availableStock) {
      this.showQuantityError(
        row,
        `Quantity loaded cannot be greater than available stock (${availableStock}).`
      )
    } else {
      this.clearQuantityError(row)
    }
  }

  showQuantityError(row, message) {
    const quantityField = row.querySelector(
      ".quantity-field"
    )

    if (!quantityField) return

    // Add red border
    quantityField.classList.remove(
      "border-gray-300"
    )

    quantityField.classList.add(
      "border-red-500",
      "focus:border-red-500",
      "focus:ring-red-500"
    )

    // Find or create error message
    let errorMessage = row.querySelector(
      ".quantity-error"
    )

    if (!errorMessage) {
      errorMessage = document.createElement("p")
      errorMessage.classList.add(
        "quantity-error",
        "text-xs",
        "text-red-600",
        "dark:text-red-400",
        "mt-1"
      )

      quantityField.parentElement.appendChild(
        errorMessage
      )
    }

    errorMessage.innerText = message
    errorMessage.classList.remove("hidden")
  }

  clearQuantityError(row) {
    const quantityField = row.querySelector(
      ".quantity-field"
    )

    if (!quantityField) return

    quantityField.classList.remove(
      "border-red-500",
      "focus:border-red-500",
      "focus:ring-red-500"
    )

    quantityField.classList.add(
      "border-gray-300"
    )

    const errorMessage = row.querySelector(
      ".quantity-error"
    )

    if (errorMessage) {
      errorMessage.innerText = ""
      errorMessage.classList.add("hidden")
    }
  }

  async fetchProductDetails(event) {
    const selectedProductId = event.target.value

    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row")

    if (!row) {
      console.error("Row not found for product selection")
      return
    }

    // Find the unitPrice field specific to this row
    const unitPriceField = row.querySelector(
      '[data-product-target="unitPrice"]'
    )

    if (!unitPriceField) {
      console.error("Unit price field not found in this row")
      return
    }

    // Find the sellingPrice field specific to this row
    const sellingPriceField = row.querySelector(
      '[data-product-target="sellingPrice"]'
    )

    if (!sellingPriceField) {
      console.error("Selling price field not found in this row")
      return
    }

    try {
      const response = await fetch(
        `/nile_products/${selectedProductId}/details`
      )

      if (!response.ok) {
        throw new Error("Failed to fetch product details")
      }

      const productDetails = await response.json()

      unitPriceField.value =
        productDetails.unit_price || ""

      sellingPriceField.value =
        productDetails.selling_price || ""

    } catch (error) {
      console.error(error)
      alert("Could not load product details.")
    }
  }
}