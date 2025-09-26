#' Custom Models Management
#'
#' Functions to add, remove, and manage custom models for LLM providers

#' Load Custom Models Configuration
#'
#' @return List of custom models or empty list if not configured
load_custom_models <- function() {
  config <- load_config()

  if (!config$custom_models$enabled) {
    return(list())
  }

  custom_file <- path.expand(config$custom_models$file_path)

  if (file.exists(custom_file)) {
    tryCatch({
      yaml::yaml.load_file(custom_file)
    }, error = function(e) {
      warning("Error loading custom models file: ", e$message)
      list()
    })
  } else {
    list()
  }
}

#' Save Custom Models Configuration
#'
#' @param custom_models List of custom models to save
save_custom_models <- function(custom_models) {
  config <- load_config()

  if (!config$custom_models$enabled) {
    stop("Custom models are not enabled in configuration")
  }

  custom_file <- path.expand(config$custom_models$file_path)

  tryCatch({
    yaml::write_yaml(custom_models, custom_file)
    invisible(TRUE)
  }, error = function(e) {
    stop("Error saving custom models file: ", e$message)
  })
}

#' Add Custom Model
#'
#' @param provider Provider name (openai, gemini, qwen, openrouter)
#' @param model_id Model identifier
#' @param display_name Optional display name for the model
#' @param description Optional description
#' @export
add_custom_model <- function(provider, model_id, display_name = NULL, description = NULL) {
  # Validate provider
  config <- load_config()
  if (!provider %in% names(config$providers)) {
    stop("Invalid provider: ", provider, ". Must be one of: ",
         paste(names(config$providers), collapse = ", "))
  }

  # Check if provider allows custom models
  if (!isTRUE(config$providers[[provider]]$allow_custom_models)) {
    stop("Provider ", provider, " does not allow custom models")
  }

  # Load existing custom models
  custom_models <- load_custom_models()

  # Initialize provider if not exists
  if (!provider %in% names(custom_models)) {
    custom_models[[provider]] <- list()
  }

  # Add the new model
  model_info <- list(
    id = model_id,
    display_name = display_name %||% model_id,
    description = description,
    added_date = Sys.Date()
  )

  # Check if model already exists
  existing_models <- sapply(custom_models[[provider]], function(x) x$id)
  if (model_id %in% existing_models) {
    warning("Model ", model_id, " already exists for provider ", provider, ". Updating...")
  }

  custom_models[[provider]][[model_id]] <- model_info

  # Save the updated configuration
  save_custom_models(custom_models)

  cat("✓ Added custom model '", model_id, "' for provider '", provider, "'\n", sep = "")
  invisible(TRUE)
}

#' Remove Custom Model
#'
#' @param provider Provider name
#' @param model_id Model identifier to remove
#' @export
remove_custom_model <- function(provider, model_id) {
  custom_models <- load_custom_models()

  if (!provider %in% names(custom_models)) {
    stop("No custom models found for provider: ", provider)
  }

  if (!model_id %in% names(custom_models[[provider]])) {
    stop("Model ", model_id, " not found for provider ", provider)
  }

  # Remove the model
  custom_models[[provider]][[model_id]] <- NULL

  # Remove provider section if empty
  if (length(custom_models[[provider]]) == 0) {
    custom_models[[provider]] <- NULL
  }

  # Save the updated configuration
  save_custom_models(custom_models)

  cat("✓ Removed custom model '", model_id, "' from provider '", provider, "'\n", sep = "")
  invisible(TRUE)
}

#' List Custom Models
#'
#' @param provider Optional provider name to filter results
#' @return Data frame with custom models information
#' @export
list_custom_models <- function(provider = NULL) {
  custom_models <- load_custom_models()

  if (length(custom_models) == 0) {
    cat("No custom models configured\n")
    return(invisible(data.frame()))
  }

  # Filter by provider if specified
  if (!is.null(provider)) {
    if (!provider %in% names(custom_models)) {
      cat("No custom models found for provider:", provider, "\n")
      return(invisible(data.frame()))
    }
    custom_models <- custom_models[provider]
  }

  # Convert to data frame
  result <- data.frame(
    provider = character(0),
    model_id = character(0),
    display_name = character(0),
    description = character(0),
    added_date = character(0),
    stringsAsFactors = FALSE
  )

  for (prov in names(custom_models)) {
    for (model_id in names(custom_models[[prov]])) {
      model_info <- custom_models[[prov]][[model_id]]
      result <- rbind(result, data.frame(
        provider = prov,
        model_id = model_info$id,
        display_name = model_info$display_name %||% model_info$id,
        description = model_info$description %||% "",
        added_date = as.character(model_info$added_date %||% ""),
        stringsAsFactors = FALSE
      ))
    }
  }

  if (nrow(result) > 0) {
    print(result)
  } else {
    cat("No custom models found\n")
  }

  invisible(result)
}

#' Get Combined Models List (Built-in + Custom)
#'
#' @param provider Provider name
#' @return Vector of model names
get_all_models <- function(provider) {
  config <- load_config()

  # Get built-in models
  builtin_models <- config$providers[[provider]]$models

  # Get custom models if enabled
  custom_models_list <- c()
  if (isTRUE(config$providers[[provider]]$allow_custom_models)) {
    custom_models <- load_custom_models()
    if (provider %in% names(custom_models)) {
      custom_models_list <- names(custom_models[[provider]])
    }
  }

  # Combine and remove duplicates
  all_models <- unique(c(builtin_models, custom_models_list))

  return(all_models)
}

#' Import Models from OpenRouter
#'
#' Downloads and adds popular models from OpenRouter
#' @param limit Maximum number of models to import (default: 20)
#' @export
import_openrouter_models <- function(limit = 20) {
  cat("Importing popular OpenRouter models...\n")

  # Popular models to add (these are frequently used)
  popular_models <- c(
    "anthropic/claude-3.5-sonnet-20241022",
    "anthropic/claude-3-5-haiku-20241022",
    "google/gemini-2.0-flash-exp:free",
    "meta-llama/llama-3.2-90b-vision-instruct",
    "mistralai/pixtral-12b",
    "qwen/qwen-2.5-coder-32b-instruct",
    "deepseek/deepseek-r1-distill-llama-70b",
    "nvidia/llama-3.1-nemotron-70b-instruct",
    "microsoft/wizardlm-2-8x22b",
    "cohere/command-r7b-12-2024",
    "alibaba/qwen-2.5-72b-instruct",
    "huggingfaceh4/zephyr-7b-beta",
    "01-ai/yi-34b-chat",
    "teknium/openhermes-2.5-mistral-7b"
  )

  # Limit the number of models
  models_to_add <- head(popular_models, limit)

  success_count <- 0
  for (model in models_to_add) {
    tryCatch({
      # Extract display name from model ID
      display_name <- gsub("^[^/]+/", "", model)
      display_name <- gsub("-", " ", display_name)
      display_name <- tools::toTitleCase(display_name)

      add_custom_model(
        provider = "openrouter",
        model_id = model,
        display_name = display_name,
        description = paste("Popular OpenRouter model:", model)
      )
      success_count <- success_count + 1
    }, error = function(e) {
      cat("⚠ Warning: Could not add model", model, ":", e$message, "\n")
    })
  }

  cat("✓ Successfully imported", success_count, "OpenRouter models\n")
  invisible(success_count)
}

#' Create Custom Models Template File
#'
#' Creates an example custom models YAML file
#' @export
create_custom_models_template <- function() {
  config <- load_config()
  template_file <- path.expand(config$custom_models$file_path)

  if (file.exists(template_file)) {
    response <- readline("Custom models file already exists. Overwrite? (y/N): ")
    if (!tolower(response) %in% c("y", "yes")) {
      cat("Cancelled.\n")
      return(invisible(FALSE))
    }
  }

  template_content <- list(
    openai = list(
      "gpt-4o-2024-11-20" = list(
        id = "gpt-4o-2024-11-20",
        display_name = "GPT-4o (Nov 2024)",
        description = "Latest GPT-4o model with improved capabilities",
        added_date = Sys.Date()
      )
    ),
    gemini = list(
      "gemini-2.0-flash-thinking-exp-1219" = list(
        id = "gemini-2.0-flash-thinking-exp-1219",
        display_name = "Gemini 2.0 Flash Thinking",
        description = "Experimental Gemini model with enhanced reasoning",
        added_date = Sys.Date()
      )
    ),
    qwen = list(
      "qwen2.5-coder-32b-instruct" = list(
        id = "qwen2.5-coder-32b-instruct",
        display_name = "Qwen 2.5 Coder 32B",
        description = "Specialized coding model",
        added_date = Sys.Date()
      )
    ),
    openrouter = list(
      "deepseek/deepseek-r1-distill-llama-70b" = list(
        id = "deepseek/deepseek-r1-distill-llama-70b",
        display_name = "DeepSeek R1 70B",
        description = "Advanced reasoning model from DeepSeek",
        added_date = Sys.Date()
      )
    )
  )

  tryCatch({
    yaml::write_yaml(template_content, template_file)
    cat("✓ Created custom models template at:", template_file, "\n")
    cat("Edit this file to add your own custom models.\n")
    invisible(TRUE)
  }, error = function(e) {
    stop("Error creating template: ", e$message)
  })
}

# Helper function for null coalescing
`%||%` <- function(x, y) if (is.null(x)) y else x
