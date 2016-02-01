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
  _state: null
  isChanged: false

  constructor: (character)->
    @character = character

    throw new Error("character state undefined") unless @character.state?

    @_state = @character.state.quests
    @_state ?= _.defaultsDeep({}, DEFAULT_STATE)

  state: ->
    @_state

  progressForQuest: (quest)->
    @.state().quests[quest.id] || [0, 1, false] # [step, level, completed]

  currentGroup: ->
    group = QuestGroup.find(@state.current_group) if @state.current_group
    group ?= QuestGroup.first()

    group

  questsWithProgressByGroup: (group)->
    Quest.findAllByAttribute('quest_group_key', group.key).map((quest)=>
      [quest.id].concat(@.progressForQuest(quest))
    )

  perform: (quest_id)->
    quest = Quest.find(quest_id)

    progress = @.progressForQuest(quest)
    progress[0] += 1 # 1 step for one

    @_state.quests[quest.id] = progress

    @isChanged = true

    true

module.exports = QuestsState