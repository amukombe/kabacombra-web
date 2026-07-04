import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sale"
export default class extends Controller {
  static targets = [
    "quantity",
    "amount",
    "itemtotal",
    "subTotal",
    "tax",
    "grandTotal",
    "productSelect",
    "quantityDisplay",
    "discountTotal",
    "selectedDiscounts",
    "discountModal",
    "modalProductName",
    "modalGrossAmount",
    "modalDiscountTotal",
    "modalNetTotal"
  ]

  connect() {
    console.log("Sale controller connected")
    this.currentDiscountRow = null
  }

  async fetchProductDetails(event) {
    const nile_product_id = event.target.value
    if (!nile_product_id) return

    const row = event.target.closest(".order-item-row")
    if (!row) return

    const amountField = row.querySelector('[data-sale-target="amount"]')
    const quantityDisplay = row.querySelector('[data-sale-target="quantityDisplay"]')

    try {
      const response = await fetch(`/nile_products/${nile_product_id}/orderitemdetails`)
      if (!response.ok) throw new Error("Failed to fetch product details")

      const productDetails = await response.json()

      if (amountField) amountField.value = productDetails.selling_price || ""
      if (quantityDisplay) quantityDisplay.textContent = productDetails.quantity_available || ""

      this.calculateRowTotal(row)
      this.updateTotals()
    } catch (error) {
      console.error(error)
      alert("Could not load product details.")
    }
  }

  getTotal(event) {
    const row = event.target.closest(".order-item-row")
    if (!row) return

    this.calculateRowTotal(row)
    this.updateTotals()
  }

  calculateRowTotal(row) {
    const quantityField = row.querySelector('[data-sale-target="quantity"]')
    const amountField = row.querySelector('[data-sale-target="amount"]')
    const discountField = row.querySelector('[data-sale-target="discountTotal"]')
    const itemtotalField = row.querySelector('[data-sale-target="itemtotal"]')

    if (!quantityField || !amountField || !itemtotalField) return

    const quantity = parseFloat(quantityField.value) || 0
    const amount = parseFloat(amountField.value) || 0
    const discount = parseFloat(discountField?.value) || 0

    const grossTotal = quantity * amount
    const total = Math.max(grossTotal - discount, 0)

    itemtotalField.value = total.toFixed(2)
  }

  updateTotals() {
    let grandTotal = 0

    document.querySelectorAll(".order-item-row").forEach((row) => {
      const itemtotalField = row.querySelector('[data-sale-target="itemtotal"]')
      if (itemtotalField) {
        grandTotal += parseFloat(itemtotalField.value) || 0
      }
    })

    const subTotal = grandTotal / 1.18
    const tax = grandTotal - subTotal

    const subTotalField = document.querySelector("#sub_total")
    if (subTotalField) subTotalField.textContent = Math.round(subTotal).toLocaleString()

    const taxField = document.querySelector("#tax")
    if (taxField) taxField.textContent = Math.round(tax).toLocaleString()

    const grandTotalField = document.querySelector("#grand_total")
    if (grandTotalField) grandTotalField.textContent = Math.round(grandTotal).toLocaleString()
  }

  openDiscountModal(event) {
    this.currentDiscountRow = event.target.closest(".order-item-row")
    if (!this.currentDiscountRow) return

    const productNameField = this.currentDiscountRow.querySelector("input[name*='[product_name]']")
    const quantityField = this.currentDiscountRow.querySelector('[data-sale-target="quantity"]')
    const amountField = this.currentDiscountRow.querySelector('[data-sale-target="amount"]')
    const discountTotalField = this.currentDiscountRow.querySelector('[data-sale-target="discountTotal"]')

    const productName = productNameField ? productNameField.value : ""
    const quantity = parseFloat(quantityField?.value) || 0
    const amount = parseFloat(amountField?.value) || 0
    const existingDiscount = parseFloat(discountTotalField?.value) || 0
    const grossAmount = quantity * amount
    const netAmount = Math.max(grossAmount - existingDiscount, 0)

    this.modalProductNameTarget.textContent = productName
    this.modalGrossAmountTarget.textContent = grossAmount.toLocaleString()
    this.modalDiscountTotalTarget.textContent = existingDiscount.toLocaleString()
    this.modalNetTotalTarget.textContent = netAmount.toLocaleString()

    document.querySelectorAll(".discount-checkbox").forEach((checkbox) => {
      checkbox.checked = false
    })

    this.discountModalTarget.classList.remove("hidden")
  }

  closeDiscountModal() {
    this.discountModalTarget.classList.add("hidden")
    this.currentDiscountRow = null
  }

  calculateModalDiscount() {
    if (!this.currentDiscountRow) return

    const { grossAmount, totalDiscount, netTotal } = this.calculateSelectedDiscounts()

    this.modalGrossAmountTarget.textContent = grossAmount.toLocaleString()
    this.modalDiscountTotalTarget.textContent = totalDiscount.toLocaleString()
    this.modalNetTotalTarget.textContent = netTotal.toLocaleString()
  }

  calculateSelectedDiscounts() {
    const quantityField = this.currentDiscountRow.querySelector('[data-sale-target="quantity"]')
    const amountField = this.currentDiscountRow.querySelector('[data-sale-target="amount"]')

    const quantity = parseFloat(quantityField?.value) || 0
    const amount = parseFloat(amountField?.value) || 0
    const grossAmount = quantity * amount

    let totalDiscount = 0

    document.querySelectorAll(".discount-checkbox:checked").forEach((checkbox) => {
      const discountType = checkbox.dataset.discountType
      const discountValue = parseFloat(checkbox.dataset.discountValue) || 0

      if (discountType === "fixed") {
        totalDiscount += discountValue * quantity
      } else if (discountType === "percentage") {
        totalDiscount += grossAmount * (discountValue / 100)
      }
    })

    totalDiscount = Math.min(totalDiscount, grossAmount)
    const netTotal = Math.max(grossAmount - totalDiscount, 0)

    return { grossAmount, totalDiscount, netTotal }
  }

  saveDiscounts() {
    if (!this.currentDiscountRow) return

    const quantityField = this.currentDiscountRow.querySelector('[data-sale-target="quantity"]')
    const amountField = this.currentDiscountRow.querySelector('[data-sale-target="amount"]')
    const discountTotalField = this.currentDiscountRow.querySelector('[data-sale-target="discountTotal"]')
    const itemTotalField = this.currentDiscountRow.querySelector('[data-sale-target="itemtotal"]')
    const selectedDiscountsWrapper = this.currentDiscountRow.querySelector('[data-sale-target="selectedDiscounts"]')

    if (!quantityField || !amountField || !discountTotalField || !itemTotalField || !selectedDiscountsWrapper) {
      console.error("Missing discount fields in row")
      return
    }

    const quantity = parseFloat(quantityField.value) || 0
    const amount = parseFloat(amountField.value) || 0
    const grossAmount = quantity * amount

    let totalDiscount = 0
    let hiddenFields = ""

    const rowIndexMatch = quantityField.name.match(/\[(\d+)\]/)
    const rowIndex = rowIndexMatch ? rowIndexMatch[1] : Date.now()

    document.querySelectorAll(".discount-checkbox:checked").forEach((checkbox, index) => {
      const discountId = checkbox.dataset.discountId
      const discountName = checkbox.dataset.discountName
      const discountType = checkbox.dataset.discountType
      const discountValue = parseFloat(checkbox.dataset.discountValue) || 0

      let discountAmount = 0

      if (discountType === "fixed") {
        discountAmount = discountValue * quantity
      } else if (discountType === "percentage") {
        discountAmount = grossAmount * (discountValue / 100)
      }

      totalDiscount += discountAmount

      hiddenFields += `
        <input type="hidden" name="sale[sale_items_attributes][${rowIndex}][sale_item_discounts_attributes][${index}][discount_id]" value="${discountId}">
        <input type="hidden" name="sale[sale_items_attributes][${rowIndex}][sale_item_discounts_attributes][${index}][discount_name]" value="${discountName}">
        <input type="hidden" name="sale[sale_items_attributes][${rowIndex}][sale_item_discounts_attributes][${index}][discount_type]" value="${discountType}">
        <input type="hidden" name="sale[sale_items_attributes][${rowIndex}][sale_item_discounts_attributes][${index}][discount_value]" value="${discountValue}">
        <input type="hidden" name="sale[sale_items_attributes][${rowIndex}][sale_item_discounts_attributes][${index}][discount_amount]" value="${discountAmount}">
      `
    })

    totalDiscount = Math.min(totalDiscount, grossAmount)
    const netTotal = Math.max(grossAmount - totalDiscount, 0)

    discountTotalField.value = totalDiscount.toFixed(2)
    itemTotalField.value = netTotal.toFixed(2)
    selectedDiscountsWrapper.innerHTML = hiddenFields

    this.closeDiscountModal()
    this.updateTotals()
  }

  showEmpty(event) {
    const selectedOption = event.target.selectedOptions[0]
    const emptyId = selectedOption.dataset.emptyId

    document.querySelectorAll(".empty-form").forEach((div) => {
      div.style.display = "none"
    })

    if (emptyId) {
      const emptyDiv = document.querySelector(`.empty-form[data-empty-id='${emptyId}']`)
      if (emptyDiv) emptyDiv.style.display = "block"
    }
  }
}