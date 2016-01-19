DesignUtils =
  progressBar: (value)->
    """
    <div class="progress_bar">
        <div class="percentage" style="width: #{ value }%"></div>
    </div>"""

  formatNumber: (number, spacer = '&thinsp;')->
    "#{number}".replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1#{ spacer }")

module.exports = DesignUtils