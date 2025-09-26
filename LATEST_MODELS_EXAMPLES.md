# Exemplos com os Modelos Mais Recentes (2024/2025)

Este guia mostra como usar os modelos LLM mais avançados e recentes no LLM Coder.

## 🚀 Adicionando os Modelos Mais Recentes

### Método Rápido (Interface Gráfica)
1. Addins → LLM Settings → Custom Models
2. Clicar "Import OpenRouter Models" (20+ modelos)
3. Adicionar manualmente modelos específicos

### Método Programático
```r
library(llmcoder)

# === MODELOS OPENAI MAIS RECENTES ===
add_custom_model("openai", "gpt-4o-2024-11-20", "GPT-4o Nov 2024")
add_custom_model("openai", "o1-2024-12-17", "O1 Dec 2024")
add_custom_model("openai", "gpt-4o-mini-2024-07-18", "GPT-4o Mini Updated")

# === MODELOS GEMINI 2.0 ===
add_custom_model("gemini", "gemini-2.0-flash-exp", "Gemini 2.0 Flash Experimental")
add_custom_model("gemini", "gemini-exp-1206", "Gemini Experimental Dec 2024")
add_custom_model("gemini", "gemini-1.5-pro-002", "Gemini 1.5 Pro v2")

# === QWEN 2.5 E QwQ ===
add_custom_model("qwen", "qwq-32b-preview", "QwQ 32B Reasoning Preview")
add_custom_model("qwen", "qwen2.5-coder-32b-instruct", "Qwen 2.5 Coder 32B")
add_custom_model("qwen", "qwen2.5-math-72b-instruct", "Qwen 2.5 Math 72B")

# === OPENROUTER AVANÇADOS ===
add_custom_model("openrouter", "anthropic/claude-3-5-sonnet-20241022", "Claude 3.5 Sonnet")
add_custom_model("openrouter", "meta-llama/llama-3.1-405b-instruct", "Llama 3.1 405B")
add_custom_model("openrouter", "x-ai/grok-beta", "Grok Beta (xAI)")
add_custom_model("openrouter", "deepseek/deepseek-r1-distill-llama-70b", "DeepSeek R1 70B")

# Importar muitos de uma vez
import_openrouter_models(limit = 30)
```

## 🎯 Casos de Uso por Modelo

### 1. Para Geração de Código Complexo

**GPT-4o (2024-11-20)** - Melhor modelo atual da OpenAI
```r
# Use para:
# - Análise de dados complexa
# - Funções com múltiplas dependências
# - Código otimizado para performance
```

**Claude 3.5 Sonnet** - Excelente em explicações e estrutura
```r
# Use para:
# - Código bem documentado
# - Funções educacionais
# - Análise estatística explicada
```

**Llama 3.1 405B** - Modelo open-source mais poderoso
```r
# Use para:
# - Alternativa gratuita/barata aos modelos comerciais
# - Código para pesquisa acadêmica
# - Processamento de dados massivos
```

### 2. Para Debugging e Correção

**O1-Preview/O1-Mini** - Modelos de raciocínio da OpenAI
```r
# Exemplo de uso para debugging:
# 1. Selecione código com bug
# 2. Addins → Fix Code with LLM
# 3. Escolher modelo: o1-preview
# 4. Instruções: "Encontre todos os bugs e explique o raciocínio"
```

**QwQ-32B-Preview** - Modelo de raciocínio da Alibaba
```r
# Especializado em:
# - Análise lógica de algoritmos
# - Debugging de loops complexos
# - Otimização matemática
```

**DeepSeek R1** - Modelo chinês focado em raciocínio
```r
# Forte em:
# - Análise de performance
# - Refatoração de código
# - Soluções algorítmicas
```

### 3. Para Código Especializado

**Qwen 2.5 Coder 32B** - Especializado em programação
```r
# Melhor para:
# - Geração de pacotes R
# - Código para Shiny apps
# - APIs e integrações
```

**Codestral (Mistral)** - Focado 100% em código
```r
# Exemplo via OpenRouter:
# add_custom_model("openrouter", "mistralai/codestral-latest", "Codestral Latest")

# Use para:
# - Conversão entre linguagens
# - Código limpo e eficiente
# - Padrões de design
```

**Qwen 2.5 Math 72B** - Especializado em matemática
```r
# Perfeito para:
# - Análise estatística complexa
# - Modelos matemáticos
# - Simulações numéricas
```

### 4. Para Explicações Didáticas

**Gemini 2.0 Flash** - Rápido e educacional
```r
# Use para explicar:
# - Conceitos de R para iniciantes
# - Lógica de algoritmos
# - Estruturas de dados
```

**Claude 3.5 Haiku** - Explicações concisas
```r
# add_custom_model("openrouter", "anthropic/claude-3-5-haiku-20241022", "Claude 3.5 Haiku")

# Ideal para:
# - Comentários de código
# - Documentação rápida
# - Explicações em português
```

## 🔬 Exemplos Práticos por Cenário

### Cenário 1: Análise de Dados Avançada

**Prompt:** "Criar análise completa de um dataset com clustering, PCA e visualizações interativas"

**Modelo Recomendado:** GPT-4o-2024-11-20
```r
# Gerar código para análise multivariada completa
# O modelo criará:
# - Limpeza e preparação dos dados
# - Análise exploratória
# - Clustering k-means e hierárquico
# - PCA com biplot
# - Visualizações com plotly
# - Relatório em RMarkdown
```

### Cenário 2: Debugging de Algoritmo Complexo

**Código com problema:** Algoritmo de otimização que não converge

**Modelo Recomendado:** O1-Preview
```r
# O modelo O1 fará:
# 1. Análise step-by-step do algoritmo
# 2. Identificação de problemas de convergência
# 3. Sugestões de inicialização
# 4. Implementação de critérios de parada
# 5. Validação numérica
```

### Cenário 3: Criação de Pacote R

**Prompt:** "Criar estrutura completa de um pacote R para análise de séries temporais"

**Modelo Recomendado:** Qwen 2.5 Coder 32B
```r
# O modelo criará:
# - Estrutura de diretórios
# - Funções com documentação roxygen2
# - Testes unitários com testthat
# - Vinhetas explicativas
# - DESCRIPTION e NAMESPACE corretos
```

### Cenário 4: Código Matemático Complexo

**Prompt:** "Implementar algoritmo de regressão bayesiana com MCMC"

**Modelo Recomendado:** Qwen 2.5 Math 72B
```r
# O modelo implementará:
# - Priors informativos
# - Sampler Metropolis-Hastings
# - Diagnósticos de convergência
# - Visualizações posteriori
# - Validação cruzada bayesiana
```

### Cenário 5: Shiny App Avançado

**Prompt:** "Criar dashboard interativo com múltiplas visualizações e dados em tempo real"

**Modelo Recomendado:** Claude 3.5 Sonnet
```r
# O modelo criará:
# - Interface reativa bem estruturada
# - Módulos organizados
# - Conexão com APIs
# - Visualizações D3.js/plotly
# - Deploy automático
```

## 📊 Comparativo de Performance

### Velocidade (tokens/segundo)
1. **Gemini 2.0 Flash** - Ultra rápido
2. **GPT-4o Mini** - Muito rápido
3. **Claude 3.5 Haiku** - Rápido
4. **Qwen Turbo** - Rápido
5. **GPT-4o** - Moderado
6. **O1-Mini** - Lento (mais raciocínio)
7. **Llama 405B** - Muito lento

### Qualidade para Código R
1. **GPT-4o** - Excelente
2. **Claude 3.5 Sonnet** - Excelente
3. **Qwen 2.5 Coder** - Muito bom
4. **O1-Preview** - Muito bom (debugging)
5. **Codestral** - Muito bom
6. **Llama 3.1 405B** - Bom
7. **Gemini 2.0 Flash** - Bom

### Custo-Benefício
1. **Qwen modelos** - Muito barato
2. **OpenRouter** - Preços competitivos
3. **GPT-4o Mini** - Barato para OpenAI
4. **Gemini Flash** - Moderado
5. **Claude Haiku** - Moderado
6. **GPT-4o** - Caro
7. **O1-Preview** - Muito caro

## 💡 Dicas de Configuração

### Para Desenvolvimento Diário
```r
# Configurar modelos balanceados
prefs <- get_user_prefs()
prefs$default_provider <- "openai"
prefs$default_model <- "gpt-4o-mini"  # Rápido e barato
save_user_prefs(prefs)
```

### Para Trabalho Profissional
```r
# Usar modelos premium
prefs$default_model <- "gpt-4o-2024-11-20"  # Melhor qualidade
```

### Para Experimentação
```r
# Usar OpenRouter com variedade
prefs$default_provider <- "openrouter"
prefs$default_model <- "anthropic/claude-3-5-sonnet"
```

### Para Economia
```r
# Usar modelos Qwen
prefs$default_provider <- "qwen"
prefs$default_model <- "qwen2.5-32b-instruct"
```

## 🔄 Atualizações Automáticas

### Script de Atualização Mensal
```r
# Adicionar ao seu .Rprofile
update_llm_models <- function() {
  # Importar novos modelos OpenRouter
  import_openrouter_models(limit = 50)

  # Verificar novos modelos principais
  new_models <- list(
    openai = c("gpt-4o-latest", "o1-latest"),
    gemini = c("gemini-2.0-latest", "gemini-pro-vision"),
    qwen = c("qwen3-preview", "qwen2.5-latest")
  )

  for(provider in names(new_models)) {
    for(model in new_models[[provider]]) {
      tryCatch({
        add_custom_model(provider, model, paste(model, "- Auto Added"))
      }, error = function(e) {
        # Ignorar se já existe
      })
    }
  }
}

# Executar mensalmente
# update_llm_models()
```

---

**Mantenha-se atualizado com os modelos mais recentes para aproveitar as últimas melhorias!** 🚀

*Última atualização: Dezembro 2024*