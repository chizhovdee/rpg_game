_ = require('lodash')
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
Character = require('../models').Character

module.exports =
  upgrade: (character, operations)->
    console.log 'Operations', operations

    if _.sum(_.values(operations)) > @points
      return new Result(error_code: "not_enough_points")

    for attribute, value of operations
      return new Result(error_code: "incorrect_attribute") unless Character.UPGRADE_RATES[attribute]?

    character.upgrade(operations)

    new Result() # empty result
