library(shiny)
shinyServer(function(input, output) {
        simulate <- reactive({ 
            set.seed(2018-04-04)
            nr_of_collectors <- input$nr_collectors
            nr_of_sims <- input$nr_simulations
            book <- vector("numeric",length = 682)
            for(i in seq_along(book)) { book[i] = 0 }
            cost <- 0.00
            nr_of_cards <- vector("integer",length = 682)
            for(i in seq_along(nr_of_cards)) { nr_of_cards[i] = 0 }
            costs <- vector("numeric", length = 682)
            for(i in seq_along(costs)) { costs[i] = 0.00 }
            collect_book_stats <- data.frame(nr_of_cards = 0, costs = 0.00)
            add_collect_book_stats <- data.frame(cbind(nr_of_cards, costs))
            mean_book_stats <- data.frame(cbind(nr_of_cards, costs), type_of_value = "simulation")
        
            for(k in 1:nr_of_sims) {
                for(i in 1:100000) {
                    card_nr <- runif(1, min = 1, max = 683)
                    cost <- cost + 0.18    
                    card_nr <- as.integer(card_nr)
                    if((book[card_nr] < nr_of_collectors)) {
                        book[card_nr] <- book[card_nr] + 1
                        cards_found <- sum(book) / nr_of_collectors
                        if((cards_found %% 1 ) == 0) {
                            add_collect_book_stats$nr_of_cards[cards_found] <- cards_found
                            add_collect_book_stats$costs[cards_found] <- cost / nr_of_collectors
                        }
                    }
                    if((sum(book) / nr_of_collectors) >= 682) {
                        collect_book_stats <- rbind(collect_book_stats, add_collect_book_stats)
                        break
                    }
                }
                for(m in 1:length(book)) { book[m] = 0 }
                cost <- 0.00
            }
            for(i in seq_along(mean_book_stats$nr_of_cards)) {
                mean_book_stats$nr_of_cards[i] <- i
                mean_book_stats$costs[i] <- mean(collect_book_stats$costs[collect_book_stats$nr_of_cards == i])
                mean_book_stats$type_of_value[i] <- c("simulation")
            }
            rl_book_stats <- data.frame(nr_of_cards = c(54, 72, 91, 152, 179, 223),
                                        costs = c(9.9, 13.5, 17.1, 31.5, 38.2, 44.9),
                                        type_of_value="real life")
            mean_book_stats <- rbind(mean_book_stats, rl_book_stats)
            mean_book_stats
        })
        output$plot1 <- renderPlotly({
            pal <- c("darkblue","red")
            plot_ly(simulate(), x=~nr_of_cards, y=~costs, color=~factor(type_of_value), colors=pal)
        })
        output$cost_overall <- renderText({
            mean_bk_st <- simulate()
            cost <- mean_bk_st$costs[682]
            cost_out <- paste0("EUR ", formatC(cost, format="f", digits=2, big.mark=".", decimal.mark=","))
            cost_out
            })
        output$cost_reduced <- renderText({
            if(input$cards_ordered > 0) {
            mean_bk_st <- simulate()
            look_for_card <- 682 - input$cards_ordered
            cost <- mean_bk_st$costs[look_for_card]
            cost <- cost + (input$cards_ordered * 0.25) + 2.5
            cost_out <- paste0("EUR ", formatC(cost, format="f", digits=2, big.mark=".", decimal.mark=","))
            cost_out
            }
        })
        output$heading_2 <- renderText({
            if(input$cards_ordered > 0) {
            look_for_card <- 682 - input$cards_ordered
            heading_text <- c("Cost after ", look_for_card, " cards")
            heading_text
            }
        })
        output$expl_txt_red_amnt <- renderText({
            if(input$cards_ordered > 0) {
                output_text <- c("This is the amount you have to spend, when ",
                                 input$cards_ordered,
                                 " cards are ordered at the end, so trading and collecting ends earlier.",
                                 " The amount includes EUR 0,25 for each card ordered.")
            }
        })
                
})       