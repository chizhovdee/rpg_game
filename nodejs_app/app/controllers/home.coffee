exports.index = (req, res)->
  res.locals.okSignedParams = req.okSignedParams
  res.locals.offlineSignedParams = req.offlineSignedParams
  res.render('index', title: 'Rpg Game')