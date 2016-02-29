Modal = require("../modal")

class QuestPerformResultModal extends Modal
  className: 'quest_perform modal'

  show: ->
    super

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('quests/start_quest_popup')
    )

module.exports = QuestPerformResultModal