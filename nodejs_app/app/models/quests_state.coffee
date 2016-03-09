_ = require('lodash')
QuestGroup = require('../game_data/quest_group')
Quest = require('../game_data/quest')
QuestLevel = require('../game_data/quest_level')

class QuestsState
  DEFAULT_STATE = {
    quests: {} # quest_id: [step, level, completed]
    groups_completed: []
    current_group_id: null
  }

  character: null
  state: null

  constructor: (@characterState)->
    throw new Error("character state undefined") unless @characterState?

    @state = _.cloneDeep(@characterState.quests)
    @state ?= _.defaultsDeep({}, DEFAULT_STATE)

  progressFor: (quest)->
    @state.quests[quest.id] || [0, 1, false] # [step, level, completed]

  currentGroup: ->
    group = QuestGroup.find(@state.current_group_id) if @state.current_group_id
    group ?= QuestGroup.first()

    group

  questsWithProgressByGroup: (group)->
    group.quests.map((quest)=>
      [quest.id].concat(@.progressFor(quest))
    )

  levelFor: (quest)->
    quest.levelByNumber(@.progressFor(quest)[1])

  perform: (quest, level)->
    progress = @.progressFor(quest)
    progress[0] += 1 # 1 step for one

    progress[2] = true if progress[0] >= level.steps # complete this level

    @state.quests[quest.id] = progress
    @state.current_group_id = quest.group.id

    @characterState.quests = @state

    true

  questIsCompleted: (quest)->
    @.progressFor(quest)[2]

  canGoToNextLevel: (group, level)->

  groupIsCompleted: (group)->
    group.id in @state.groups_completed

  groupCanComplete: (group)->
    return false if @.groupIsCompleted(group)

    for quest in group.quests
      progress = @.progressFor(quest)

      return false unless progress[2] # if quest not completed
      return false unless quest.levelNumberIsLast(progress[1])

    true

module.exports = QuestsState