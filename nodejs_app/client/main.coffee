require('./lib/extends_vendors') # расширения для сторонних библиотек

App = require("./app")

$(->
  new App()
)