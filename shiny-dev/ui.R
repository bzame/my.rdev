#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny);
library(shinyjs);
library(DT);
library(plotly);

source("shinyTheme.R")
source("progressBar.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(style="width: 1280px; margin:auto", useShinyjs(), 
  
    # Application title
    titlePanel("Dataset explorer")
    
    # Sidebar with a slider input for number of bins 
    , sidebarLayout(
    	sidebarPanel(
    		themeSelector()
    		, hr(style="border-color: white;")
    	    , selectInput("selectedDataset", "Pick a MASS dataset", choices=list())
    	    , hr(style="border-color: white;")
    		, fileInput("locFile", "Pick a local file", multiple = FALSE,
    				  accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
    		, hr(style="border-color: white;")
    		, progressBar(id="pb", value=100, stripe=TRUE, active=TRUE)
    	),
    
    	# Show a plot of the generated distribution
    	mainPanel(
    		tabsetPanel(
    			tabPanel("Summary"
	       			, h2("Simple Summary")
	       			, DT::dataTableOutput("tabDataType")
    			)
    			, tabPanel("Plot"
					, verticalLayout(
						h2("Graphical Explorer")
						, fluidRow(column(3, selectInput("varDist", "Pick a variable", choices=list())))
						, plotlyOutput("plotDist")
					)
			   )
       			, tabPanel("Data"
	       			, h2("Dataset")
	    			, DT::dataTableOutput("tabDataView")
       			)
       		)
    	)
  	)
));
