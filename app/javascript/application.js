import "@hotwired/turbo-rails"
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
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