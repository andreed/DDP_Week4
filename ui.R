library(shiny)
library(plotly)
shinyUI(fluidPage(
    titlePanel("Cost for Panini Stickers"),
    sidebarLayout(
        sidebarPanel(
            numericInput("nr_collectors", "How many collectors should be simulated", 
                         value = 1, min = 1, max = 10, step = 1),
            p("if you collect for yourself, enter 1"),
            p("if you have e.g. two friends to trade cards with, enter 3 (yourself plus 2)"),
            p(" "),
            numericInput("nr_simulations", "How many simulations should be done",
                         value = 10, min = 10, max = 100, step = 10),
            p("please don't do more than 100 simulations"),
            p(" "),
            numericInput("cards_ordered", "How many cards will be ordered at the end",
                         value = 0, min = 0, max = 50, step = 10),
            p("up to 50 cards can be ordered at the end of collecting them"),
            submitButton("Submit")
        ),
        mainPanel(
            h3("Simulating cost over number of cards"),
            plotlyOutput("plot1"),
            h3("Cost after 682 cards"),
            p(c("All Costs are averaged for one collector (so the complete costs have been divided by the number of collectors).")),
            textOutput("cost_overall"),
            p(c("This is the amount of money you have to spend if you keep collecting ",
                "(and trading) until you have all cards.")),
            textOutput("cost_reduced"),
            textOutput("expl_txt_red_amnt"),
            h3("What does simulation and real life mean?"),
            p("The simulation dots are 682 means of the simulated values."),
            p(c("Real life shows values from our collection (me and my kids). ",
                "They are a little mixed, we started trading at some stage."))
        )
    )
))           