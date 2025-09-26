# LLM Coder - RStudio Addin for Code Generation

Um addin para RStudio que permite gerar, corrigir e explicar código R usando diversos modelos de linguagem (LLM) através de APIs.

## 🚀 Funcionalidades

- **Geração de Código**: Descreva o que você quer em linguagem natural e gere código R automaticamente
- **Correção de Código**: Corrija e melhore código R existente com sugestões inteligentes
- **Explicação de Código**: Obtenha explicações detalhadas sobre como o código R funciona
- **Múltiplos Provedores**: Suporte para OpenAI, Google Gemini, Alibaba Qwen e OpenRouter
- **Interface Integrada**: Interface amigável diretamente no RStudio

## 🛠️ Provedores Suportados (Modelos 2024/2025)

### 🔥 OpenAI
- **GPT-4o** (novo padrão), GPT-4o-mini, O1-preview, O1-mini
- GPT-4-turbo, GPT-4, GPT-3.5-turbo
- Chave API: [OpenAI Platform](https://platform.openai.com/api-keys)

### 🔥 Google Gemini
- **Gemini 2.0 Flash Exp** (🆕), **Gemini Exp-1206** (🆕)
- Gemini 1.5 Pro, Gemini 1.5 Flash, Gemini 1.5 Flash-8B
- Chave API: [Google AI Studio](https://aistudio.google.com/app/apikey)

### 🔥 Alibaba Qwen
- Qwen-max, Qwen-plus, Qwen-turbo
- **Série Qwen 2.5**: 72B, 32B, 14B, 7B, 3B, 1.5B, 0.5B
- **QwQ-32B-preview** (🆕 modelo de raciocínio)
- Chave API: [Alibaba Cloud DashScope](https://dashscope.console.aliyun.com/)

### 🔥 OpenRouter
- **300+ modelos atualizados**: Claude 3.5, Llama 3.1-405B, Grok Beta
- **Modelos especializados**: Codestral, DeepSeek, Command R+
- Chave API: [OpenRouter Keys](https://openrouter.ai/keys)

### ➕ Modelos Personalizados
- **Sistema flexível** para adicionar qualquer modelo novo
- **Interface gráfica** para gerenciamento
- **Importação automática** de modelos populares

## 📦 Instalação

### Opção 1: Instalação Local (Recomendada)

1. Clone ou baixe este repositório
2. No RStudio, instale as dependências:

```r
# Instalar dependências
install.packages(c(
  "shiny", "miniUI", "rstudioapi", "httr2", "jsonlite",
  "DT", "shinydashboard", "shinyWidgets", "config", "glue"
))
```

3. Instale o pacote local:

```r
# Se usando devtools
devtools::install("caminho/para/llmcoder")

# Ou se usando remotes
remotes::install_local("caminho/para/llmcoder")
```

### Opção 2: Carregar durante Desenvolvimento

```r
# Carregar o pacote para desenvolvimento
devtools::load_all("caminho/para/llmcoder")
```

## ⚙️ Configuração

### 1. Configurar Chaves API

Após a instalação, configure suas chaves API usando uma das opções:

#### Opção A: Interface Gráfica (Recomendada)
1. No RStudio, vá em **Addins** → **LLM Settings**
2. Digite suas chaves API para os provedores desejados
3. Clique em **Test Connection** para verificar
4. Salve as configurações

#### Opção B: Variáveis de Ambiente
Adicione as chaves API ao seu `.Renviron`:

```bash
OPENAI_API_KEY=sk-your-openai-key-here
GEMINI_API_KEY=AIza-your-gemini-key-here
QWEN_API_KEY=sk-your-qwen-key-here
OPENROUTER_API_KEY=sk-or-your-openrouter-key-here
```

Reinicie o RStudio após adicionar as variáveis.

## 🎯 Como Usar

### 1. Gerar Código
1. No menu **Addins** → **Generate Code with LLM**
2. Escolha o provedor e modelo
3. Descreva o que você quer em português ou inglês
4. Clique em **Generate** - o código será inserido no editor

**Exemplo**: "Criar uma função para calcular a média e desvio padrão de um vetor numérico"

### 2. Corrigir Código
1. Selecione o código R que precisa ser corrigido
2. **Addins** → **Fix Code with LLM**
3. Adicione instruções específicas se necessário
4. O código corrigido substituirá a seleção

### 3. Explicar Código
1. Selecione o código R que você quer entender
2. **Addins** → **Explain Code**
3. Receba uma explicação detalhada do funcionamento

### 4. Gerenciar Modelos Personalizados
1. **Addins** → **LLM Settings** → aba **Custom Models**
2. **Adicionar modelos:** Digite o ID exato do modelo
3. **Importar populares:** Clique "Import OpenRouter Models" para 20+ modelos
4. **Gerenciar:** Visualize, edite ou remova modelos

**Exemplos de modelos para adicionar:**
```r
# Via código R
add_custom_model("openai", "gpt-4o-2024-11-20", "GPT-4o Nov 2024")
add_custom_model("openrouter", "anthropic/claude-3-5-sonnet", "Claude 3.5 Sonnet")
add_custom_model("qwen", "qwq-32b-preview", "QwQ 32B Reasoning")

# Importar modelos populares
import_openrouter_models(limit = 20)
```

## 🔧 Estrutura do Projeto

```
llmcoder/
├── DESCRIPTION              # Metadados do pacote
├── NAMESPACE               # Exportações e imports
├── R/                      # Código fonte
│   ├── addin_functions.R   # Funções principais dos addins
│   ├── api_clients.R       # Clientes das APIs
│   ├── config_manager.R    # Gerenciamento de configurações
│   └── settings_ui.R       # Interface de configurações
├── inst/
│   ├── rstudio/
│   │   └── addins.dcf      # Registro dos addins
│   └── config.yml          # Configurações padrão
└── README.md               # Este arquivo
```

## 🛡️ Segurança

- As chaves API são armazenadas localmente em `~/.llmcoder_config.rds`
- Use variáveis de ambiente para maior segurança
- Nunca compartilhe suas chaves API
- As chaves são mascaradas na interface (••••••••)

## 🔍 Solução de Problemas

### Erro: "No API key configured"
- Configure a chave API através do menu **LLM Settings**
- Ou defina a variável de ambiente correspondente

### Erro: "API key is invalid"
- Verifique se a chave API está correta
- Confirme se você tem créditos/cotas disponíveis
- Use **Test Connection** para validar

### Addin não aparece no menu
```r
# Reinstale o pacote
devtools::install("caminho/para/llmcoder", force = TRUE)

# Reinicie o RStudio
.rs.restartR()
```

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua funcionalidade
3. Commit suas mudanças
4. Abra um Pull Request

## 📄 Licença

MIT License - veja o arquivo LICENSE para detalhes.

## 🆘 Suporte

Para problemas ou sugestões:
1. Abra uma issue neste repositório
2. Consulte a documentação dos provedores de API
3. Verifique os logs do RStudio para erros detalhados

---

**Desenvolvido para a comunidade R** 🚀