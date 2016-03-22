EXPERIENCE = [0]

baseExperience = (level)->
  5 * level + 40

experienceByLevel = (level)->
  Math.round(level * baseExperience(level))

for level in [1..100]
  EXPERIENCE.push( experienceByLevel(level) + (EXPERIENCE[level - 1] || 0) )

#console.log EXPERIENCE

module.exports =
  experienceByNextLevel: ->
    EXPERIENCE[@level]

  experienceToNextLevel: ->
    @.experienceByNextLevel() - @experience

  levelByCurrentExperience: ->
    level = 0

    for experience in EXPERIENCE
      if experience <= @experience
        level += 1
      else
        break

    level

  levelProgressPercentage: ->
    Math.round(
      100 - @.experienceToNextLevel() / (@.experienceByNextLevel() - EXPERIENCE[@level - 1]) * 100
    )
