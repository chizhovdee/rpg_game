Popup = require("../../lib/base_popup")

class QuestPerformResultPopup extends Popup
  className: 'quest_perform popup'

  show: ->
    super

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('quests/start_quest_popup')
    )

module.exports = QuestPerformResultPopup