assets = require('./assets')

module.exports =
  itemPictureUrl: (itemOrKey, format = 'large')->
    if _.isString(itemOrKey)
      key = itemOrKey
    else
      key = itemOrKey.key

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for item picture url not correct')

    assets.assetsPath("images/items/#{ format }/#{ key }.jpg")

  itemPicture: (itemOrKey, format = 'large')->
    title = if _.isString(itemOrKey) then null else "title=#{itemOrKey.name()}"

    "<img src='#{ @.itemPictureUrl(itemOrKey, format) }' #{title} />"