_ = require('lodash')

module.exports =
  performQuest: (req, callback)->
    req.currentCharacter.withState(req.db, ->
      quests = req.currentCharacter.quests()

      result = quests.perform(_.toInteger(req.body.quest_id))

      transaction = (t)->
        q1 = @.oneOrNone('update characters set experience=$1 where id=$2', [
          req.currentCharacter.experience + 1, req.currentCharacter.id
        ])
        q2 = @.oneOrNone("update character_states set quests=$1 where character_id=$2",
          [req.currentCharacter.quests().state(), req.currentCharacter.id]
        )

        @.batch([q1, q2])

      transaction.txMode = req.tmS

      req.db.tx(transaction)
      .then((data)->
        callback()
      )
      .catch((error)->
        console.log error
      )
    )
