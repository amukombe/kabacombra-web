import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="inventory"
export default class extends Controller {
  static targets = ["sellingPrice", "quantity", "breakages", "missing", "complaints"];
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

  async getTotal(event) {
    console.log("Total method loaded:::");

    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row");
    if (!row) {
        console.error("Row not found for product selection");
        return;
    }

    // Find the necessary fields
    const breakagesField = row.querySelector('[data-inventory-target="breakages"]');
    const quantityField = row.querySelector('[data-inventory-target="quantity"]');
    const missingField = row.querySelector('[data-inventory-target="missing"]');
    const complaintsField = row.querySelector('[data-inventory-target="complaints"]');
    if (!breakagesField || !quantityField || !missingField || !complaintsField) {
        console.error("One or more required fields not found in this row");
        return;
    }

    // Get the original quantity value
    let originalQuantity = parseFloat(quantityField.dataset.originalValue);
    if (!originalQuantity) {
        originalQuantity = parseFloat(quantityField.value) || 0;
        // Store the original quantity in a data attribute
        quantityField.dataset.originalValue = originalQuantity;
    }

    // Parse the values from the fields
    const breakages = parseFloat(breakagesField.value) || 0;
    const missing = parseFloat(missingField.value) || 0;
    const complaints = parseFloat(complaintsField.value) || 0;
    // Calculate the new quantity
    const newQuantity = originalQuantity - (breakages + missing + complaints);

    // Update the `quantityField` value
    quantityField.value = newQuantity.toFixed(2); // Format to 2 decimal places
    console.log(`Updated Quantity: ${newQuantity}`);
}



}
