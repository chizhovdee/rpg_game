_ = require('lodash')
QuestGroup = require('../game_data/quest_group')
Quest = require('../game_data/quest')
QuestLevel = require('../game_data/quest_level')


class QuestsState
  DEFAULT_STATE = {
    quests: {} # quest_id: [step, level, completed]
    groups_completed: []
    current_group: null
  }

  character: null
  state: null

  constructor: (character)->
    @character = character

    throw new Error("character state undefined") unless @character.state?

    @state = @character.state.quests
    @state ?= _.defaultsDeep({}, DEFAULT_STATE)

  currentGroup: ->
    group = QuestGroup.find(@state.current_group) if @state.current_group
    group ?= QuestGroup.first()

    group

  questsWithProgressByGroup: (group)->
    Quest.findAllByAttribute('quest_group_key', group.key).map((quest)=>
      progress = @state.quests[quest.id]
      progress ?= [0, 1, false]

      [quest.id].concat(progress)
    )



module.exports = QuestsState