# config/importmap.rb

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"
pin "flowbite", to: "https://unpkg.com/flowbite@2.2.1/dist/flowbite.js"

# Custom local JS (if needed)
pin "hello", to: "hello.js"
