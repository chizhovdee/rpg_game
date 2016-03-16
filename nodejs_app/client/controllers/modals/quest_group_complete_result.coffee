Modal = require("../modal")
Quest = require('../../game_data').Quest
request = require('../../lib/request')

class QuestGroupCompleteResultModal extends Modal
  className: 'quest_group_complete modal'

  show: (data)->
    super

    @context = data.context
    @reward = data.reward
    @nextGroupId = data.next_group_id

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('quests/quest_group_complete_result')
    )

  bindEventListeners: ->
    super

    @el.on('click', '.next_group', @.onNextGroupClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.next_group', @.onNextGroupClick)

  onNextGroupClick: =>
    @.close()

    @context.show(@nextGroupId) if @nextGroupId


module.exports = QuestGroupCompleteResultModal