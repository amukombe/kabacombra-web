import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "ruleType",
    "buyQuantityField",
    "applyToField",
    "discountQuantityField",
    "repeatableField"
  ]

  connect() {
    this.toggleFields()
  }

  toggleFields() {
    const ruleType = this.ruleTypeTarget.value
    const isBuyRule = ruleType === "buy_x_discount_y"

    this.toggle(this.buyQuantityFieldTarget, isBuyRule)
    this.toggle(this.applyToFieldTarget, isBuyRule)
    this.toggle(this.repeatableFieldTarget, isBuyRule)

    const applyToAllInput = this.element.querySelector("input[name='discount[apply_to_all]']:checked")
    const applyToAll = applyToAllInput ? applyToAllInput.value === "true" : true

    this.toggle(this.discountQuantityFieldTarget, isBuyRule && !applyToAll)
  }

  toggle(element, show) {
    element.classList.toggle("hidden", !show)
  }
}