_ = require('lodash')

CharacterState = require('../models/character_state')
Character = require('../models/character')

module.exports =
  performQuest: (req, cb)->
#    task = ->
#       # isolation level serializable read write DEFERRABLE
#
#
#
#      data = yield req.db.one("select * from characters where id=$1", 1)
#      character = new Character(data)
#
#      data = yield req.db.one("select * from character_states where character_id = $1", character.id)
#      character.state = new CharacterState(data)
#
#      quests = character.quests()
#
#      result = quests.perform(_.toInteger(req.body.quest_id))
#
#      yield req.db.none('begin')
#
#      yield req.db.oneOrNone('update characters set experience=$1 where id=$2', [
#        character.experience + 1, character.id
#      ])
#
#      yield req.db.oneOrNone("update character_states set quests=$1 where character_id=$2",
#        [character.quests().state(), character.id]
#      )
#
#      yield req.db.none('commit')
#
#    req.db.task(task)
#    .then(-> cb())
#    .catch((err)->
#      req.db.none('rollback').then(-> cb()).catch((e)-> console.log(e))
#      console.error(err)
#
#    )

    req.currentCharacter.withState(req.db, ->
      quests = req.currentCharacter.quests()

      result = quests.perform(_.toInteger(req.body.quest_id))

      transaction = ->
        q1 = @.one('update characters set experience=$1, level = level + 1 where id=$2 and level=$3 returning id', [
          req.currentCharacter.experience + 1, req.currentCharacter.id, req.currentCharacter.level
        ])

        q2 = @.one("update character_states set quests=$1 where character_id=$2 returning character_id",
          [req.currentCharacter.quests().state(), req.currentCharacter.id]
        )

        @.batch([q1, q2])

      transaction.txMode = req.tmS

      req.db.tx(transaction)
      .then(-> cb())
      .catch((err)->
        console.log(err)
        cb()
      )




    )
