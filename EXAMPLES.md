# Exemplos de Uso - LLM Coder

Este documento fornece exemplos práticos de como usar o LLM Coder para diferentes tarefas de programação em R.

## 🎯 Geração de Código

### Exemplo 1: Análise de Dados Básica

**Prompt:** "Criar uma função para calcular estatísticas descritivas de um data frame numérico"

**Código Gerado:**
```r
#' Calculate descriptive statistics for numeric columns in a data frame
#'
#' @param df A data frame containing numeric columns
#' @param na.rm Logical, should NA values be removed? Default is TRUE
#' @return A data frame with descriptive statistics
calculate_descriptive_stats <- function(df, na.rm = TRUE) {
  # Select only numeric columns
  numeric_cols <- df[sapply(df, is.numeric)]

  if (ncol(numeric_cols) == 0) {
    stop("No numeric columns found in the data frame")
  }

  # Calculate statistics for each numeric column
  stats_list <- lapply(numeric_cols, function(x) {
    c(
      n = length(x),
      mean = mean(x, na.rm = na.rm),
      median = median(x, na.rm = na.rm),
      sd = sd(x, na.rm = na.rm),
      min = min(x, na.rm = na.rm),
      max = max(x, na.rm = na.rm),
      q25 = quantile(x, 0.25, na.rm = na.rm),
      q75 = quantile(x, 0.75, na.rm = na.rm)
    )
  })

  # Convert to data frame
  stats_df <- do.call(rbind, stats_list)
  stats_df <- as.data.frame(stats_df)
  stats_df$variable <- names(numeric_cols)

  return(stats_df[, c("variable", "n", "mean", "median", "sd", "min", "max", "q25", "q75")])
}

# Example usage
# stats <- calculate_descriptive_stats(mtcars)
# print(stats)
```

### Exemplo 2: Visualização de Dados

**Prompt:** "Criar um gráfico de dispersão com ggplot2 que inclua linha de tendência e intervalos de confiança"

**Código Gerado:**
```r
library(ggplot2)

#' Create scatter plot with trend line and confidence intervals
#'
#' @param data A data frame containing the data
#' @param x_var Character, name of x variable
#' @param y_var Character, name of y variable
#' @param color_var Character, optional grouping variable for colors
#' @param title Character, plot title
#' @return A ggplot object
create_scatter_with_trend <- function(data, x_var, y_var, color_var = NULL,
                                     title = "Scatter Plot with Trend Line") {

  # Basic scatter plot
  p <- ggplot(data, aes_string(x = x_var, y = y_var))

  # Add color grouping if specified
  if (!is.null(color_var)) {
    p <- p + aes_string(color = color_var)
  }

  # Add points and smooth trend line
  p <- p +
    geom_point(alpha = 0.6, size = 2) +
    geom_smooth(method = "lm", se = TRUE, alpha = 0.2) +
    labs(
      title = title,
      x = x_var,
      y = y_var
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.title = element_text(size = 12),
      legend.title = element_text(size = 11)
    )

  return(p)
}

# Example usage
# library(ggplot2)
# plot <- create_scatter_with_trend(mtcars, "wt", "mpg", "cyl", "Weight vs MPG")
# print(plot)
```

### Exemplo 3: Limpeza de Dados

**Prompt:** "Função para limpar um dataset removendo duplicatas, tratando valores missing e convertendo tipos de dados"

**Código Gerado:**
```r
#' Clean dataset by handling duplicates, missing values, and data types
#'
#' @param df A data frame to clean
#' @param remove_duplicates Logical, remove duplicate rows?
#' @param missing_threshold Numeric, remove columns with missing values above this proportion
#' @param convert_types Logical, attempt to convert character columns to appropriate types?
#' @return A cleaned data frame
clean_dataset <- function(df, remove_duplicates = TRUE, missing_threshold = 0.5, convert_types = TRUE) {

  cat("Original dataset dimensions:", nrow(df), "x", ncol(df), "\n")

  # Remove duplicates
  if (remove_duplicates) {
    initial_rows <- nrow(df)
    df <- unique(df)
    cat("Removed", initial_rows - nrow(df), "duplicate rows\n")
  }

  # Remove columns with too many missing values
  if (missing_threshold < 1) {
    missing_prop <- sapply(df, function(x) sum(is.na(x)) / length(x))
    cols_to_remove <- names(missing_prop[missing_prop > missing_threshold])

    if (length(cols_to_remove) > 0) {
      df <- df[, !names(df) %in% cols_to_remove]
      cat("Removed", length(cols_to_remove), "columns with >", missing_threshold*100, "% missing values\n")
    }
  }

  # Convert data types
  if (convert_types) {
    for (col in names(df)) {
      if (is.character(df[[col]])) {
        # Try to convert to numeric
        numeric_version <- suppressWarnings(as.numeric(df[[col]]))
        if (!all(is.na(numeric_version)) && sum(is.na(numeric_version)) < sum(is.na(df[[col]]))) {
          df[[col]] <- numeric_version
          cat("Converted", col, "to numeric\n")
        }
        # Try to convert to date
        else if (any(grepl("\\d{4}-\\d{2}-\\d{2}", df[[col]], na.rm = TRUE))) {
          date_version <- suppressWarnings(as.Date(df[[col]]))
          if (sum(is.na(date_version)) < length(df[[col]]) * 0.5) {
            df[[col]] <- date_version
            cat("Converted", col, "to Date\n")
          }
        }
      }
    }
  }

  cat("Final dataset dimensions:", nrow(df), "x", ncol(df), "\n")
  return(df)
}

# Example usage
# cleaned_data <- clean_dataset(raw_data, remove_duplicates = TRUE, missing_threshold = 0.3)
```

## 🔧 Correção de Código

### Exemplo 1: Código com Bug

**Código Original:**
```r
# Função com bugs
calculate_mean <- function(x) {
  if (lenght(x) == 0) {  # Erro de digitação
    return(NULL)
  }

  sum <- 0
  for (i in 1:length(x)) {
    sum <- sum + x[i]
  }

  return(sum / lenght(x))  # Erro de digitação novamente
}
```

**Código Corrigido:**
```r
#' Calculate the mean of a numeric vector with proper error handling
#'
#' @param x A numeric vector
#' @param na.rm Logical, should NA values be removed?
#' @return The mean value or NA if input is invalid
calculate_mean <- function(x, na.rm = FALSE) {
  # Input validation
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector")
  }

  if (length(x) == 0) {
    return(NA)
  }

  # Handle NA values
  if (na.rm) {
    x <- x[!is.na(x)]
  }

  # Check for remaining values after NA removal
  if (length(x) == 0) {
    return(NA)
  }

  # Use built-in mean function for better performance and accuracy
  return(mean(x))
}

# Alternative: Simply use the built-in mean function
# result <- mean(x, na.rm = na.rm)
```

### Exemplo 2: Otimização de Performance

**Código Original:**
```r
# Código lento usando loop
slow_function <- function(data) {
  result <- c()
  for (i in 1:nrow(data)) {
    if (data$value[i] > 0) {
      result <- c(result, data$value[i] * 2)
    }
  }
  return(result)
}
```

**Código Otimizado:**
```r
#' Optimized function using vectorization
#'
#' @param data A data frame with a 'value' column
#' @return A vector of doubled positive values
fast_function <- function(data) {
  # Input validation
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }

  if (!"value" %in% names(data)) {
    stop("Data frame must contain a 'value' column")
  }

  # Vectorized operation (much faster)
  positive_values <- data$value[data$value > 0 & !is.na(data$value)]
  result <- positive_values * 2

  return(result)
}

# Even more concise version
# fast_function <- function(data) data$value[data$value > 0 & !is.na(data$value)] * 2
```

## 📚 Explicação de Código

### Exemplo 1: Análise Complexa

**Código para Explicar:**
```r
library(dplyr)
library(tidyr)

result <- mtcars %>%
  rownames_to_column("car") %>%
  select(car, mpg, cyl, hp, wt) %>%
  group_by(cyl) %>%
  summarise(
    across(c(mpg, hp, wt),
           list(mean = mean, sd = sd),
           .names = "{.col}_{.fn}"),
    count = n(),
    .groups = "drop"
  ) %>%
  pivot_longer(
    cols = -c(cyl, count),
    names_to = c("metric", "stat"),
    names_sep = "_",
    values_to = "value"
  )
```

**Explicação Gerada:**

Este código realiza uma análise estatística detalhada do dataset `mtcars` usando o tidyverse. Vamos analisar cada etapa:

**1. Preparação dos Dados:**
```r
rownames_to_column("car")
```
- Converte os nomes das linhas (nomes dos carros) em uma coluna chamada "car"
- Isso é necessário porque o dplyr trabalha melhor com dados tabulares

**2. Seleção de Variáveis:**
```r
select(car, mpg, cyl, hp, wt)
```
- Seleciona apenas as colunas de interesse: nome do carro, milhas por galão, número de cilindros, cavalos-força e peso

**3. Agrupamento:**
```r
group_by(cyl)
```
- Agrupa os dados por número de cilindros (4, 6, ou 8)
- Todas as operações subsequentes serão aplicadas dentro de cada grupo

**4. Cálculo de Estatísticas:**
```r
summarise(
  across(c(mpg, hp, wt),
         list(mean = mean, sd = sd),
         .names = "{.col}_{.fn}"),
  count = n(),
  .groups = "drop"
)
```
- `across()`: Aplica múltiplas funções a múltiplas colunas
- Calcula média e desvio padrão para mpg, hp e wt
- `.names = "{.col}_{.fn}"` cria nomes como "mpg_mean", "mpg_sd", etc.
- `count = n()` conta quantos carros há em cada grupo
- `.groups = "drop"` remove o agrupamento após o summarise

**5. Transformação para Formato Longo:**
```r
pivot_longer(
  cols = -c(cyl, count),
  names_to = c("metric", "stat"),
  names_sep = "_",
  values_to = "value"
)
```
- Transforma dados de formato largo para longo
- `cols = -c(cyl, count)`: Aplica a transformação a todas as colunas exceto cyl e count
- `names_sep = "_"`: Separa os nomes das colunas usando "_" como delimitador
- Cria duas novas colunas: "metric" (mpg, hp, wt) e "stat" (mean, sd)
- Os valores vão para a coluna "value"

**Resultado Final:**
O código produz um dataset em formato longo onde cada linha representa uma estatística específica (média ou desvio padrão) para uma métrica específica (mpg, hp, wt) dentro de um grupo de cilindros. Este formato é ideal para visualizações com ggplot2 ou análises posteriores.

## 💡 Dicas de Uso

### Para Prompts Eficazes:
1. **Seja específico:** "Criar gráfico de barras com ggplot2" é melhor que "fazer um gráfico"
2. **Inclua contexto:** Mencione o tipo de dados, bibliotecas preferidas, etc.
3. **Especifique formato:** Peça documentação, tratamento de erros, exemplos de uso

### Para Correção de Código:
1. **Selecione o código problema** antes de usar o addin
2. **Descreva o problema** nas instruções adicionais
3. **Especifique melhorias desejadas:** performance, legibilidade, tratamento de erros

### Para Explicações:
1. **Selecione código complexo** que precisa de entendimento
2. **Use para aprender** novos padrões e técnicas
3. **Solicite explicações didáticas** para código de outros

---

Estes exemplos mostram o potencial do LLM Coder para acelerar o desenvolvimento, aprender novas técnicas e melhorar a qualidade do código R. Experimente com seus próprios casos de uso! 🚀