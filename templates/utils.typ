#let format-date(yyyy-mm-dd) = {
  let timespans = yyyy-mm-dd.split("-").map(timespan => { int(timespan) })
  let date = datetime(
    year: timespans.at(0),
    month: timespans.at(1),
    day: timespans.at(2),
  )
  date.display("[month repr:long] [day padding:none], [year]")
}

// #format-date("2003-10-02")

#let sidenote(body) = {
  counter(footnote).step()
  context {
    let n = counter(footnote).get().first()

    html.span(class: "sidenote")[
      #html.input(
        aria-label: "Show sidenote",
        type: "checkbox",
        id: "sidenote__checkbox--" + str(n),
        class: "sidenote__checkbox",
      )
      #html.elem("label", attrs: (
        tabindex: "0",
        // title: str(body),
        aria-describedby: "sidenote-" + str(n),
        "for": "sidenote__checkbox--" + str(n),
        class: "sidenote__button",
      ))[
        #super[#n]
      ]
      #html.small(
        id: "sidenote-" + str(n),
        class: "sidenote__content sidenote__content--number-" + str(n),
      )[
        #html.span(class: "sidenote__content-parenthesis")[(sidenote: ]
        #super[#n]#body#html.span(class: "sidenote__content-parenthesis")[)]
      ]
      #html.div(class:"markendofspan")
    ]
  }
}

// So like, gamer.#sidenote[whaaaat] And another!#sidenote[cool kids.]
