_ = require('lodash')
Result = require('../result')

# находит объект класса Result и возвращает его
parseResult = (result)->
  if _.isArray(result)
    for r in result
      if r instanceof Result
        return r
  else
    result if result instanceof Result

# просто сохраняем ссылку на результа исполнения
addResult = (result)->
  throw new Error('undefined result') unless result

  @executorResult = result

# сохранение ресурсов в базы данных: postgresql, redis
updateResources = (transaction, resources...)->
  throw new Error('you need to add the result of the execution') unless @executorResult?

  unless @executorResult.isError()
    if resources.length == 1
      if resources[0].update? then resources[0].update(transaction) else resources[0]

    else
      transaction.batch(
        resources.map((resource)->
          if resource.update? then resource.update(transaction) else resource
        )
      )

module.exports = (req, res, next)->
  res.parseResult = parseResult

  res.addResult = addResult

  res.updateResources = updateResources

  next()