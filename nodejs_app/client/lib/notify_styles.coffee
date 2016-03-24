$.notify.addStyle("game", {
  html: """
    <div>
      <div data-notify-html='content'></div>
    </div>""",
  classes: {
    error: {
      "color": "#fafafa !important",
      "background-color": "#F71919",
      "border": "1px solid #FF0026"
      "min-width": "250px"
      "text-align": "center"
    },
    success: {
      "color": "#ffffff !important",
      "background-color": "#14A214",
      "border": "1px solid #4DB149"
      "min-width": "250px"
      "text-align": "center"
    },
    info: {
      "color": "#ffffff !important",
      "background-color": "#247FD8",
      "border": "1px solid #1E90FF"
      "min-width": "250px"
      "text-align": "center"
    },
    small_info: {
      "color": "#ffffff !important",
      "background-color": "#247FD8",
      "border": "1px solid #1E90FF"
      "min-width": "150px"
      "text-align": "center"
    },
    warning: {
      "background-color": "#FAFA47",
      "border": "1px solid #EEEE45"
    },
    black: {
      "color": "#fafafa !important",
      "background-color": "#333"
      #"border": "1px solid #000"
    },
    white: {
      "background-color": "#f1f1f1",
      "border": "1px solid #ddd"
    }
  }
})