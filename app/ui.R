library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
	
	titlePanel("Facebook Shiny App"),
	tabsetPanel(id = 'tabs', 
							tabPanel('Players', 
											 tags$div(
											 	selectInput('player1', label = 'Player 1', 
											 							choices = player_options),
											 	selectInput('player2', label = 'Player 2', 
											 							choices = player_options),
											 	style='height:400px')),
							tabPanel('Weekly', ggvisOutput('plot')),
							tabPanel('Total', ggvisOutput('total_plot')),
							tabPanel('t.test', htmlOutput('ttest')))
))