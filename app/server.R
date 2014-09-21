library(shiny)

shinyServer(function(input, output, session) {
	
	observe({
		plot_weekly(input$player1, input$player2) %>% bind_shiny('plot')
		plot_totals(input$player1, input$player2) %>% bind_shiny('total_plot')
		
		output$ttest <- renderPrint({
			
			selected <- translate_selections(input$player1, input$player2)
			
			player1 <- final_table[selected$p1 == player 
														 & selected$tm1 == OffTeam,]
			
			player2 <- final_table[selected$p2 == player 
														 & selected$tm2 == OffTeam,]
			
			ttest <- capture.output(t.test(player1$points, player2$points))
			cat(paste(ttest, collapse='<br/>'))
		})
	})
	
})