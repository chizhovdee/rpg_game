module.exports =
  one: (eventName, callback)->
    Spine.Events.one(eventName, callback)

  bind: (eventName, callback)->
    Spine.Events.bind(eventName, callback)

  unbind: (eventName, callback)->
    Spine.Events.unbind(eventName, callback)

  trigger: (eventName, data)->
    Spine.Events.trigger(eventName, data)

  send: (eventName, data)->
    if @[eventName]?
      @[eventName](data)
    else
      console.error 'Unknown event type:', eventName, data

  processResponse: (response)->
    if response == 'NOT LOGGED'
      alert('NOT LOGGED')
      return

    @.trigger(res.event_type, res.data) for res in response

  prefixUrl: (url)->
    "/api/777/#{url}"

  ajax: (type, url, data)->
    $.ajax(
      type: type
      url: @.prefixUrl(url)
      data: data
      dataType: "json"
      success: (response)=>
        @.processResponse(response)

      error: (xhr, type)->
        console.error("Ajax error!", xhr, type)
    )

  get: (url, data)->
    @.ajax("GET", url, data)

  post: (url, data)->
    @.ajax("POST", url, data)

  put: (url, data)->
    @.ajax("PUT", url, data)

  delete: (url, data)->
    @.ajax("DELETE", url, data)

  loadCharacterGameData: ->
    @.get("characters/game_data.json")

  load_character_status: ->
    @.get("characters/status.json")

  load_quests: (data)->
    @.get('quests.json', data)

  perform_quest: (data)->
    @.put('quests/perform.json', data)
