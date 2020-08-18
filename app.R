#
# This is a Shiny web application for the COD-PS annual update workflow
# Written by Kathrin Weny in July 2020

# Load packages
library(shiny)
library(shinydashboard)
library(shinythemes)
library(DiagrammeR)
library(shinyWidgets)
library(shinythemes)
library(openxlsx)
library(readxl)
library(tidyverse)
library(googledrive)
library(shinyFiles)

# integrate the country list
country.list <- read.csv("countries.csv")
metadata <- read.csv("metadata.csv", check.names = FALSE)

# Define UI for application
ui <-  navbarPage(theme = shinytheme("flatly"),
                                   
                                  list(tags$head(
                                       
                                      tags$style(HTML( ".navbar .navbar-nav {float: left; 

                                          font-size: 32px; } 
                                      ")))),

                                    header = tagList(useShinydashboard()),
                                      
                                      tabPanel(
                                          "COD-PS Workstream management tool",
                                          h2(strong("What is this tool?")),
                                          fluidRow(
                                              column(12,
                                          box(width = 4,
                                              h4("This is a simple tool to support UNFPA CO/RO focal points to decide on which dataset to recommend as the best available Common Operational Dataset on Population Statistics (COD-PS).
                                                  It will guide them step-by-step through the various options in different data environments to facilitate the annual update of the COD-PS in their country."),
                                              h4("The tool contains:"),

                                              tags$ul(
                                                  tags$li(h4("A schematic overview of the COD-PS workstream and the steps of the annual COD-PS update (see figure 1 to the right)")),
                                                  tags$li(h4("An interactive step-by-step guide (see next section)")),
                                                  tags$li(h4("A mask to upload the data and the metadata to our database (at the end of the next section)"))),
                                              h4("Should you at any moment of this process have questions, please reach out to rosilva@unfpa.org and weny@unfpa.org.")
                                          ),
                                          
                                          box(width = 8, title = strong("Figure 1: COD-PS workflow: Overview of annual COD-PS update"), status = "primary", solidHeader = TRUE,
                                          grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, shape = rectangle]        
      tab1 [label = '@@1']
      tab2 [label = '@@2']
      tab3 [label = '@@3']
      tab4 [label = '@@4']
      tab5 [label = '@@5']
      tab6 [label = '@@6']
      tab7 [label = '@@7']
      tab8 [label = '@@8']
      tab9 [label = '@@9']
      tab10 [label = '@@10']

      
      # edge definitions with the node IDs
      tab1 -> tab2
      tab2 -> tab3
      tab2 -> tab4
      
      tab3 -> tab5 
      tab5 -> tab6
      tab5 -> tab7
      
      tab6 -> tab8
      
      tab8 -> tab9
      tab8 -> tab10     
      }

      [1]: 'Evaluation and quality assessment of existing COD-PS'
      [2]: 'Is the dataset sex AND age disaggregated? Is there sufficient geographic disaggregation? Is the data projected to the current year?'
      [3]: 'No'
      [4]: 'Yes: No update in 2020'
      [5]: 'Update the COD-PS: Are better projections publicly available or can they be provided on demand?'
      [6]: 'No'
      [7]: 'Yes: Update COD-PS'
      [11]: 'Can and should UNFPA model?'
      [12]: 'Yes: Update COD-PS'
      [13]: 'No: compare existing dataset to previous one and recommend best available'
      "))
                           
                                      )),
                                      
                                      h2(strong("Step-by-Step Guide")),
                                      

                                      fluidRow(
                                          column(12,
                                          box(width = 6, title = "1. Evaluation and quality assessment of existing COD-PS", status = "primary", solidHeader = TRUE, 
                                              
                                              p("Please verify the existence of a COD-PS", strong("Humanitarian Data Exchange (HDX)"), "and perform a quality assessment of any dataset that might be uploaded on HDX."),
                                              
                                              selectInput("country", 
                                                          label = h4(strong("To load the respective links on HDX below, choose your country:")),
                                                          choices = country.list$country,
                                                          selected = "Algeria"),
                                              "You can:", 
                                              tags$ul(
                                                  tags$li(a("Check how OCHA assesses the COD-PS availability for your country", href="https://data.humdata.org/dashboards/cod", target="_blank"), 
                                                           p("Note that this assessment does not always reflect the quality of the dataset, 
                                                             as OCHA assesses disaggregation, and availability of metadata, but not the projections reference year and other demographic quality characteristics.")),
                                              tags$li(uiOutput("url"), 
                                                      p("Is the dataset sex-and age-disaggregated? Does it contain sufficient geographic disaggregation? Is it projected to the current year?"))), 
                                              hr(),
                                              radioButtons("radio", h4(strong("Result:")),selected = character(0),
                                                           c("There are SAD projections to the current or past year on HDX." = "Stop", "No SAD projections to the current year are available on HDX." = "Next"
                                                           ))),
                                          
                                          box(width = 4, title = h4(strong(icon("question-circle"), "What is the Humanitarian Data Exchange (HDX)?")), status = "primary", 
                                              p("The Humanitarian Data Exchange (HDX), is a an open platform for sharing data across crises and organisations. HDX is managed by OCHA's Centre for Humanitarian Data, which is located in The Hague."),
                                              p("HDX contains a variety of datasets for humanitarian intervention, including publicly available Common Operational Datasets (COD)s. Therefore, advisable to verify which data is already available on HDX before continuing the process."),
                                              p("While it is a good first step to verify what datasets are on HDX, not all datasets have been necessarilty uploaded to HDX. In some contexts making datasets available to the broader public
                this might not be possible.")))),
                                    
                                    tabPanel("What is a COD-PS?"),
                                      
                                      uiOutput("ui"),
                                      
                                      fluidRow(column(12,
                                                      
                                                      uiOutput("ui2"))),
                                      
                                      fluidRow(column(12,
                                                      
                                                      uiOutput("ui3"))),
                                      
                                      fluidRow(column(12,
                                                      
                                                      uiOutput("ui4"))), 
                                    
                                      fluidRow(column(12,
                                                    
                                                      uiOutput("ui5")))
                              )#, 
                              
                            #  tabPanel("Background Info", h1(strong("What is a COD-PS?")),
                             #         tags$iframe(style="height:1500px; width:100%", 
                              #                    src="1-Draft-Technical-Guidance-Note-What-is-a-COD-PS_Draft.pdf")),

                            #  tabPanel("Other resources", h1(strong("Other useful resources")), 
                             #         h3("OCHA's information management toolbox, available", 
                                  #       a("here", href=("https://humanitarian.atlassian.net/wiki/spaces/imtoolbox/pages/42045911/COD+Overview"), target="_blank"), "."),
                                   #   h3("UNFPA's current scoping exercise, available", 
                                    #     a("here", href=("https://docs.google.com/spreadsheets/d/1eqPcf1o2-GtL5L9d8HDLzE_hHgd8t_MJq-YOTdc5Gi8/edit?ts=5ec52486&pli=1#gid=1349248252"), target="_blank"), ". Please feel free to suggest
                                     #    updates and amendments to weny@unfpa.org and rosilva@unfpa.org"),
                                #      h3("Draft communication in order to obtain draft COD-PS datasets is available", 
                                 #        a("here", href=("https://drive.google.com/drive/folders/10BXGiMKMMKyy0zAKArL6pg7FVaN7lYaU?usp=sharing"), target="_blank"), "."),
                                  #    h3("TD/PDB also maintains a database of subnational population projection, which is accessibile", 
                                   #      a("here", href=("https://drive.google.com/drive/folders/1VDVP2BJ2MnuHrWrK-bSX9NWtYxkqpEcc?usp=sharing"), target="_blank"), "."))
                              )

# Define server logic required to draw a histogram
server <- function(input, output) {

    observeEvent(input$country,{
        output$url <-renderUI(a(href=paste0('https://data.humdata.org/search?q=', input$country), target="_blank","Access the datasets for your country check OCHA's HDX database.",target="_blank"))
    })
    
    output$value <- renderPrint({input$radio})
    
    output$ui <- renderUI({
        if (is.null(input$radio))
            return()
        
        switch(input$radio,
               "Next" =  box(width = 10, title = "2. Update the COD-PS", status = "primary", solidHeader = TRUE,
                             p("As no sex-and age disaggregated (SAD) COD-PS projected to the current or last year is available, the data need to be updated. 
                               As a first step, publicly available projectons provided as official datasets by National Statistical Offices (NSO) have to be scoped. 
                               Verify online, or in your records, if the NSO or other relevant government counterparts have published official SAD population projections. 
                               Possibly reach out to the NSO if the information is not publicyly available online."),
                             radioButtons("radio2", selected = character(0),  h4(strong("Result:")),
                                          c("You were able to access updated SAD population projections at least at ADM1." = "Stop",
                                            "You were not able to access a relevant dataset." = "Next"))),
               "Stop" =  box(width = 6, h4(strong("Congratulations - No COD-PS update is necessary in 2020.")), status = "success", background = "green")
        )
    })
    
    output$value <- renderPrint({input$radio2})
    
    output$ui2 <- renderUI({
        if (is.null(input$radio2))
            return()
        # Depending on input$radio2, we'll generate a different
        # UI component and send it to the client.
        switch(input$radio2,
               "Next" =  box(width = 10, title = "3. Identify alternative datasets", status = "primary", solidHeader = TRUE,  
                             p("If no official SAD projections at ADM1 or lower are available, the nature of COD-PS allows for the scoping of altenrative datasets 
                             according to the 'best-available' 
                     data standard. In this case, an assessment of 'best available' datasets as well as possibly existing baseline data is necessary. 
                       The following points will support you in your decision making process:"),
                             tags$ul(
                                 tags$li("Verify if there are projections to the current (or last) year which are not SAD (they are only total population, only sex-disaggregated, etc.)."), 
                                 tags$li("Verify if there are population estimates available (e. g. from the latest census report), but no projections, or projections that are not up-to-date to the current (or last) year."), 
                                 tags$li("Verify if there are population estimates available, but they are not geographically disaggregated.")
                             ),
                             radioButtons("radio3", selected = character(0),  h4(strong("Result:")),
                                          c("There are population estimates and/or projection but they are either not SAD, not geographically disaggregated, or not projected to the current year" = "Next",
                                            "You were not able to access a relevant dataset" = "Stop"))),
               "Stop" =  fluidRow(
                         box(width = 10, title = "3. Fill in the metadatafile", status = "primary", solidHeader = TRUE, 
                             h4(strong("General")),
                             textInput("baselinepop", "Baseline Population", "Enter the baseline population data source for the projections, e. g. 2010 census"),
                             numericInput("year", "Reference year", 2020),
                             textInput("sources", "Source(s)", "Enter the sources of the projection, e. g. INS Burkina Faso"),
                             textInput("methods", "Methods", "Enter a short description of the methods, e. g. cohort-component"),
                             numericInput("yearpub", "Year of publication", 2019),
                             
                             h4(strong("Administrative level 1")),
                             textInput("nameadm1", "Name of ADM1", "Enter the name of the ADM1 here, e. g. departments"),
                             numericInput("numadm1", "Number of ADM1 units", 12),
                             textInput("sadadm1", "Age- and sex disaggregation at ADM1", "Is the dataset SAD at ADM1?"),
                             textInput("ageadm1", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                             
                             h4(strong("Administrative level 2 (if applicable)")),
                             textInput("nameadm2", "Name of ADM2", "Enter the name of the ADM2 here, e. g. districts"),
                             numericInput("numadm2", "Number of ADM2 units", 65),
                             textInput("sadadm2", "Age- and sex disaggregation at ADM2", "Is the dataset SAD at ADM2?"),
                             textInput("ageadm2", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),

                             h4(strong("Administrative level 3 (if applicable)")),
                             textInput("nameadm3", "Name of ADM3", "Enter the name of the ADM3 here, e. g. districts"),
                             numericInput("numadm3", "Number of ADM3 units", 65),
                             textInput("sadadm3", "Age- and sex disaggregation at ADM3", "Is the dataset SAD at ADM3?"),
                             textInput("ageadm3", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),

                             h4(strong("Administrative level 4 (if applicable)")),
                             textInput("nameadm4", "Name of ADM4", "Enter the name of the ADM4 here, e. g. districts"),
                             numericInput("numadm4", "Number of ADM4 units", 65),
                             textInput("sadadm4", "Age- and sex disaggregation at ADM4", "Is the dataset SAD at ADM4?"),
                             textInput("ageadm4", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                             
                             textInput("notes", "Are there and restrictions using the dataset?", "Enter restrictions"),
                             
                             downloadButton('save_metadata', "Download and inspect the metadata")
                             ),
                         
                         box(width = 10, title = "4. Upload COD-PS file to UNFPA's database", status = "primary", 
                             solidHeader = TRUE,
                             p("Once you are satisfied with your metadata, and have your draft COD-PS ready, upload the two files below:"),
                             
                             fileInput(inputId = "file1", 
                                       label = "Upload the metadatafile",
                                       accept = NULL),
                         
                             fileInput(inputId = "file2", 
                                       label = "Upload the draft COD-PS",
                                       accept = NULL),
                             
                             fileInput(inputId = "file3", 
                                       label = "Upload any additional documents (methodological reports, etc.)",
                                       accept = NULL)),
                         
                         box(width = 10, title = "5. Communicate and share the dataset", status = "primary", solidHeader = TRUE,
                             h4("National Statistical Office"),
                             p("We recommend informing the NSO that their dataset will be recommended as COD-PS for your country."),
                             h4("OCHA and the UNCT/HCT"),
                             p("In order to propse this dataset as updated COD-PS, suggest it to the relevant Information Management Working Group. 
                             If there is no national OCHA presence, CODs are discussed in the regional Information Management Working Group. 
                               You can check OCHA's regional presence on this", a(strong("map"),
                               href="https://www.unocha.org/where-we-work/ocha-presence", target="_blank"), "."),
                             p("Currently, the focal points for the regional IMWGs are:"),
                             tags$ul(
                                 tags$li(p("ROLAC (Panama) - Brenda Eriksen (eriksenb@un.org)")),
                                 tags$li(p("ROAP (Bangkok)  - Johan Marinos (marinosj@un.org)")),
                                 tags$li(p("ROP (Fiji)  - Rashmi Rita (rita@un.org)")),
                                 tags$li(p("ROMENA (Cairo) - Fuad Hudali (hudalif@un.org)", strong("[note that Iran is part of ROMENA]"))),
                                 tags$li(p("ROWCA (Dakar) - Robert Colombo (colombor@un.org)", strong("[note that DRC is part of ROWCA]"))),
                                 tags$li(p("ROSEA (Nairobi) - Sanjay Rane (ranes@un.org)", strong("[note that Sudan and Somalia are part of ROSEA]")))),
                             h4("Focal points at HQ"),
                             p("Kindly copy Romesh Silva (rosilva@unfpa.org) and Kathrin Weny (weny@unfpa.org), in your communication with OCHA, for our records."))
        ))
    })
    

    output$save_metadata <- downloadHandler(
      filename = function() {
        paste0(input$country, Sys.Date(), "_metadata.xlsx")
      },
      content = function(file) {
        
        data <- metadata  %>%
          mutate(user.input = NA)
        
        data[1,2] <- input$country
        data[2,2] <- input$baselinepop
        data[3,2] <- input$year
        data[4,2] <- input$sources
        data[5,2] <- input$methods
        data[6,2] <- input$yearpub
        data[7,2] <- input$nameadm1
        data[8,2] <- input$numadm1
        data[9,2] <- input$sadadm1
        data[10,2] <- input$ageadm1
        
        data[11,2] <- input$nameadm2
        data[12,2] <- input$numadm2
        data[13,2] <- input$sadadm2
        data[14,2] <- input$ageadm2
        
        data[15,2] <- input$nameadm3
        data[16,2] <- input$numadm3
        data[17,2] <- input$sadadm3
        data[18,2] <- input$ageadm3
        
        data[19,2] <- input$nameadm4
        data[20,2] <- input$numadm4
        data[21,2] <- input$sadadm4
        data[22,2] <- input$ageadm4
        
        data[23,2] <- input$notes
        
        write.xlsx(data, file, row.names = FALSE)
      }
    )
    

observeEvent(input$file1, {
      drive_upload(media = input$file1$datapath,
                   name = input$file1$name,
                   path = "https:/drive.google.com/drive/folders/1pgWzr3B4_Xfa5ULSsYmlHAWn2RS1Cs5w?usp=sharing")
    })

        
observeEvent(input$file2, {
      drive_upload(media = input$file2$datapath,
                   name = input$file2$name,
                   path = "https:/drive.google.com/drive/folders/1pgWzr3B4_Xfa5ULSsYmlHAWn2RS1Cs5w?usp=sharing")
    })
  
    
    observeEvent(input$file3, {
      drive_upload(media = input$file3$datapath,
                   name = input$file3$name,
                   path = "https:/drive.google.com/drive/folders/1pgWzr3B4_Xfa5ULSsYmlHAWn2RS1Cs5w?usp=sharing")
    })


    output$ui3 <- renderUI({
        if (is.null(input$radio3))
            return()
        switch(input$radio3,
               "Next" =  box(width = 10, title = "4. Decide whether additional modelling is an option", status = "primary", solidHeader = TRUE,  
                             p("The dataset at hand does not comply with COD-PS characteristics, either because it is not SAD, not projected to the current or last year, or does not contain sufficient geographic disaggregation. 
                               The following points might help you decide, whether additional modelling is an option for your country"),
                             tags$ul(
                                 tags$li("Verify if you have access to census/household survey/vital statistics data by age and sex, or even as micro data sample."), 
                                 tags$li("Verify if an alternative and modelled population dataset can be recommended by UNFPA as COD-PS without jeopardizing its relationship to the NSO.")
                             ),
                             radioButtons("radio4", selected = character(0),  h4(strong("Result:")),
                                          c("There are no census data or household surveys." = "Stop",
                                            "While there are census or hosuehold data, the UNFPA CO politically cannot suggest alternative population projections 
                                            and recommends to provide the official dataset, despite not fully complying with COD-PS characteristics." = "Stop2",
                                            "Data availability and the UNFPA CO's relationship with the NSO allow additional modelling." = "Next"))),
               "Stop" =  fluidRow(box(width = 6, title = "4. Decide whether modelled population estimates and projection are an option", status = "primary", solidHeader = TRUE,  
                                      "As there is no baseline dataset, population modelling might be an option. In order to decide your next steps, we recommend the following:",
                                      tags$ul(
                                          tags$li("Verify if your country is part of the GRID3 project."), 
                                          tags$li("Verify if ADM0 (national level) population estimates and projections are an option. Then consider the World Population Prospects by the United Nations Population Division."), 
                                          tags$li("Verify if WorldPop estimates are an option.")
                                      )),
                                  box(width = 4, title = h4(strong(icon("question-circle"),"Why the WPP? A note on small island states and countries")), status = "primary", 
                                      "In some cases, no subnational projection are available for 
                                 'small' countries and island states. In these exceptional cases, it can be justified to accept national level projections. In these cases and where the 
                                 population size exceeds 100,000, the World Population Prospects by the United Nations Population Division can be an option."))
        ) }) 
    
    
    output$ui4 <- renderUI({
        if (is.null(input$radio4))
            return()

        switch(input$radio4,
               "Next" =  fluidRow(box(width = 10, title = "5. Model population data to obtain COD-PS", status = "primary", solidHeader = TRUE, 
                                      p("Model the dataset to obtain an updated, SAD COD-PS at atleast ADM1. If you would like to obtain technical support from TD/PDB reach out to rosilva@unfpa.org and
                               weny@unfpa.org.")),
                                  
                                    box(width = 10, title = "6. Fill in the metadatafile", status = "primary", solidHeader = TRUE, 
                                        h4(strong("General")),
                                        textInput("baselinepop", "Baseline Population", "Enter the baseline population data source for the projections, e. g. 2010 census"),
                                        numericInput("year", "Reference year", 2020),
                                        textInput("sources", "Source(s)", "Enter the sources of the projection, e. g. INS Burkina Faso"),
                                        textInput("methods", "Methods", "Enter a short description of the methods, e. g. cohort-component"),
                                        numericInput("yearpub", "Year of publication", 2019),
                                        
                                        h4(strong("Administrative level 1")),
                                        textInput("nameadm1", "Name of ADM1", "Enter the name of the ADM1 here, e. g. departments"),
                                        numericInput("numadm1", "Number of ADM1 units", 12),
                                        textInput("sadadm1", "Age- and sex disaggregation at ADM1", "Is the dataset SAD at ADM1?"),
                                        textInput("ageadm1", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                                        
                                        h4(strong("Administrative level 2 (if applicable)")),
                                        textInput("nameadm2", "Name of ADM2", "Enter the name of the ADM2 here, e. g. districts"),
                                        numericInput("numadm2", "Number of ADM2 units", 65),
                                        textInput("sadadm2", "Age- and sex disaggregation at ADM2", "Is the dataset SAD at ADM2?"),
                                        textInput("ageadm2", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                                        
                                        h4(strong("Administrative level 3 (if applicable)")),
                                        textInput("nameadm3", "Name of ADM3", "Enter the name of the ADM3 here, e. g. districts"),
                                        numericInput("numadm3", "Number of ADM3 units", 65),
                                        textInput("sadadm3", "Age- and sex disaggregation at ADM3", "Is the dataset SAD at ADM3?"),
                                        textInput("ageadm3", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                                        
                                        h4(strong("Administrative level 4 (if applicable)")),
                                        textInput("nameadm4", "Name of ADM4", "Enter the name of the ADM4 here, e. g. districts"),
                                        numericInput("numadm4", "Number of ADM4 units", 65),
                                        textInput("sadadm4", "Age- and sex disaggregation at ADM4", "Is the dataset SAD at ADM4?"),
                                        textInput("ageadm4", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                                        
                                        textInput("notes", "Are there and restrictions using the dataset?", "Enter restrictions"),
                                        
                                        downloadButton('save_metadata', "Download and inspect the metadata")),
                                    
                                    box(width = 10, title = "7. Upload COD-PS file to UNFPA's database", status = "primary", 
                                        solidHeader = TRUE,
                                        p("Once you are satisfied with your metadata, and have your draft COD-PS ready, upload the two files below:"),
                                        
                                        fileInput(inputId = "file1", 
                                                  label = "Upload the metadatafile",
                                                  accept = NULL),
                                        
                                        fileInput(inputId = "file2", 
                                                  label = "Upload the draft COD-PS",
                                                  accept = NULL),
                                        
                                        fileInput(inputId = "file3", 
                                                  label = "Upload any additional documents (methodological reports, etc.)",
                                                  accept = NULL)),
                                    
                                    box(width = 10, title = "8. Communicate and share the dataset", status = "primary", solidHeader = TRUE,
                                        h4("National Statistical Office"),
                                        p("We recommend informing the NSO that their dataset will be recommended as COD-PS for your country."),
                                        h4("OCHA and the UNCT/HCT"),
                                        p("In order to propse this dataset as updated COD-PS, suggest it to the relevant Information Management Working Group. 
                                           If there is no national OCHA presence, CODs are discussed in the regional Information Management Working Group. 
                                           You can check OCHA's regional presence on this", a(strong("map"), href="https://www.unocha.org/where-we-work/ocha-presence", target="_blank"), "."),
                                        
                                        p("Currently, the focal points for the regional IMWGs are:"),
                                        
                                        tags$ul(
                                          tags$li(p("ROLAC (Panama) - Brenda Eriksen (eriksenb@un.org)")),
                                          tags$li(p("ROAP (Bangkok)  - Johan Marinos (marinosj@un.org)")),
                                          tags$li(p("ROP (Fiji)  - Rashmi Rita (rita@un.org)")),
                                          tags$li(p("ROMENA (Cairo) - Fuad Hudali (hudalif@un.org)", strong("[note that Iran is part of ROMENA]"))),
                                          tags$li(p("ROWCA (Dakar) - Robert Colombo (colombor@un.org)", strong("[note that DRC is part of ROWCA]"))),
                                          tags$li(p("ROSEA (Nairobi) - Sanjay Rane (ranes@un.org)", strong("[note that Sudan and Somalia are part of ROSEA]")))),
                                        h4("Focal points at HQ"),
                                        p("Kindly copy Romesh Silva (rosilva@unfpa.org) and Kathrin Weny (weny@unfpa.org), in your communication with OCHA, for our records."))
                                  ),
               
               "Stop" =   fluidRow(box(width = 10, title = "5. Identify the best available dataset and if applicable update the COD-PS", status = "primary", solidHeader = TRUE,  
                             p("The dataset at hand does not fully comply with COD-PS standards. However it might be better than the currently uploaded COD-PS. 
                             Based on your evaluation in step 1, identify the best available dataset."),
                             radioButtons("radio5", selected = character(0),  h4(strong("Result:")),
                             c("The dataset available to the UNFPA CO is preferrable to the existing COD-PS or there is currently no COD-PS at all." = "Next",
                              "The currently available COD-PS is preferable." = "Stop")))),
      
               
               "Stop2" =   fluidRow(box(width = 10, title = "5. Identify the best available dataset and if applicable update the COD-PS", status = "primary", solidHeader = TRUE,  
                              ("The dataset at hand does not fully comply with COD-PS standards. However it might be better than the currently uploaded COD-PS. 
                              Based on your evaluation in step 1, identify the best available dataset."),
                              radioButtons("radio5", selected = character(0),  h4(strong("Result:")),
                              c("The dataset available to the UNFPA CO is preferrable to the existing COD-PS or there is currently no COD-PS at all." = "Next",
                              "The currently available COD-PS is preferable." = "Stop")))))
    })
    
    output$ui5 <- renderUI({
      if (is.null(input$radio5))
        return()
      
      switch(input$radio5,
             "Next" =  fluidRow(box(width = 10, title = "6. Fill in the metadatafile", status = "primary", solidHeader = TRUE, 
                           h4(strong("General")),
                           textInput("baselinepop", "Baseline Population", "Enter the baseline population data source for the projections, e. g. 2010 census"),
                           numericInput("year", "Reference year", 2020),
                           textInput("sources", "Source(s)", "Enter the sources of the projection, e. g. INS Burkina Faso"),
                           textInput("methods", "Methods", "Enter a short description of the methods, e. g. cohort-component"),
                           numericInput("yearpub", "Year of publication", 2019),
                           
                           h4(strong("Administrative level 1")),
                           textInput("nameadm1", "Name of ADM1", "Enter the name of the ADM1 here, e. g. departments"),
                           numericInput("numadm1", "Number of ADM1 units", 12),
                           textInput("sadadm1", "Age- and sex disaggregation at ADM1", "Is the dataset SAD at ADM1?"),
                           textInput("ageadm1", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                           
                           h4(strong("Administrative level 2 (if applicable)")),
                           textInput("nameadm2", "Name of ADM2", "Enter the name of the ADM2 here, e. g. districts"),
                           numericInput("numadm2", "Number of ADM2 units", 65),
                           textInput("sadadm2", "Age- and sex disaggregation at ADM2", "Is the dataset SAD at ADM2?"),
                           textInput("ageadm2", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                           
                           h4(strong("Administrative level 3 (if applicable)")),
                           textInput("nameadm3", "Name of ADM3", "Enter the name of the ADM3 here, e. g. districts"),
                           numericInput("numadm3", "Number of ADM3 units", 65),
                           textInput("sadadm3", "Age- and sex disaggregation at ADM3", "Is the dataset SAD at ADM3?"),
                           textInput("ageadm3", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                           
                           h4(strong("Administrative level 4 (if applicable)")),
                           textInput("nameadm4", "Name of ADM4", "Enter the name of the ADM4 here, e. g. districts"),
                           numericInput("numadm4", "Number of ADM4 units", 65),
                           textInput("sadadm4", "Age- and sex disaggregation at ADM4", "Is the dataset SAD at ADM4?"),
                           textInput("ageadm4", "Open-ended group", "Enter highest open-ended age group, e. g. 80+"),
                           
                           textInput("notes", "Are there and restrictions using the dataset?", "Enter restrictions"),
                           
                           downloadButton('save_metadata', "Download and inspect the metadata")),
             
             box(width = 10, title = "7. Upload COD-PS file to UNFPA's database", status = "primary", 
                 solidHeader = TRUE,
                 p("Once you are satisfied with your metadata, and have your draft COD-PS ready, upload the two files below:"),
                 
                 fileInput(inputId = "file1", 
                           label = "Upload the metadatafile",
                           accept = NULL),
                 
                 fileInput(inputId = "file2", 
                           label = "Upload the draft COD-PS",
                           accept = NULL),

                 fileInput(inputId = "file3", 
                           label = "Upload any additional documents (methodological reports, etc.)",
                           accept = NULL)),
             
             box(width = 10, title = "8. Communicate and share the dataset", status = "primary", solidHeader = TRUE,
                 h4("National Statistical Office"),
                 p("We recommend informing the NSO that their dataset will be recommended as COD-PS for your country."),
                 h4("OCHA and the UNCT/HCT"),
                 p("In order to propse this dataset as updated COD-PS, suggest it to the relevant Information Management Working Group. 
                                           If there is no national OCHA presence, CODs are discussed in the regional Information Management Working Group. 
                                           You can check OCHA's regional presence on this", a(strong("map"), href="https://www.unocha.org/where-we-work/ocha-presence", target="_blank"), "."),
                 
                 p("Currently, the focal points for the regional IMWGs are:"),
                 
                 tags$ul(
                   tags$li(p("ROLAC (Panama) - Brenda Eriksen (eriksenb@un.org)")),
                   tags$li(p("ROAP (Bangkok)  - Johan Marinos (marinosj@un.org)")),
                   tags$li(p("ROP (Fiji)  - Rashmi Rita (rita@un.org)")),
                   tags$li(p("ROMENA (Cairo) - Fuad Hudali (hudalif@un.org)", strong("[note that Iran is part of ROMENA]"))),
                   tags$li(p("ROWCA (Dakar) - Robert Colombo (colombor@un.org)", strong("[note that DRC is part of ROWCA]"))),
                   tags$li(p("ROSEA (Nairobi) - Sanjay Rane (ranes@un.org)", strong("[note that Sudan and Somalia are part of ROSEA]")))),
                 h4("Focal points at HQ"),
                 p("Kindly copy Romesh Silva (rosilva@unfpa.org) and Kathrin Weny (weny@unfpa.org), in your communication with OCHA, for our records."))),
             
             "Stop" =  box(width = 6, h4(strong("No COD-PS update is necessary in 2020.")), status = "primary", background = "blue"),
             "Stop2" =  box(width = 6, h4(strong("No COD-PS update is necessary in 2020.")), status = "primary", background = "blue")
      )
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
