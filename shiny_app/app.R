library(shiny)
library(shinythemes)
library(data.table)

# check these file names
crimes2019 = read.csv("../police/allcrimesnoarea.csv")
crimesType = read.csv("../police/crimetypes.csv")
crimesMonth = unique(crimes2019$Month)

# user interface (has to call the server for custom functions
ui = fluidPage(
    theme = shinytheme("united"), 
    navbarPage("Crimes in London", 
               tabPanel("Crimes data", 
                        sidebarPanel(
                            tags$h3("Crime data"), 
                            textInput(inputId = "txtLocation", label = "Location:", value = "London"), 
                            textInput(inputId = "txtBrief", label = "Brief Description", value = ""), 
                            selectInput(inputId = "siType", 
                                        label = "Crime type", 
                                        choices = crimesType), 
                            radioButtons(inputId = "rbMonth", 
                                         label = "Month", 
                                         choices = crimesMonth), 
                            actionButton(inputId = "submitbutton", 
                                         label = "Submit", 
                                         class = "btn btn-primary")
                        ), 
                        mainPanel(
                            h1("About the crime"), 
                            h4("Description"), 
                            verbatimTextOutput("txtOutput"), 
                            tags$h4("Crime data = The first 5 rows"), 
                            tableOutput("tabledataHead"), 
                            tags$h4("Crime data = The last 5 rows"), 
                            tableOutput("tabledataTail")
                        )
               ), 
               tabPanel("Histogram", 
                        sidebarPanel(), 
                        mainPanel()
               )
    )
)

# server (defines custom functions
server = function(input, output, session) {
    
    # custom function 1
    output$txtOutput = renderText(paste(input$txtLocation, input$txtBrief, sep = "\n\n"))
    
    # custom function 2 part a
    datasetInputHead = reactive({
        crimeData = crimes2019[which(crimes2019$Crime.type == input$siType), ]
        crimeData = crimeData[which(crimeData$Month == input$rbMonth), ]
        print(head(crimeData))
    })
    
    # custom function 2 part b
    output$tabledataHead = renderTable(if (input$submitbutton > 0) { isolate(datasetInputTail()) })
    
    # custom function 3 part a
    datasetInputTail = reactive({
        crimeData = crimes2019[which(crimes2019$Crime.type == input$siType), ]
        crimeData = crimeData[which(crimeData$Month == input$rbMonth), ]
        print(tail(crimeData))
    })
    
    # custom function 3 part b
    output$tabledataTail = renderTable(if (input$submitbutton > 0) { isolate(datasetInputTail()) })
}

# run
shinyApp(ui = ui, server = server)


