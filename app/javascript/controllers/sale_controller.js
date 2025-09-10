import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sale"
export default class extends Controller {
  static targets = ["quantity","amount", "itemtotal","subTotal", "tax", "grandTotal", "productSelect","quantityDisplay"];
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
    const quantityDisplay = row.querySelector("[data-sale-target='quantityDisplay']")
    if (!amountField) {
      console.error("Unit price field not found in this row");
      return;
    }

    try {
      const response = await fetch(`/nile_products/${loading_order_item_id}/orderitemdetails`);
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
    let subTotal = 0;

    const rows = document.querySelectorAll("#sale-item-row");
    console.log("Rows found:", rows.length); // Logs how many rows are found
    // Loop through each row and calculate the subtotal
    document.querySelectorAll("#sale-item-row").forEach((row) => {
      const itemtotalField = row.querySelector('[data-sale-target="itemtotal"]');
      const quantityField = row.querySelector('[data-sale-target="quantity"]');
      const amountField = row.querySelector('[data-sale-target="amount"]');
      
      // Check if all necessary fields are present
      if (itemtotalField && quantityField && amountField) {
        const quantity = parseFloat(quantityField.value) || 0;
        const amount = parseFloat(amountField.value) || 0;
        // Only calculate item total if both quantity and amount are valid numbers
        const itemTotal = quantity * amount;
        // Ensure the itemTotal is calculated before updating the fields
        if (itemTotal > 0) {
          // Update the itemtotal field
          itemtotalField.value = itemTotal.toFixed(2);  // Update the readonly field
          itemtotalField.textContent = itemTotal.toFixed(2); // Update the text content if applicable
          // Add the item total to the subtotal
          subTotal += itemTotal;
          console.log("Item total:"+itemTotal);
        }
        else{
          console.log("Item total=0");
        }
      }
      else{
        console.log("Failed to fetch values");
      }
    });
  
    // Log subTotal for debugging
    console.log("Sub Total:", subTotal);
  
    // Update the sub_total field
    const subTotalField = document.querySelector("#sub_total");
    if (subTotalField) {
      subTotalField.textContent = subTotal.toFixed(2); // Format to 2 decimal places
    }
  
    // Calculate tax (18% of subTotal)
    const tax = subTotal * 0.18;
  
    // Log tax for debugging
    console.log("Tax (18%):", tax);
    // Update the tax field
    const taxField = document.querySelector("#tax");
    if (taxField) {
      taxField.textContent = tax.toFixed(2); // Format to 2 decimal places
    }
  
    // Calculate grand total (subTotal + tax)
    const grandTotal = subTotal + tax;
  
    // Log grand total for debugging
    console.log("Grand Total:", grandTotal);
  
    // Update the grand total field
    const grandTotalField = document.querySelector("#grand_total");
    if (grandTotalField) {
      grandTotalField.textContent = grandTotal.toFixed(2); // Format to 2 decimal places
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
