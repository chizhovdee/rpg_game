Item = require('../game_data').Item

module.exports =
  progressBar: (value, label = null)->
    labelStr = ""
    labelStr += "<div class='label'>#{label}</div>" if label

    """
    #{labelStr}
    <div class="progress_bar">
        <div class="percentage" style="width: #{ value }%"></div>
    </div>"""

  formatNumber: (number, spacer = '&thinsp;')->
    "#{number}".replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1#{ spacer }")

  itemName: (item)->
    console.log item
    console.log Item.find(item)
    unless item instanceof Item
      item = Item.find(item)

    item.name()