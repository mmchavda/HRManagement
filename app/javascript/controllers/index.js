import { Application } from "@hotwired/stimulus"
import HelloController from "controllers/hello_controller" 
import ConfirmModalController from "controllers/confirm_modal_controller"

const application = Application.start()
application.register("hello", HelloController)
application.register("confirm-modal", ConfirmModalController)