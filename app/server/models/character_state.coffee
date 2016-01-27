class CharacterState
  quests: null

  constructor: (attributes)->
    _.extend(@, attributes) if attributes