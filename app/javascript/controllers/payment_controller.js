import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = ["employee", "supplier", "employeeSelect", "supplierSelect", "paymentNumber", "paymentRef", "paymentNumberLabel"]
  connect() {
  }

  displayRecipientOptions(event) {
    const type = event.target.value
    console.log(type);
    if (type === "Employee") {
      this.employeeSelectTarget.classList.remove("hidden")
      this.employeeTarget.disabled = false
      this.supplierSelectTarget.classList.add("hidden")
      this.supplierTarget.disabled = true
    } else if (type === "Supplier") {
      this.supplierSelectTarget.classList.remove("hidden")
      this.supplierTarget.disabled = false
      this.employeeSelectTarget.classList.add("hidden")
      this.employeeTarget.disabled = true
    } else {
      this.employeeSelectTarget.classList.add("hidden")
      this.supplierSelectTarget.classList.add("hidden")
      this.employeeTarget.disabled = true
      this.supplierTarget.disabled = true
    }
  }

  displayPaymentOptions(event) {
    const method = event.target.value
    console.log(method);
    if (method === "cheque" || method === "bank_transfer" || method === "mobile_money") {
      this.paymentNumberTarget.classList.remove("hidden")
      this.paymentRefTarget.classList.remove("hidden")

      if (method === "cheque") {
        this.paymentNumberLabelTarget.textContent = "Cheque Number."
      } else if (method === "bank_transfer") {
        this.paymentNumberLabelTarget.textContent = "Bank Account Number."
      } else if (method === "mobile_money") {
        this.paymentNumberLabelTarget.textContent = "Payment Number."
      }
    } else {
      this.paymentNumberTarget.classList.add("hidden")
      this.paymentRefTarget.classList.add("hidden")
    }
  }
}
