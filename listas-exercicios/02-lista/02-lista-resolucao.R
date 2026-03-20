# ============================================================
# Disciplina: Introdução à Ciência de Dados
# ============================================================
# Arquivo: 02-lista-resolucao.R
# Autor(a): Jonathan Vargas Silva
# Data: 2026/03/19
# Objetivo: Resolução da lista de exercícios 2

# Configuracoes globais  ------------------------------------

# define opções globais para exibição de números
options(digits = 5, scipen = 999)

# carrega os pacotes necessários
library(here)      # para usar caminho relativo
library(tidyverse) # meta-pacote que inclui readr, dplyr..
library(gapminder) # contém os dados gapminder

# carrega os dados do pacote gapminder
data(gapminder)


## Exercício 1

caminho_csv <- here("data/raw/productionlog_sample.csv")
dados_csv <- read.csv(caminho_csv)
glimpse(dados_csv)

## Exercício 2

dados_expectativa <- gapminder |>
  select(country, year, lifeExp)


## Exercício 3

variaveis_exc_pop_e_gdppercap <- gapminder |>
  select(-pop, -gdpPercap)

## Exercício 4

variaveis_com_c <- gapminder |>
  select(starts_with("c"))

## Exercício 5

variaveis_sequencia <- gapminder |>
  select(country:pop)

# Exercício 6

variaveis_com_p <- gapminder |>
  select(contains("p") | ends_with("p"))