#' LLM Coder Installation and Testing Script
#'
#' Este script testa a instalação completa do addin LLM Coder
#' Execute-o após a instalação para verificar se tudo está funcionando

# Função principal de teste
test_llmcoder_installation <- function() {
  cat("==========================================\n")
  cat("   LLM Coder - Teste de Instalação\n")
  cat("==========================================\n\n")

  # Lista para armazenar resultados
  results <- list()

  # 1. Verificar se o R tem versão adequada
  cat("1. Verificando versão do R...\n")
  r_version <- as.numeric(paste(R.version$major, R.version$minor, sep = "."))
  if (r_version >= 4.0) {
    cat("   ✓ R versão", r_version, "está adequada (>= 4.0)\n")
    results$r_version <- TRUE
  } else {
    cat("   ✗ R versão", r_version, "é muito antiga. Necessário R >= 4.0\n")
    results$r_version <- FALSE
  }

  # 2. Verificar se o RStudio está disponível
  cat("\n2. Verificando RStudio...\n")
  if (requireNamespace("rstudioapi", quietly = TRUE)) {
    if (rstudioapi::isAvailable()) {
      cat("   ✓ RStudio está disponível\n")
      results$rstudio <- TRUE
    } else {
      cat("   ○ RStudio API não está disponível (normal se executando fora do RStudio)\n")
      results$rstudio <- FALSE
    }
  } else {
    cat("   ✗ Pacote rstudioapi não está instalado\n")
    results$rstudio <- FALSE
  }

  # 3. Verificar dependências
  cat("\n3. Verificando dependências...\n")
  required_packages <- c(
    "shiny", "miniUI", "rstudioapi", "httr2", "jsonlite",
    "DT", "shinydashboard", "shinyWidgets", "config", "glue"
  )

  missing_packages <- c()
  for (pkg in required_packages) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      cat("   ✓", pkg, "\n")
    } else {
      cat("   ✗", pkg, "não encontrado\n")
      missing_packages <- c(missing_packages, pkg)
    }
  }

  if (length(missing_packages) == 0) {
    cat("   ✓ Todas as dependências estão instaladas\n")
    results$dependencies <- TRUE
  } else {
    cat("   ✗ Dependências em falta:", paste(missing_packages, collapse = ", "), "\n")
    results$dependencies <- FALSE
  }

  # 4. Verificar se o pacote llmcoder está carregado/disponível
  cat("\n4. Verificando pacote llmcoder...\n")
  main_functions <- c("llm_generate_code", "llm_fix_code", "llm_explain_code", "llm_settings")
  custom_functions <- c("add_custom_model", "list_custom_models", "import_openrouter_models")

  if (all(sapply(main_functions, exists)) && all(sapply(custom_functions, exists))) {
    cat("   ✓ Todas as funções principais e de modelos personalizados estão disponíveis\n")
    results$package <- TRUE
  } else {
    cat("   ○ Tentando carregar o pacote...\n")
    tryCatch({
      library(llmcoder)
      cat("   ✓ Pacote llmcoder carregado com sucesso\n")
      results$package <- TRUE
    }, error = function(e) {
      cat("   ✗ Erro ao carregar pacote:", e$message, "\n")
      cat("   ℹ Tente executar: devtools::load_all() ou devtools::install()\n")
      results$package <- FALSE
    })
  }

  # 5. Verificar configuração
  cat("\n5. Verificando configuração...\n")
  tryCatch({
    # Esta linha só funcionará se as funções estão disponíveis
    if (exists("load_config", mode = "function") ||
        exists("load_config", envir = .GlobalEnv) ||
        "llmcoder" %in% search()) {

      if (exists("load_config")) {
        config <- load_config()
      } else {
        config <- llmcoder:::load_config()
      }

      if (is.list(config) && "providers" %in% names(config)) {
        cat("   ✓ Configuração carregada com sucesso\n")
        cat("   ℹ Provedores disponíveis:", paste(names(config$providers), collapse = ", "), "\n")
        results$config <- TRUE
      } else {
        cat("   ✗ Configuração inválida\n")
        results$config <- FALSE
      }
    } else {
      cat("   ○ Funções de configuração não disponíveis\n")
      results$config <- FALSE
    }
  }, error = function(e) {
    cat("   ✗ Erro ao carregar configuração:", e$message, "\n")
    results$config <- FALSE
  })

  # 6. Verificar chaves API
  cat("\n6. Verificando chaves API...\n")
  providers <- c("openai", "gemini", "qwen", "openrouter")
  configured_providers <- 0

  for (provider in providers) {
    # Verificar variável de ambiente
    env_var <- switch(provider,
      "openai" = "OPENAI_API_KEY",
      "gemini" = "GEMINI_API_KEY",
      "qwen" = "QWEN_API_KEY",
      "openrouter" = "OPENROUTER_API_KEY"
    )

    env_key <- Sys.getenv(env_var, unset = "")
    file_key_exists <- FALSE

    # Verificar arquivo de configuração
    prefs_file <- file.path(path.expand("~"), ".llmcoder_config.rds")
    if (file.exists(prefs_file)) {
      tryCatch({
        prefs <- readRDS(prefs_file)
        if (provider %in% names(prefs$api_keys) && nchar(prefs$api_keys[[provider]]) > 0) {
          file_key_exists <- TRUE
        }
      }, error = function(e) {})
    }

    if (nchar(env_key) > 0) {
      cat("   ✓", provider, "- configurado via variável de ambiente\n")
      configured_providers <- configured_providers + 1
    } else if (file_key_exists) {
      cat("   ✓", provider, "- configurado via arquivo de preferências\n")
      configured_providers <- configured_providers + 1
    } else {
      cat("   ○", provider, "- não configurado\n")
    }
  }

  if (configured_providers > 0) {
    cat("   ✓", configured_providers, "provedor(es) configurado(s)\n")
    results$api_keys <- TRUE
  } else {
    cat("   ○ Nenhum provedor configurado ainda\n")
    cat("   ℹ Configure pelo menos um provedor usando: Addins → LLM Settings\n")
    results$api_keys <- FALSE
  }

  # 7. Verificar se addins estão registrados (apenas se no RStudio)
  cat("\n7. Verificando registro de addins...\n")
  if (results$rstudio) {
    addins_file <- system.file("rstudio", "addins.dcf", package = "llmcoder")
    if (file.exists(addins_file)) {
      cat("   ✓ Arquivo de addins encontrado\n")
      results$addins <- TRUE
    } else {
      # Verifica no diretório atual (desenvolvimento)
      local_addins <- "inst/rstudio/addins.dcf"
      if (file.exists(local_addins)) {
        cat("   ✓ Arquivo de addins encontrado (desenvolvimento)\n")
        results$addins <- TRUE
      } else {
        cat("   ✗ Arquivo de addins não encontrado\n")
        results$addins <- FALSE
      }
    }
  } else {
    cat("   ○ Pulado (RStudio não disponível)\n")
    results$addins <- NA
  }

  # Resumo dos resultados
  cat("\n==========================================\n")
  cat("              RESUMO DOS TESTES\n")
  cat("==========================================\n")

  total_tests <- sum(!is.na(unlist(results)))
  passed_tests <- sum(unlist(results), na.rm = TRUE)

  cat("Testes aprovados:", passed_tests, "/", total_tests, "\n\n")

  # Detalhamento
  status_symbol <- function(x) {
    if (is.na(x)) "○" else if (x) "✓" else "✗"
  }

  cat("Detalhes:\n")
  cat(" ", status_symbol(results$r_version), "Versão do R\n")
  cat(" ", status_symbol(results$rstudio), "RStudio\n")
  cat(" ", status_symbol(results$dependencies), "Dependências\n")
  cat(" ", status_symbol(results$package), "Pacote llmcoder\n")
  cat(" ", status_symbol(results$config), "Configuração\n")
  cat(" ", status_symbol(results$api_keys), "Chaves API\n")
  cat(" ", status_symbol(results$addins), "Registro de addins\n")

  # Recomendações
  cat("\n==========================================\n")
  cat("            PRÓXIMOS PASSOS\n")
  cat("==========================================\n")

  if (!results$dependencies) {
    cat("🔧 INSTALAR DEPENDÊNCIAS:\n")
    if (length(missing_packages) > 0) {
      cat("install.packages(c(", paste0('"', missing_packages, '"', collapse = ", "), "))\n\n")
    }
  }

  if (!results$package) {
    cat("📦 INSTALAR PACOTE:\n")
    cat("devtools::install() # se no diretório do projeto\n")
    cat("# ou\n")
    cat("devtools::load_all() # para desenvolvimento\n\n")
  }

  if (!results$api_keys) {
    cat("🔑 CONFIGURAR CHAVES API:\n")
    cat("1. Execute: llm_settings() ou use Addins → LLM Settings\n")
    cat("2. Ou configure variáveis de ambiente em ~/.Renviron\n\n")
  }

  if (results$rstudio && !is.na(results$addins) && !results$addins) {
    cat("🔄 REINSTALAR E REINICIAR:\n")
    cat("devtools::install(force = TRUE)\n")
    cat(".rs.restartR()\n\n")
  }

  if (all(unlist(results), na.rm = TRUE)) {
    cat("🎉 INSTALAÇÃO COMPLETA!\n")
    cat("Você pode usar os addins em: Addins → Generate Code with LLM\n\n")

    # Teste rápido de funcionalidade (se possível)
    cat("🧪 TESTE RÁPIDO:\n")
    if (results$api_keys) {
      cat("Execute: llm_generate_code()\n")
      cat("Prompt de teste: 'Criar vetor com números de 1 a 10'\n")
    } else {
      cat("Configure uma chave API primeiro, depois teste com llm_generate_code()\n")
    }
  }

  invisible(results)
}

# Função auxiliar para instalação automática de dependências
install_missing_dependencies <- function() {
  required_packages <- c(
    "shiny", "miniUI", "rstudioapi", "httr2", "jsonlite",
    "DT", "shinydashboard", "shinyWidgets", "config", "glue"
  )

  missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]

  if (length(missing_packages) > 0) {
    cat("Instalando pacotes em falta:", paste(missing_packages, collapse = ", "), "\n")
    install.packages(missing_packages)
    cat("Instalação concluída!\n")
  } else {
    cat("Todas as dependências já estão instaladas.\n")
  }
}

# Executar teste automaticamente se script foi chamado diretamente
if (sys.nframe() == 0) {
  test_llmcoder_installation()
}
