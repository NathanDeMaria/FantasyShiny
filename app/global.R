
#source('../get_data.R')
plays <- read.csv('plays.csv')

library(data.table)
plays <- data.table(plays)

pass_td <- 4
pass_yard <- 1/25

rec_yard <- 1/10
rec_td <- 6
ppr <- 1

rush_yard <- 1/10
rush_td <- 6

qbs <- plays[Discriminator == 'Pass',
						 list(points = sum(YardGain) * pass_yard +
						 		 		sum(PointsScored == 6) * pass_td),
						 by=c('Week', 'QB', 'OffTeam')]

wrs <- plays[Discriminator == 'Pass',
						 list(points = sum(YardGain) * rec_yard +
						 		 	sum(PointsScored == 6) * rec_td +
						 		 	sum(PassComplete) * ppr),
						 by=c('Week', 'Receiver', 'OffTeam')]

rbs <- plays[Discriminator == 'Run',
						 list(points = sum(YardGain) * rush_yard +
						 		 	sum(PointsScored == 6) * rush_td),
						 by=c('Week', 'RunningBack', 'OffTeam')]


setnames(qbs, 'QB', 'player')
setnames(wrs, 'Receiver', 'player')
setnames(rbs, 'RunningBack', 'player')

combined <- rbindlist(list(qbs, wrs, rbs))
final_table <- combined[,list(points=sum(points)),by=c('Week', 'player', 'OffTeam')]
final_table[,player:=as.character(player)]


library(ggvis)
plot_weekly <- function(selected_player1, selected_player2) {
	
	selected <- translate_selections(selected_player1, selected_player2)
	
	data.frame(final_table[
			(selected$p1 == player & selected$tm1 == OffTeam) |
			(selected$p2 == player & selected$tm2 == OffTeam)	
		,]) %>% 
		ggvis(~Week, ~points, stroke=~player) %>% layer_lines() %>% add_tooltip(function(df) {df$player})
}

player_options <- unique(final_table[,list(player, OffTeam),])[,list(catted=paste(player, OffTeam)),]$catted

plot_totals <- function(selected_player1, selected_player2) {
	
	selected <- translate_selections(selected_player1, selected_player2)
	
	data.frame(final_table[(selected$p1 == player & selected$tm1 == OffTeam) |
												 	(selected$p2 == player & selected$tm2 == OffTeam),
												 list(total=sum(points)),by=c('player', 'OffTeam')]) %>% 
		ggvis(~player, ~total) %>% layer_bars(stat='identity')
}


translate_selections <- function(selected_player1, selected_player2) {
	
	list(
		p1 = strsplit(selected_player1, ' ')[[1]][1],
		tm1 = strsplit(selected_player1, ' ')[[1]][2],
		p2 = strsplit(selected_player2, ' ')[[1]][1],
		tm2 = strsplit(selected_player2, ' ')[[1]][2]			
		)
}
