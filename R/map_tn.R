# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

map_tn <- function() {

  library(shiny)
  library(shinythemes)
  library(DT)
  library(leaflet)
  library(RColorBrewer)

  #read data
  library(readxl)
  data_med <- read_excel("data.xlsx")
  #import map
  library(raster)
  m_gouv<- getData(name="GADM",  country="TUN", level=1)
  i=match(m_gouv$HASC_1,data_med$HASC_1)

  ui <- fluidPage(theme = shinythemes::shinytheme("flatly"),
                  # Application title
                  titlePanel("Tunisia Healthcare"),

                  tags$head(
                    tags$style(HTML(
                      "#text{
                      font-family: 'Source Sans Pro';
                      font-size: large;
                      text-align: center;
                      color: #8B0000;}"))),

                  navbarPage("Healthcare",
                             tabPanel("MAP",

                                      sidebarPanel(
                                        selectInput("var","Choose a variable",choices=colnames(data_med[,-c(1,2)]))
                                      ),

                                      mainPanel(
                                        textOutput("text"),
                                        leafletOutput("mymap")
                                      )
                             ),


                             tabPanel("DATA",
                                      DT::dataTableOutput("table")
                             )


                  )
                    )

  # Define server logic required to draw a histogram
  server <- function(input, output) {

    output$table <- DT::renderDataTable({
      data_med
    })


    output$mymap <- renderLeaflet({

      #a=unlist(data_med[,input$var])
      a=unlist(data_med[i,input$var])
      m_gouv$x=as.numeric(a)

      my_popup <- paste0("<strong>",m_gouv@data$NAME_1,"</strong>"," (",input$var,": ",round(m_gouv@data$x,1),")")

      #MyPaletteColor <- colorBin("YlOrBr", domain=300:4150,bins=11,na.color = "white",reverse = FALSE)
      pal <- colorNumeric(
        palette = "Blues",
        domain = data_med[,input$var])

      Legend=m_gouv@data$x

      mm<-leaflet(data = m_gouv) %>%
        addProviderTiles("CartoDB.Positron") %>%
        setView(9.302178,34.387079, zoom = 6) %>%
        addPolygons(fillColor = ~pal(m_gouv@data$x),
                    fillOpacity = 0.8,
                    color = "#BDBDC3",
                    weight = 1,
                    popup = my_popup)%>%
        addLegend(pal = pal, values = ~Legend, opacity = 1)
      mm


    })

    output$text=renderText({
      paste("Distribution MAP of",input$var,"in Tunisia")
    })



  }

  # Run the application
  shinyApp(ui = ui, server = server)


}