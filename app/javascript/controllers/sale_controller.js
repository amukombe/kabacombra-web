import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sale"
export default class extends Controller {
  static targets = ["quantity","amount", "itemtotal","subTotal", "tax", "grandTotal", "productSelect","quantityDisplay"];
  connect() {
    console.log("Sale controller connected");
  }

  async fetchProductDetails(event) {
    const nile_product_id = event.target.value;
    console.log("Selected product ID:", nile_product_id);
    if (!nile_product_id) {
      console.error("No product ID selected");
      return;
    }
    // Locate the row containing the event target
    const row = event.target.closest(".order-item-row");
    if (!row) {
      console.error("Row not found for product selection");
      return;
    }
    // Find the `unitPrice` target specific to this row
    const amountField = row.querySelector('[data-sale-target="amount"]');
    const quantityDisplay = row.querySelector("[data-sale-target='quantityDisplay']")
    if (!amountField) {
      console.error("Unit price field not found in this row");
      return;
    }

    try {
      const response = await fetch(`/nile_products/${nile_product_id}/orderitemdetails`);
      if (!response.ok) throw new Error("Failed to fetch product details");

      const productDetails = await response.json();
      amountField.value = productDetails.selling_price || "";
      quantityDisplay.textContent = productDetails.quantity_available || "";
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

    // Now update the grand total
    this.updateTotals();
  }

  updateTotals() {
    let grandTotal = 0;

    document.querySelectorAll("#sale-item-row").forEach((row) => {
      const itemtotalField = row.querySelector('[data-sale-target="itemtotal"]');

      if (itemtotalField) {
        const itemTotal = parseFloat(itemtotalField.value) || 0;
        grandTotal += itemTotal;
      }
    });

    console.log("Grand Total:", grandTotal);

    // VAT Inclusive Calculations
    const subTotal = grandTotal / 1.18;
    const tax = grandTotal - subTotal;

    console.log("Sub Total:", subTotal);
    console.log("VAT:", tax);

    // Update subtotal
    const subTotalField = document.querySelector("#sub_total");
    if (subTotalField) {
      subTotalField.textContent = Math.round(subTotal).toLocaleString();
    }

    // Update VAT
    const taxField = document.querySelector("#tax");
    if (taxField) {
      taxField.textContent = Math.round(tax).toLocaleString();
    }

    // Update grand total
    const grandTotalField = document.querySelector("#grand_total");
    if (grandTotalField) {
      grandTotalField.textContent = Math.round(grandTotal).toLocaleString();
    }
  }
    
  showEmpty(event) {
    const selectedOption = event.target.selectedOptions[0]
    const emptyId = selectedOption.dataset.emptyId

    document.querySelectorAll('.empty-form').forEach(div => {
      div.style.display = 'none'
    })

    if (emptyId) {
      const emptyDiv = document.querySelector(`.empty-form[data-empty-id='${emptyId}']`)
      if (emptyDiv) {
        emptyDiv.style.display = 'block'
      }
    }
  }
  
}
