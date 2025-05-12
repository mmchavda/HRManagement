import { Application } from "@hotwired/stimulus"
import AuditToggleController from "controllers/audit_toggle_controller"
import ToggleController from "controllers/toggle_controller"
import LiveSearchController from "controllers/live_search_controller"
import ReadMoreController from "controllers/read_more_controller"

const application = Application.start()
application.register("audit-toggle", AuditToggleController)
application.register("toggle", ToggleController)
application.register("live-search", LiveSearchController)
application.register("read-more", ReadMoreController)