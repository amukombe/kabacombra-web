import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sale"
export default class extends Controller {
  static targets = ["quantity","amount", "itemtotal"];
  connect() {
    console.log("Sale controller connected");
  }

  async fetchProductDetails(event) {
    const loading_order_item_id = event.target.value;

    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row");
    if (!row) {
      console.error("Row not found for product selection");
      return;
    }

    // Find the `unitPrice` target specific to this row
    const amountField = row.querySelector('[data-sale-target="amount"]');
    if (!amountField) {
      console.error("Unit price field not found in this row");
      return;
    }

    try {
      const response = await fetch(`/nile_products/${loading_order_item_id}/orderitemdetails`);
      if (!response.ok) throw new Error("Failed to fetch product details");

      const productDetails = await response.json();
      amountField.value = productDetails.selling_price || "";
    } catch (error) {
      console.error(error);
      alert("Could not load product details.");
    }
  }

  async getTotal(event) {
    console.log("Total method loaded:::")
    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row");
    if (!row) {
      console.error("Row not found for product selection");
      return;
    }
  
    // Find the `amount` target specific to this row
    const amountField = row.querySelector('[data-sale-target="amount"]');
    if (!amountField) {
      console.error("amount field not found in this row");
      return;
    }
  
    // Fetch the `quantity` field
    const quantityField = row.querySelector('[data-sale-target="quantity"]');
    if (!quantityField) {
      console.error("quantity field not found in this row");
      return;
    }
  
    // Fetch the `total` field
    const itemtotalField = row.querySelector('[data-sale-target="itemtotal"]');
    if (!itemtotalField) {
      console.error("total field not found in this row");
      return;
    }
  
    // Parse the values and calculate total
    const quantity = parseFloat(quantityField.value) || 0;
    const amount = parseFloat(amountField.value) || 0;
    const total = quantity * amount;
  
    // Update the `total` field with the calculated value
    itemtotalField.value = total.toFixed(2); // Format to 2 decimal places
  }
  
}
