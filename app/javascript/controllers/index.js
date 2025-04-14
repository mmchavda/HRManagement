import { Application } from "@hotwired/stimulus"
import FilterController from "controllers/filter_controller";  // Adjust path if needed

const application = Application.start();
application.register("filter", FilterController);