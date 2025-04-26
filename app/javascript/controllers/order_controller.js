import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["unitPrice", "sellingPrice"];
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

    // Find the `unitPrice` target specific to this row
    const unitPriceField = row.querySelector('[data-order-target="unitPrice"]');
    if (!unitPriceField) {
      console.error("Unit price field not found in this row");
      return;
    }
    
    try {
      const response = await fetch(`/nile_products/${selectedProductId}/details`);
      if (!response.ok) throw new Error("Failed to fetch product details");

      const productDetails = await response.json();
      unitPriceField.value = productDetails.unit_price || "";
    } catch (error) {
      console.error(error);
      alert("Could not load product details.");
    }
  }
  
}
