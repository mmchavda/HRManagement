// app/javascript/application.js

import "@hotwired/turbo-rails"
import "controllers"
import "flowbite"
import "jquery"

window.$ = window.jQuery = window.$ || window.jQuery

$(document).ready(function () {
  console.log("jQuery is ready!")
})

document.addEventListener("turbo:frame-load", () => {
  application.controllers.forEach((controller) => {
    if (typeof controller.connect === "function") {
      controller.connect()
    }
  })
})