Modal = require("../modal")
Quest = require('../../game_data').Quest
request = require('../../lib/request')

class QuestPerformResultModal extends Modal
  className: 'quest_perform modal'

  show: (response, @currentGroupId)->
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

  bindEventListeners: ->
    super

    @el.on('click', '.collect_group_reward:not(.disabled)', @.onGroupRewardCollectClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.collect_group_reward:not(.disabled)', @.onGroupRewardCollectClick)

  onGroupRewardCollectClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    request.send('complete_quests_group', @currentGroupId)


module.exports = QuestPerformResultModal