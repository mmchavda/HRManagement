import { Application } from "@hotwired/stimulus"
import AuditToggleController from "controllers/audit_toggle_controller"
import ToggleController from "controllers/toggle_controller"
import LiveSearchController from "controllers/live_search_controller"
import ReadMoreController from "controllers/read_more_controller"
import DropdownController from "controllers/dropdown_controller"
import DeleteModalController from "controllers/delete_modal_controller"
import AutoDismissController from "controllers/auto_dismiss_controller"
import FlatpickrController from "controllers/flatpickr_controller"
import RemoveFileController from "controllers/remove_file_controller"

const application = Application.start()
application.register("audit-toggle", AuditToggleController)
application.register("toggle", ToggleController)
application.register("live-search", LiveSearchController)
application.register("read-more", ReadMoreController)
application.register("dropdown", DropdownController)
application.register("delete-modal", DeleteModalController)
application.register("auto-dismiss", AutoDismissController)
application.register("flatpickr", FlatpickrController)
application.register("remove-file", RemoveFileController)
