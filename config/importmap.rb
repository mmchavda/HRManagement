# Pin npm packages by running ./bin/importmap
pin_all_from "app/javascript/controllers", under: "controllers"
pin "application"
pin "lodash", to: "https://cdn.jsdelivr.net/npm/lodash-es/lodash.js"
pin "hello", to: "hello.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin "flowbite", to: "https://unpkg.com/flowbite@2.2.1/dist/flowbite.js"
