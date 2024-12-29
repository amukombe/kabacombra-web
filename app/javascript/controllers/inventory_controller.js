import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="inventory"
export default class extends Controller {
  static targets = ["sellingPrice"];
  connect() {
    console.log("order connected");
    console.log("unit price", this.priceTarget);
  }

  async fetchProductDetails(event) {
    const selectedProductId = event.target.value;

    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row");
    if (!row) {
      console.error("Row not found for product selection");
      return;
    }

    // Find the `sellingPrice` target specific to this row
    const sellingPriceField = row.querySelector('[data-order-target="sellingPrice"]');
    if (!sellingPriceField) {
      console.error("Unit price field not found in this row");
      return;
    }

    try {
      const response = await fetch(`/nile_products/${selectedProductId}/dispatchdetails`);
      if (!response.ok) throw new Error("Failed to fetch product details");

      const productDetails = await response.json();
      sellingPriceField.value = productDetails.selling_price || "";
    } catch (error) {
      console.error(error);
      alert("Could not load product details.");
    }
  }
}
