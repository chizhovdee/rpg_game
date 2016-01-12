exports.gameData = (req, res)->
  res.json(abc: 11111, ddd: "hui")

exports.status = (req, res)->
  res.json(abc: 11111, ddd: "hui", status: "abc")