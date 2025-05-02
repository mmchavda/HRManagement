import { Application } from "@hotwired/stimulus"
import HelloController from "controllers/hello_controller" 
import ConfirmModalController from "controllers/confirm_modal_controller"
import AuditToggleController from "controllers/audit_toggle_controller"
import ToggleController from "controllers/toggle_controller"

const application = Application.start()
application.register("confirm-modal", ConfirmModalController)
application.register("audit-toggle", AuditToggleController)
application.register("hello", HelloController)
application.register("toggle", ToggleController)