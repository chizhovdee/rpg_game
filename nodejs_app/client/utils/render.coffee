JST = require("../JST").JST # генерируется автоматически при сборке

module.exports =
  renderTemplate: (name, args...)->
    JST[name](_.assignIn({}, @, args...))

  renderRequirements: (requirements, callback)->
    return if !requirements? || _.isEmpty(requirements)

    result = '<div class="requirements">'
    result += callback?(@safe @.renderTemplate("requirements", requirements: requirements))
    result += '</div>'

    @safe result

  renderRewards: (rewards, callback)->
    return if !rewards? || _.isEmpty(_.pickBy(rewards, (v)-> v > 0))

    result = '<div class="rewards">'
    result += callback?(@safe @.renderTemplate("rewards", rewards: rewards))
    result += '</div>'

    @safe result

  renderSpendings: (rewards, callback)->
    return if !rewards? || _.isEmpty(_.pickBy(rewards, (v)-> v < 0))

    result = '<div class="spendings">'
    result += callback?(@safe @.renderTemplate("spendings", rewards: rewards))
    result += '</div>'

    @safe result

  displayResult: (element, data = {}, options = {})->
    element.notify(
      {
        content: @.renderTemplate('notifications/result', data)
      },
      _.assignIn({
        raw: true
        style: 'game'
        className: 'black'
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
        showDuration: 200
        hideDuration: 200
      }, options)
    )

