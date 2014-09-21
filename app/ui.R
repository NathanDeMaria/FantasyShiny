library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
	
	titlePanel("Facebook Shiny App"),
	tabsetPanel(id = 'tabs', 
							tabPanel('Players', 
											 tags$div(
											 	tags$h3('Select players to compare'),
											 	selectInput('player1', label = 'Player 1', 
											 							choices = player_options),
											 	selectInput('player2', label = 'Player 2', 
											 							choices = player_options),
											 	style='height:400px')),
							tabPanel('Weekly', tags$h3('Points per week'), ggvisOutput('plot')),
							tabPanel('Total', tags$h3('Total points'), ggvisOutput('total_plot')),
							tabPanel('t.test', tags$h3('t.test comparing point distributions'), 
											 htmlOutput('ttest')))
))