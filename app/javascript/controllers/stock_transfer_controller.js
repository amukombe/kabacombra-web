import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stock-transfer"
export default class extends Controller {
  static targets = ["warehouseSection", "distributorSection", "territorySection", "sourceSelect", "destinationSelect"]
  connect() {
    console.log("Stock transfer connected!");
  }

  async displayControls(event) {
    const transferType = event.target.value;
    this.resetSections();

    switch (transferType) {
      case "warehouse_transfer":
        this.warehouseSectionTarget.classList.remove("hidden");
        this.distributorSectionTarget.classList.add("hidden");
        this.territorySectionTarget.classList.add("hidden");
        this.enableSelects(this.sourceSelectTarget, this.destinationSelectTarget);
        break;

      case "branch_transfer":
        this.territorySectionTarget.classList.remove("hidden");
        this.warehouseSectionTarget.classList.add("hidden");
        this.distributorSectionTarget.classList.add("hidden");

        // Pre-select current territory as source and disable it
        this.sourceSelectTarget.value = this.sourceSelectTarget.dataset.currentTerritoryId;
        this.sourceSelectTarget.setAttribute("disabled", true);
        this.destinationSelectTarget.removeAttribute("disabled");
        break;

      case "distributor_transfer":
        this.distributorSectionTarget.classList.remove("hidden");
        this.warehouseSectionTarget.classList.add("hidden");
        this.territorySectionTarget.classList.add("hidden");
        this.enableSelects(this.sourceSelectTarget, this.destinationSelectTarget);
        break;

      default:
        this.resetSections();
    }
  }

  resetSections() {
    this.warehouseSectionTarget.classList.add("hidden");
    this.distributorSectionTarget.classList.add("hidden");
    this.territorySectionTarget.classList.add("hidden");
    this.enableSelects(this.sourceSelectTarget, this.destinationSelectTarget);
  }

  enableSelects(...selects) {
    selects.forEach(select => select.removeAttribute("disabled"));
  }
}
