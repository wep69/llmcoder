#' LLM Code Generator Addin
#'
#' Main addin functions for RStudio integration

#' Generate Code with LLM
#'
#' Opens an interactive dialog to generate R code using various LLM providers.
#' The generated code can be inserted directly into the active RStudio document.
#'
#' @return No return value, called for side effects (opens interactive UI)
#' @export
#' @examples
#' \dontrun{
#'   # Open the code generation interface
#'   llm_generate_code()
#' }
llm_generate_code <- function() {
  # Create the UI
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Generate R Code with LLM", right = miniUI::miniTitleBarButton("done", "Generate", primary = TRUE)),
    miniUI::miniContentPanel(
      shiny::fillPage(
        shiny::tags$style(HTML("
          .container-fluid { padding: 20px; }
          .form-group { margin-bottom: 15px; }
          .btn-primary { background-color: #007bff; }
        ")),

        shiny::fluidRow(
          shiny::column(12,
            shiny::h4("Code Generation Settings"),
            shiny::hr()
          )
        ),

        shiny::fluidRow(
          shiny::column(6,
            shiny::selectInput("provider", "LLM Provider:",
              choices = c("OpenAI" = "openai", "Gemini" = "gemini",
                         "Qwen" = "qwen", "OpenRouter" = "openrouter"),
              selected = "openai"
            )
          ),
          shiny::column(6,
            shiny::selectInput("model", "Model:",
              choices = c("gpt-4" = "gpt-4"),
              selected = "gpt-4"
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(6,
            shiny::numericInput("temperature", "Temperature:", value = 0.7, min = 0, max = 2, step = 0.1)
          ),
          shiny::column(6,
            shiny::numericInput("max_tokens", "Max Tokens:", value = 2000, min = 100, max = 4000, step = 100)
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::textAreaInput("prompt", "Describe what code you want to generate:",
              placeholder = "e.g., Create a function to calculate the mean and standard deviation of a numeric vector",
              height = "120px", width = "100%"
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::div(id = "status", style = "margin-top: 10px;"),
            shiny::div(id = "result", style = "margin-top: 15px;")
          )
        )
      )
    )
  )

  # Create the server
  server <- function(input, output, session) {
    config <- load_config()

    # Update model choices when provider changes
    shiny::observe({
      models <- get_available_models(input$provider, config)
      shiny::updateSelectInput(session, "model",
        choices = stats::setNames(models, models),
        selected = config$providers[[input$provider]]$default_model
      )
    })

    # Generate code when button is clicked
    shiny::observeEvent(input$done, {
      if (nchar(input$prompt) == 0) {
        shiny::showNotification("Please enter a prompt", type = "error")
        return()
      }

      # Check if API key is configured
      api_key <- get_api_key(input$provider)
      if (is.null(api_key)) {
        shiny::showNotification(
          paste("No API key configured for", input$provider,
                ". Please configure it in LLM Settings."),
          type = "error"
        )
        return()
      }

      # Show loading status
      shiny::insertUI(
        selector = "#status",
        where = "beforeEnd",
        ui = shiny::div(
          shiny::icon("spinner", class = "fa-spin"),
          " Generating code...",
          id = "loading"
        )
      )

      # Create client and call LLM
      client <- create_api_client(input$provider, api_key, config)

      # Format prompt with template
      formatted_prompt <- glue::glue(config$prompts$generate_code, prompt = input$prompt)

      result <- call_llm(client, formatted_prompt, input$model, input$temperature, input$max_tokens)

      # Remove loading indicator
      shiny::removeUI("#loading")

      if (result$success) {
        # Insert code into RStudio
        if (rstudioapi::isAvailable()) {
          rstudioapi::insertText(result$content)
        }

        shiny::showNotification("Code generated and inserted!", type = "message")
        shiny::stopApp()
      } else {
        shiny::showNotification(paste("Error:", result$error), type = "error")
      }
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }

  # Run the gadget
  viewer <- shiny::dialogViewer("Generate Code with LLM", width = 800, height = 600)
  shiny::runGadget(ui, server, viewer = viewer)
}

#' Fix Code with LLM
#'
#' Opens an interactive dialog to fix and improve selected R code using various LLM providers.
#' If no code is selected, opens with an empty text area for manual input.
#' The improved code can be inserted back into the active RStudio document.
#'
#' @return No return value, called for side effects (opens interactive UI)
#' @export
#' @examples
#' \dontrun{
#'   # Select some R code in RStudio, then run:
#'   llm_fix_code()
#' }
llm_fix_code <- function() {
  # Get selected text from RStudio
  selected_text <- ""
  if (rstudioapi::isAvailable()) {
    context <- rstudioapi::getActiveDocumentContext()
    if (nchar(context$selection[[1]]$text) > 0) {
      selected_text <- context$selection[[1]]$text
    }
  }

  # Create the UI
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Fix R Code with LLM", right = miniUI::miniTitleBarButton("done", "Fix Code", primary = TRUE)),
    miniUI::miniContentPanel(
      shiny::fillPage(
        shiny::tags$style(HTML("
          .container-fluid { padding: 20px; }
          .form-group { margin-bottom: 15px; }
        ")),

        shiny::fluidRow(
          shiny::column(6,
            shiny::selectInput("provider", "LLM Provider:",
              choices = c("OpenAI" = "openai", "Gemini" = "gemini",
                         "Qwen" = "qwen", "OpenRouter" = "openrouter"),
              selected = "openai"
            )
          ),
          shiny::column(6,
            shiny::selectInput("model", "Model:",
              choices = c("gpt-4" = "gpt-4")
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::textAreaInput("code", "R Code to Fix:",
              value = selected_text,
              height = "200px", width = "100%"
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::textAreaInput("instructions", "Additional Instructions (optional):",
              placeholder = "e.g., Make it more efficient, add error handling, etc.",
              height = "80px", width = "100%"
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::div(id = "status", style = "margin-top: 10px;"),
            shiny::div(id = "result", style = "margin-top: 15px;")
          )
        )
      )
    )
  )

  # Create the server
  server <- function(input, output, session) {
    config <- load_config()

    # Update model choices when provider changes
    shiny::observe({
      models <- get_available_models(input$provider, config)
      shiny::updateSelectInput(session, "model",
        choices = stats::setNames(models, models),
        selected = config$providers[[input$provider]]$default_model
      )
    })

    # Fix code when button is clicked
    shiny::observeEvent(input$done, {
      if (nchar(input$code) == 0) {
        shiny::showNotification("Please enter code to fix", type = "error")
        return()
      }

      api_key <- get_api_key(input$provider)
      if (is.null(api_key)) {
        shiny::showNotification(
          paste("No API key configured for", input$provider),
          type = "error"
        )
        return()
      }

      # Show loading status
      shiny::insertUI(
        selector = "#status",
        where = "beforeEnd",
        ui = shiny::div(
          shiny::icon("spinner", class = "fa-spin"),
          " Fixing code...",
          id = "loading"
        )
      )

      client <- create_api_client(input$provider, api_key, config)

      # Add instructions to the code if provided
      code_with_instructions <- input$code
      if (nchar(input$instructions) > 0) {
        code_with_instructions <- paste0(code_with_instructions, "\n\n# Additional instructions: ", input$instructions)
      }

      formatted_prompt <- glue::glue(config$prompts$fix_code, code = code_with_instructions)
      result <- call_llm(client, formatted_prompt, input$model, 0.3, 3000)

      shiny::removeUI("#loading")

      if (result$success) {
        if (rstudioapi::isAvailable()) {
          # Replace selected text or insert at cursor
          context <- rstudioapi::getActiveDocumentContext()
          if (nchar(context$selection[[1]]$text) > 0) {
            rstudioapi::modifyRange(context$selection[[1]]$range, result$content)
          } else {
            rstudioapi::insertText(result$content)
          }
        }

        shiny::showNotification("Code fixed and updated!", type = "message")
        shiny::stopApp()
      } else {
        shiny::showNotification(paste("Error:", result$error), type = "error")
      }
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }

  viewer <- shiny::dialogViewer("Fix Code with LLM", width = 800, height = 700)
  shiny::runGadget(ui, server, viewer = viewer)
}

#' Explain Code with LLM
#'
#' Opens an interactive dialog to get explanations of selected R code using various LLM providers.
#' If no code is selected, opens with an empty text area for manual input.
#' The explanation is displayed in a formatted output area.
#'
#' @return No return value, called for side effects (opens interactive UI)
#' @export
#' @examples
#' \dontrun{
#'   # Select some R code in RStudio, then run:
#'   llm_explain_code()
#' }
llm_explain_code <- function() {
  # Get selected text from RStudio
  selected_text <- ""
  if (rstudioapi::isAvailable()) {
    context <- rstudioapi::getActiveDocumentContext()
    if (nchar(context$selection[[1]]$text) > 0) {
      selected_text <- context$selection[[1]]$text
    }
  }

  # Create the UI
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Explain R Code", right = miniUI::miniTitleBarButton("done", "Explain", primary = TRUE)),
    miniUI::miniContentPanel(
      shiny::fillPage(
        shiny::tags$style(HTML("
          .container-fluid { padding: 20px; }
          .explanation {
            background-color: #f8f9fa;
            padding: 15px;
            border-left: 4px solid #007bff;
            margin-top: 15px;
          }
        ")),

        shiny::fluidRow(
          shiny::column(6,
            shiny::selectInput("provider", "LLM Provider:",
              choices = c("OpenAI" = "openai", "Gemini" = "gemini",
                         "Qwen" = "qwen", "OpenRouter" = "openrouter"),
              selected = "openai"
            )
          ),
          shiny::column(6,
            shiny::selectInput("model", "Model:",
              choices = c("gpt-4" = "gpt-4")
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::textAreaInput("code", "R Code to Explain:",
              value = selected_text,
              height = "200px", width = "100%"
            )
          )
        ),

        shiny::fluidRow(
          shiny::column(12,
            shiny::div(id = "status"),
            shiny::div(id = "explanation-result")
          )
        )
      )
    )
  )

  # Create the server
  server <- function(input, output, session) {
    config <- load_config()

    shiny::observe({
      models <- get_available_models(input$provider, config)
      shiny::updateSelectInput(session, "model",
        choices = stats::setNames(models, models),
        selected = config$providers[[input$provider]]$default_model
      )
    })

    shiny::observeEvent(input$done, {
      if (nchar(input$code) == 0) {
        shiny::showNotification("Please enter code to explain", type = "error")
        return()
      }

      api_key <- get_api_key(input$provider)
      if (is.null(api_key)) {
        shiny::showNotification(
          paste("No API key configured for", input$provider),
          type = "error"
        )
        return()
      }

      shiny::insertUI(
        selector = "#status",
        where = "beforeEnd",
        ui = shiny::div(
          shiny::icon("spinner", class = "fa-spin"),
          " Generating explanation...",
          id = "loading"
        )
      )

      client <- create_api_client(input$provider, api_key, config)
      formatted_prompt <- glue::glue(config$prompts$explain_code, code = input$code)
      result <- call_llm(client, formatted_prompt, input$model, 0.5, 3000)

      shiny::removeUI("#loading")

      if (result$success) {
        shiny::insertUI(
          selector = "#explanation-result",
          where = "beforeEnd",
          ui = shiny::div(
            class = "explanation",
            shiny::h4("Code Explanation:"),
            shiny::pre(result$content)
          )
        )
        shiny::showNotification("Explanation generated!", type = "message")
      } else {
        shiny::showNotification(paste("Error:", result$error), type = "error")
      }
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }

  viewer <- shiny::dialogViewer("Explain Code", width = 900, height = 700)
  shiny::runGadget(ui, server, viewer = viewer)
}
