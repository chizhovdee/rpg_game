exports.index = (req, res)->
  res.locals.okSignedParams = req.okSignedParams

  res.render('index', title: 'Rpg Game')