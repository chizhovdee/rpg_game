gulp = require("gulp")
fs = require("fs")
ejs = require("ejs")

models = require('../app/models')

data = {
  characterUpgradeRates: models.Character.UPGRADE_RATES
}

gulp.task("client_settings", ->
  tmpl = fs.readFileSync("./client/settings.ejs")

  result = ejs.render(tmpl.toString(), data)

  fs.mkdir('./build', ->
    fs.mkdir('./build/client', ->
      fs.writeFileSync("./build/client/settings.js", result)
    )
  )
)