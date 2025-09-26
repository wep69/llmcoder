#' LLM Settings UI
#'
#' Configuration interface for API keys and preferences

#' LLM Settings Addin
#'
#' Opens an interactive configuration interface to manage API keys and preferences
#' for various LLM providers including OpenAI, Gemini, Qwen, and OpenRouter.
#'
#' @return No return value, called for side effects (opens settings UI)
#' @export
#' @examples
#' \dontrun{
#'   # Open the settings interface
#'   llm_settings()
#' }
llm_settings <- function() {
  config <- load_config()
  prefs <- get_user_prefs()

  # Create the UI
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("LLM Coder Settings", right = miniUI::miniTitleBarButton("done", "Save", primary = TRUE)),
    miniUI::miniContentPanel(
      shiny::fillPage(
        shiny::tags$style(HTML("
          .container-fluid { padding: 20px; }
          .nav-pills > li > a { color: #495057; }
          .nav-pills > li.active > a { background-color: #007bff; }
          .tab-content { margin-top: 20px; }
          .provider-section {
            background: #f8f9fa;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            border-left: 4px solid #007bff;
          }
          .status-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
          }
          .status-valid { background-color: #d4edda; color: #155724; }
          .status-invalid { background-color: #f8d7da; color: #721c24; }
        ")),

        shiny::fluidPage(
          shiny::tabsetPanel(
            id = "settings_tabs",

            # API Keys Tab
            shiny::tabPanel("API Keys",
              shiny::br(),
              shiny::h4("Configure API Keys"),
              shiny::p("Enter your API keys for the LLM providers you want to use:"),

              # OpenAI
              shiny::div(class = "provider-section",
                shiny::fluidRow(
                  shiny::column(8,
                    shiny::h5("OpenAI", shiny::uiOutput("openai_status"))
                  ),
                  shiny::column(4,
                    shiny::actionButton("test_openai", "Test Connection", class = "btn-sm")
                  )
                ),
                shiny::passwordInput("openai_key", "API Key:",
                  value = ifelse(is.null(prefs$api_keys$openai), "", "••••••••••••••••"),
                  placeholder = "sk-..."
                ),
                shiny::p(shiny::tags$small("Get your API key from: ",
                  shiny::a("OpenAI Platform", href = "https://platform.openai.com/api-keys", target = "_blank")
                ))
              ),

              # Gemini
              shiny::div(class = "provider-section",
                shiny::fluidRow(
                  shiny::column(8,
                    shiny::h5("Google Gemini", shiny::uiOutput("gemini_status"))
                  ),
                  shiny::column(4,
                    shiny::actionButton("test_gemini", "Test Connection", class = "btn-sm")
                  )
                ),
                shiny::passwordInput("gemini_key", "API Key:",
                  value = ifelse(is.null(prefs$api_keys$gemini), "", "••••••••••••••••"),
                  placeholder = "AIza..."
                ),
                shiny::p(shiny::tags$small("Get your API key from: ",
                  shiny::a("Google AI Studio", href = "https://aistudio.google.com/app/apikey", target = "_blank")
                ))
              ),

              # Qwen
              shiny::div(class = "provider-section",
                shiny::fluidRow(
                  shiny::column(8,
                    shiny::h5("Alibaba Qwen", shiny::uiOutput("qwen_status"))
                  ),
                  shiny::column(4,
                    shiny::actionButton("test_qwen", "Test Connection", class = "btn-sm")
                  )
                ),
                shiny::passwordInput("qwen_key", "API Key:",
                  value = ifelse(is.null(prefs$api_keys$qwen), "", "••••••••••••••••"),
                  placeholder = "sk-..."
                ),
                shiny::p(shiny::tags$small("Get your API key from: ",
                  shiny::a("Alibaba Cloud DashScope", href = "https://dashscope.console.aliyun.com/", target = "_blank")
                ))
              ),

              # OpenRouter
              shiny::div(class = "provider-section",
                shiny::fluidRow(
                  shiny::column(8,
                    shiny::h5("OpenRouter", shiny::uiOutput("openrouter_status"))
                  ),
                  shiny::column(4,
                    shiny::actionButton("test_openrouter", "Test Connection", class = "btn-sm")
                  )
                ),
                shiny::passwordInput("openrouter_key", "API Key:",
                  value = ifelse(is.null(prefs$api_keys$openrouter), "", "••••••••••••••••"),
                  placeholder = "sk-or-..."
                ),
                shiny::p(shiny::tags$small("Get your API key from: ",
                  shiny::a("OpenRouter Keys", href = "https://openrouter.ai/keys", target = "_blank")
                ))
              )
            ),

            # Preferences Tab
            shiny::tabPanel("Preferences",
              shiny::br(),
              shiny::h4("Default Settings"),

              shiny::fluidRow(
                shiny::column(6,
                  shiny::selectInput("default_provider", "Default Provider:",
                    choices = c("OpenAI" = "openai", "Gemini" = "gemini",
                               "Qwen" = "qwen", "OpenRouter" = "openrouter"),
                    selected = prefs$default_provider
                  )
                ),
                shiny::column(6,
                  shiny::checkboxInput("auto_insert", "Auto-insert generated code",
                    value = prefs$auto_insert
                  )
                )
              ),

              shiny::fluidRow(
                shiny::column(6,
                  shiny::numericInput("default_temperature", "Default Temperature:",
                    value = prefs$default_temperature, min = 0, max = 2, step = 0.1
                  )
                ),
                shiny::column(6,
                  shiny::numericInput("default_max_tokens", "Default Max Tokens:",
                    value = prefs$default_max_tokens, min = 100, max = 4000, step = 100
                  )
                )
              ),

              shiny::br(),
              shiny::h5("Environment Variables"),
              shiny::p("You can also set API keys using environment variables:"),
              shiny::tags$ul(
                shiny::tags$li(shiny::code("OPENAI_API_KEY")),
                shiny::tags$li(shiny::code("GEMINI_API_KEY")),
                shiny::tags$li(shiny::code("QWEN_API_KEY")),
                shiny::tags$li(shiny::code("OPENROUTER_API_KEY"))
              )
            ),

            # Custom Models Tab
            shiny::tabPanel("Custom Models",
              shiny::br(),
              shiny::h4("Manage Custom Models"),
              shiny::p("Add custom models for each provider or import popular models."),

              # Quick Actions
              shiny::fluidRow(
                shiny::column(4,
                  shiny::actionButton("import_openrouter", "Import OpenRouter Models",
                                    class = "btn-success", icon = shiny::icon("download"))
                ),
                shiny::column(4,
                  shiny::actionButton("create_template", "Create Template File",
                                    class = "btn-info", icon = shiny::icon("file"))
                ),
                shiny::column(4,
                  shiny::actionButton("refresh_models", "Refresh List",
                                    class = "btn-secondary", icon = shiny::icon("refresh"))
                )
              ),

              shiny::hr(),

              # Add New Model Form
              shiny::fluidRow(
                shiny::column(12,
                  shiny::h5("Add New Custom Model"),
                  shiny::wellPanel(
                    shiny::fluidRow(
                      shiny::column(3,
                        shiny::selectInput("new_model_provider", "Provider:",
                          choices = c("OpenAI" = "openai", "Gemini" = "gemini",
                                     "Qwen" = "qwen", "OpenRouter" = "openrouter"))
                      ),
                      shiny::column(3,
                        shiny::textInput("new_model_id", "Model ID:",
                          placeholder = "e.g., gpt-4o-2024-11-20")
                      ),
                      shiny::column(4,
                        shiny::textInput("new_model_display", "Display Name:",
                          placeholder = "e.g., GPT-4o November 2024")
                      ),
                      shiny::column(2,
                        shiny::br(),
                        shiny::actionButton("add_model", "Add", class = "btn-primary",
                                          icon = shiny::icon("plus"))
                      )
                    ),
                    shiny::fluidRow(
                      shiny::column(12,
                        shiny::textInput("new_model_desc", "Description (optional):",
                          placeholder = "Brief description of the model...")
                      )
                    )
                  )
                )
              ),

              # Current Custom Models List
              shiny::fluidRow(
                shiny::column(12,
                  shiny::h5("Current Custom Models"),
                  DT::dataTableOutput("custom_models_table")
                )
              ),

              shiny::br(),

              # Instructions
              shiny::div(
                class = "alert alert-info",
                shiny::h6("💡 Tips:"),
                shiny::tags$ul(
                  shiny::tags$li("Use exact model IDs as specified by the provider"),
                  shiny::tags$li("For OpenRouter, use format: provider/model-name"),
                  shiny::tags$li("Custom models are stored in ~/.llmcoder_custom_models.yml"),
                  shiny::tags$li("You can edit the YAML file manually for bulk changes")
                )
              )
            ),

            # About Tab
            shiny::tabPanel("About",
              shiny::br(),
              shiny::h4("LLM Coder for RStudio"),
              shiny::p("Version 0.1.0"),
              shiny::br(),
              shiny::h5("Features:"),
              shiny::tags$ul(
                shiny::tags$li("Generate R code from natural language descriptions"),
                shiny::tags$li("Fix and improve existing R code"),
                shiny::tags$li("Get explanations of R code functionality"),
                shiny::tags$li("Support for multiple LLM providers")
              ),
              shiny::br(),
              shiny::h5("Supported Providers:"),
              shiny::tags$ul(
                shiny::tags$li("OpenAI (GPT-4, GPT-3.5-turbo)"),
                shiny::tags$li("Google Gemini (Gemini 1.5 Pro, Flash)"),
                shiny::tags$li("Alibaba Qwen (Qwen-plus, Qwen-turbo)"),
                shiny::tags$li("OpenRouter (Access to 300+ models)")
              )
            )
          )
        )
      )
    )
  )

  # Create the server
  server <- function(input, output, session) {
    # Initialize status indicators
    update_status_indicators <- function() {
      providers <- c("openai", "gemini", "qwen", "openrouter")
      for (provider in providers) {
        availability <- check_provider_availability(provider)
        status_class <- if (availability$available) "status-valid" else "status-invalid"
        status_text <- if (availability$available) "✓ Valid" else "✗ Invalid"

        output[[paste0(provider, "_status")]] <- shiny::renderUI({
          shiny::tags$span(status_text, class = paste("status-badge", status_class))
        })
      }
    }

    # Update status indicators on load
    shiny::observe({
      update_status_indicators()
    })

    # Test connection buttons
    test_provider <- function(provider, key_input) {
      if (nchar(input[[key_input]]) == 0) {
        shiny::showNotification("Please enter an API key first", type = "warning")
        return()
      }

      api_key <- if (input[[key_input]] == "••••••••••••••••") {
        get_api_key(provider)
      } else {
        input[[key_input]]
      }

      validation <- validate_api_key(provider, api_key, config)
      if (validation$valid) {
        shiny::showNotification(paste("✓", provider, "connection successful!"), type = "message")
      } else {
        shiny::showNotification(paste("✗", validation$message), type = "error")
      }
    }

    shiny::observeEvent(input$test_openai, { test_provider("openai", "openai_key") })
    shiny::observeEvent(input$test_gemini, { test_provider("gemini", "gemini_key") })
    shiny::observeEvent(input$test_qwen, { test_provider("qwen", "qwen_key") })
    shiny::observeEvent(input$test_openrouter, { test_provider("openrouter", "openrouter_key") })

    # Custom Models Management
    custom_models_data <- shiny::reactive({
      input$refresh_models # Dependency for refresh
      tryCatch({
        list_custom_models()
      }, error = function(e) {
        data.frame(
          provider = character(0),
          model_id = character(0),
          display_name = character(0),
          description = character(0),
          added_date = character(0)
        )
      })
    })

    output$custom_models_table <- DT::renderDataTable({
      df <- custom_models_data()
      if (nrow(df) == 0) {
        return(data.frame("No custom models configured" = ""))
      }

      # Add action buttons for each row
      df$Actions <- paste0(
        '<button class="btn btn-danger btn-xs" onclick="Shiny.setInputValue(\'delete_model\', \'',
        df$provider, '|', df$model_id, '\', {priority: \'event\'})">',
        '<i class="fa fa-trash"></i> Delete</button>'
      )

      df
    }, escape = FALSE, options = list(
      pageLength = 10,
      searching = TRUE,
      ordering = TRUE
    ))

    # Add new custom model
    shiny::observeEvent(input$add_model, {
      if (nchar(input$new_model_id) == 0) {
        shiny::showNotification("Model ID is required", type = "error")
        return()
      }

      tryCatch({
        add_custom_model(
          provider = input$new_model_provider,
          model_id = input$new_model_id,
          display_name = if(nchar(input$new_model_display) > 0) input$new_model_display else NULL,
          description = if(nchar(input$new_model_desc) > 0) input$new_model_desc else NULL
        )

        # Clear form
        shiny::updateTextInput(session, "new_model_id", value = "")
        shiny::updateTextInput(session, "new_model_display", value = "")
        shiny::updateTextInput(session, "new_model_desc", value = "")

        # Refresh table
        shiny::updateActionButton(session, "refresh_models")

        shiny::showNotification("Custom model added successfully!", type = "message")
      }, error = function(e) {
        shiny::showNotification(paste("Error adding model:", e$message), type = "error")
      })
    })

    # Delete custom model
    shiny::observeEvent(input$delete_model, {
      if (is.null(input$delete_model) || input$delete_model == "") return()

      parts <- strsplit(input$delete_model, "\\|")[[1]]
      if (length(parts) != 2) return()

      provider <- parts[1]
      model_id <- parts[2]

      tryCatch({
        remove_custom_model(provider, model_id)
        shiny::updateActionButton(session, "refresh_models")
        shiny::showNotification("Model removed successfully!", type = "message")
      }, error = function(e) {
        shiny::showNotification(paste("Error removing model:", e$message), type = "error")
      })
    })

    # Import OpenRouter models
    shiny::observeEvent(input$import_openrouter, {
      shiny::showModal(shiny::modalDialog(
        title = "Import OpenRouter Models",
        "This will add 20 popular OpenRouter models to your custom models list.",
        shiny::br(), shiny::br(),
        "Continue?",
        footer = shiny::tagList(
          shiny::modalButton("Cancel"),
          shiny::actionButton("confirm_import", "Import", class = "btn-primary")
        )
      ))
    })

    shiny::observeEvent(input$confirm_import, {
      shiny::removeModal()

      tryCatch({
        count <- import_openrouter_models(limit = 20)
        shiny::updateActionButton(session, "refresh_models")
        shiny::showNotification(
          paste("Successfully imported", count, "OpenRouter models!"),
          type = "message"
        )
      }, error = function(e) {
        shiny::showNotification(paste("Error importing models:", e$message), type = "error")
      })
    })

    # Create template file
    shiny::observeEvent(input$create_template, {
      tryCatch({
        create_custom_models_template()
        shiny::updateActionButton(session, "refresh_models")
        shiny::showNotification("Template file created successfully!", type = "message")
      }, error = function(e) {
        shiny::showNotification(paste("Error creating template:", e$message), type = "error")
      })
    })

    # Refresh models list
    shiny::observeEvent(input$refresh_models, {
      # This will trigger the reactive and refresh the table
      shiny::showNotification("Models list refreshed", type = "message", duration = 2)
    })

    # Save settings
    shiny::observeEvent(input$done, {
      # Save API keys
      providers <- c("openai", "gemini", "qwen", "openrouter")
      for (provider in providers) {
        key_input <- paste0(provider, "_key")
        if (nchar(input[[key_input]]) > 0 && input[[key_input]] != "••••••••••••••••") {
          save_api_key(provider, input[[key_input]])
        }
      }

      # Save preferences
      new_prefs <- list(
        api_keys = prefs$api_keys,  # Keep existing keys
        default_provider = input$default_provider,
        default_temperature = input$default_temperature,
        default_max_tokens = input$default_max_tokens,
        auto_insert = input$auto_insert
      )
      save_user_prefs(new_prefs)

      shiny::showNotification("Settings saved successfully!", type = "message")
      shiny::stopApp()
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }

  # Run the gadget
  viewer <- shiny::dialogViewer("LLM Coder Settings", width = 900, height = 700)
  shiny::runGadget(ui, server, viewer = viewer)
}
