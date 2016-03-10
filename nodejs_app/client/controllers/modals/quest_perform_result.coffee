Modal = require("../modal")
Quest = require('../../game_data').Quest

class QuestPerformResultModal extends Modal
  className: 'quest_perform modal'

  show: (response)->
    super

    console.log 'Modal data', response

    @quest = Quest.find(response.data.quest_id)
    @groupCanComplete = response.data.groupCanComplete
    @reward = response.data.reward

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('quests/quest_perform_result')
    )

module.exports = QuestPerformResultModal