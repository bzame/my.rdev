#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny);
library(DT);
library(plotly);

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
	
	require(MASS);
	
	show("pb");
	tmp = mget(ls("package:MASS"), as.environment("package:MASS"));
	datasetList = reactiveVal();
	datasetList = names(tmp[sapply(tmp, is.data.frame)]);
	
	updateSelectInput(session, "selectedDataset", choices=datasetList);
	hide("pb");
	
	currentDataset = NULL;
	
	
	observeEvent(
		{ input$selectedDataset }
		, { 
			if(!is.null(input$selectedDataset) && stringr::str_length(input$selectedDataset)>0) {
				show("pb");
				currentDataset <<- get(
					input$selectedDataset
					, envir=as.environment("package:MASS")
				);
				
				updateSelectInput(session, "varDist", choices=colnames(currentDataset));
				
				output$tabDataType = DT::renderDataTable(
					datatable( 
						data.frame(
							column = colnames(currentDataset)
							, class = apply(currentDataset, 2, class)
							, naProp = apply(is.na(currentDataset), 2, sum)/NROW(currentDataset)
							, factLev = sapply(
								sapply(1:NCOL(currentDataset),function(i, data) { if(is.factor(data[,i])) { return(levels(data[,i])); } else { return(NULL); } }, data=currentDataset )
								, paste, collapse=", "
							)
							, vmean = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(mean(data[,i])); } else { return(NA); } }, data=currentDataset
							)
							, vsd = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(sd(data[,i])); } else { return(NA); } }, data=currentDataset
							)
							, vmin = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(min(data[,i])); } else { return(NA); } }, data=currentDataset
							)
							, vq25 = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(quantile(data[,i], 0.25)); } else { return(NA); } }, data=currentDataset
							)
							, vq50 = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(quantile(data[,i], 0.50)); } else { return(NA); } }, data=currentDataset
							)
							, vq75 = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(quantile(data[,i], 0.75)); } else { return(NA); } }, data=currentDataset
							)
							, vmax = sapply(
								1:NCOL(currentDataset), function(i, data) { if(is.numeric(data[,i])) { return(max(data[,i])); } else { return(NA); } }, data=currentDataset
							)
						)
						, style = "bootstrap"
						, colnames = c("Column", "Data Type", "NA Proportion", "Factor Levels", "Mean", "S.D.", "Min", "25th Quantile", "Median", "75th Quantile", "Max")
						, rownames = FALSE
						, options = list(
							paging=FALSE, searching=FALSE
						)
					) %>% 
						formatPercentage(3) %>%
						formatRound(5:11, 2)
				);
				
				output$tabDataView = DT::renderDataTable(
					datatable(
						currentDataset
						, style = 'bootstrap'
					)
				); 
				
				# Sys.sleep(5)
				hide("pb");
			}
		}
	);



	observeEvent(
		{ input$varDist }
		, {
			if(!is.null(currentDataset)) {
				if(is.factor(currentDataset[, input$varDist])) {
					tmp = data.table::dcast(data.table::data.table(subset(currentDataset, select=input$varDist)), formula(paste0(input$varDist,"~.")), list(count=length), value.var=input$varDist);
					names(tmp) = c(input$varDist, "freq");
					print(tmp);
					output$plotDist = renderPlotly(
						plot_ly(as.data.frame(tmp), x=formula(paste0("~", input$varDist)), y=~freq, type="bar")
					);
				} else if(is.numeric(currentDataset[, input$varDist])) {
					
				}
			} 
		}
	);
	
});
