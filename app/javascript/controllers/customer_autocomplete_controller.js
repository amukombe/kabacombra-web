import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "name",
    "mobile",
    "tin",
    "customerId",
    "results"
  ]

  search() {
    const query = this.nameTarget.value

    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/customers/autocomplete?q=${query}`)
      .then(response => response.json())
      .then(customers => {
        this.resultsTarget.innerHTML = ""

        customers.forEach(customer => {
          const item = document.createElement("div")

          item.className =
            "p-2 border-b cursor-pointer hover:bg-gray-100"

          item.innerText = customer.name

          item.addEventListener("click", () => {
            this.nameTarget.value = customer.name
            this.mobileTarget.value = customer.mobile || ""
            this.tinTarget.value = customer.brn || ""

            this.customerIdTarget.value = customer.id

            this.resultsTarget.innerHTML = ""
          })

          this.resultsTarget.appendChild(item)
        })
      })
  }
}