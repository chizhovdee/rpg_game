exports.gameData = (req, res)->
  res.eventResponse.add("character_game_data_loaded", (data)->
    data.character = {
      id: 1
      level: 1
      basic_money: 10
      vip_money: 1
      restorable_ep: 10
      energy_points: 10
      restorable_hp: 10
      health_points: 10
      experience: 0
      hp_restore_in: 100
      ep_restore_in: 100
    }
  )

  res.json(res.eventResponse.all())

exports.status = (req, res)->
  res.json(abc: 11111, ddd: "hui", status: "abc")