module.exports = {
  content: [
    './app/views/**/*.{html,erb}',
    './app/helpers/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './node_modules/flowbite/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('flowbite/plugin')
  ],
}
