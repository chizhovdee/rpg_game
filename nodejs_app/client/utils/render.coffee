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
    return if !rewards? || _.isEmpty(
      _.pickBy(rewards, (value)->
        if _.isObject(value)
          not _.isEmpty(_.pickBy(value, (_value)-> _value > 0))
        else
          value > 0
      )
    )

    result = '<div class="rewards">'
    result += callback?(@safe @.renderTemplate("rewards", rewards: rewards))
    result += '</div>'

    @safe result

  renderSpendings: (rewards, callback)->
    return if !rewards? || _.isEmpty(
      _.pickBy(rewards, (value)->
        if _.isObject(value)
          not _.isEmpty(_.pickBy(value, (_value)-> _value < 0))
        else
          value < 0
      )
    )

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

  displayReward: (element, reward, options = {})->
    element.notify(
      {
        content: @.renderTemplate('notifications/reward', reward: reward)
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

  displayError: (message)->
    $('#application .notification').notify(
      {content: message}
      {
        elementPosition: 'top center'
        arrowShow: false
        style: 'game'
        className: 'error'
        showDuration: 200
      }
    )

  displaySuccess: (message)->
    $('#application .notification').notify(
      {content: message}
      {
        elementPosition: 'top center'
        arrowShow: false
        style: 'game'
        className: 'success'
        showDuration: 200
        autoHideDelay: _(10).seconds()
      }
    )

  displayPopup: (element, content, options = {})->
    element.notify(
      {
        content: content
      },
      _.assignIn({
        raw: true
        style: 'game'
        className: 'black'
        autoHide: false
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
        showDuration: 200
        hideDuration: 200
      }, options)
    )
