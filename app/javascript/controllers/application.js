// import { Application } from "@hotwired/stimulus"
// import { definitionsFromContext } from "@hotwired/stimulus-loading"

// const application = Application.start()
// const context = require.context(".", true, /\.js$/)
// application.load(definitionsFromContext(context))

// export { application }

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }