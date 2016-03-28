assets = require('./assets')
Item = require('../game_data').Item

module.exports =
  itemPictureUrl: (item, format = 'large')->
    unless item instanceof Item
     item = Item.find(item)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for item picture url not correct')

    assets.assetsPath("images/items/#{ format }/#{ item.key }.jpg")

  itemPicture: (item, format = 'large')->
    unless item instanceof Item
      item = Item.find(item)

    title = "title=#{item.name()}"

    "<img src='#{ @.itemPictureUrl(item, format) }' #{title} />"