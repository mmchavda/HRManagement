# Pin the application.js entrypoint
pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js"  # or your desired version of turbo.js
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "stimulus-loading", to: "stimulus-loading.js"

# Pin the controllers directory for Stimulus
pin_all_from "app/javascript/controllers", under: "controllers"

# Third-party libraries
pin "flowbite", to: "https://unpkg.com/flowbite@2.2.1/dist/flowbite.js"
pin "lodash", to: "https://cdn.jsdelivr.net/npm/lodash-es/lodash.js"
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"

# Local files
pin "hello", to: "hello.js"
