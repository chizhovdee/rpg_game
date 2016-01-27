class Pagination
  constructor: (@per_page)->
    @start_count = 0
    @can_forward = false
    @switches = []

  paginate: (scope, options = {})->
    if scope.length == 0
      @can_forward = false
      @start_count = 0

      return []

    if options.initialize
      @start_count = 0
    else if options.start_count?
      @start_count = options.start_count
    else if options.back
      @start_count -= @per_page
    else if options.by_position?
      if options.by_position > @per_page
        @start_count = (Math.ceil(options.by_position / @per_page) - 1) * @per_page
      else
        @start_count = 0

    else if scope.length >= @start_count + @per_page
      @start_count += @per_page

    @start_count = 0 if @start_count < 0
    stop_count = @start_count + @per_page

    @can_forward = scope.length > stop_count

    scope[@start_count...stop_count]

  setSwitches: (scope)->
    @switches = []

    return if scope.length == 0

    pages = Math.ceil(scope.length / @per_page)

    count = 0

    while count < pages
      count += 1

      @switches.push([count, (count - 1) * @per_page])

  canForward: ->
    @can_forward

  canBack: ->
    @start_count > 0

module.exports = Pagination