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

    unless item?
      return new Result(
        error_code: 'item_not_found'
        data:
          item_id: itemId
      )

    if character.level < item.level
      return new Result(error_code: 'not_reached_level')

    if amount < 0
      return new Result(
        error_code: 'amount_is_less_than_zero'
        data:
          item_id: itemId
      )

    price = item.priceByAmount(amount)
    requirement = item.priceRequirement(price)

    unless requirement.isSatisfiedFor(character)
      return new Result(
        error_code: 'requirements_not_satisfied'
        data:
          item_id: item.id
          requirement: requirement.unSatisfiedFor(character)
      )

    reward = new Reward(character)
    requirement.apply(reward)
    reward.giveItem(item, amount)

    new Result(
      data:
        reward: reward
        item_id: item.id
        amount: amount
    )

