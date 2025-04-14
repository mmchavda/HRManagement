import { Application } from "@hotwired/stimulus"
import { definitionsFromExternalContext } from "@hotwired/stimulus-webpack-helpers"
import { registerControllers } from "stimulus-vite-helpers"

import.meta.glob(["./**/*.js", "./**/*.ts"], { eager: true })

const application = Application.start()
const context = require.context(".", true, /\.js$/)
application.load(definitionsFromExternalContext(context))
