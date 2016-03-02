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
  isChanged: false

  constructor: (characterState)->
    throw new Error("character state undefined") unless characterState?

    @state = characterState.quests
    @state ?= _.defaultsDeep({}, DEFAULT_STATE)

  progressForQuest: (quest)->
    @state.quests[quest.id] || [0, 1, false] # [step, level, completed]

  currentGroup: ->
    group = QuestGroup.find(@state.current_group) if @state.current_group
    group ?= QuestGroup.first()

    group

  questsWithProgressByGroup: (group)->
    Quest.findAllByAttribute('quest_group_key', group.key).map((quest)=>
      [quest.id].concat(@.progressForQuest(quest))
    )

  levelFor: (quest)->
    quest.levelByNumber(@.progressForQuest(quest)[1])

  perform: (quest)->
    progress = @.progressForQuest(quest)
    progress[0] += 1 # 1 step for one

    @state.quests[quest.id] = progress

    @isChanged = true

    true

module.exports = QuestsState