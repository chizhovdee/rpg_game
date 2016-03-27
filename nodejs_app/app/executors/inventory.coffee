lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
Item = require('../game_data').Item

module.exports =
  buyItem: (itemId, amount, character)->
    console.log "ITEM ID", itemId

    amount = amount || 1

    item = Item.find(itemId)
    price = item.priceByAmount(amount)
    requirement = item.priceRequirement(price)

#    unless level.requirement.viewOn('perform').isSatisfiedFor(character)
#      return new Result(
#        error_code: 'requirements_not_satisfied'
#        data:
#          quest_id: quest.id
#          progress: questsState.progressFor(quest)
#          requirement: level.requirement.viewOn('perform').unSatisfiedFor(character)
#      )

