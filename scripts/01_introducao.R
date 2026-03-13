# =============================================================
# Disciplina: Introdução à Ciência de Dados
# =============================================================
# Arquivo: 01_introducao.R
# Autor: Jonathan Vargas Silva
# Data: 2026/03/12
# Objetivo: Aprender a usar RStudio, script R  e alguns fundamentos de R






# Configuracoes globais -------------------------------------------------

# define opções globais para exibição de números
options(digits = 5, scipen = 999)

# carrega os pacotes necessários
library(here) # para usar caminhos relativos
library(tidyverse) # meta-pacote que inclui readr, dplyr, ggplot2, etc.
library(skimr) # para compreender dados
library(janitor) # para limpar nomes de colunas


# R como uma grande calculadora -------------------------------------------

# Operacoes aritmeticas basicas

# adicao
15 + 7

# subtracao
20 - 6

# multiplicacao
8 * 9

## divisao
84 / 7

## potenciacao
2 ^ 5

# Predencia de operacao matemáticas
# parenteses primeiro, depois potenciacao, multiplicacao e divisao
# e por ultimo adicao e subtracao

# parentese primeiro
(15 + 7) * 2
84 / (7 + 5)



# Exemplos de funções matemáticas -----------------------------------------

# logaritmo natural
log(100)

# logaritmo base 10
log10(100)

# funcao exponencial (e elevado a x)
exp(1)

# valor absoluto
abs(-45)

# raiz quadrada
sqrt(225)

# arredondamento para 2 casas decimais
round(3.14159, digits = 2)



# Tipos atômicos e classes ------------------------------------------------

# Os tipos de dados definem como os dados
# são armazenados na memória.

# tipo double e classe numeric
a <- 3.14
a
# funcao retorna o tipo do objeto
typeof(a)
# funcao que retorna a classe do objeto
class(a)

# character
b <- "João"
b

# logical
c <- TRUE
c

d <- FALSE
d

# NaN (Not a Number) representa um valor indefinido
e <- 0 / 0
e

# Inf (Infinity) representa um valor infinito
f <- 1 / 0
f

# correcao de logical para numeric
# TRUE = 1 e FALSE = 0
f <- as.numeric(c)
f



# Vetores numéricos -------------------------------------------------------

# Cria dois vetores numericos com dados de receita e custos diarios

receita_diaria <- c(9200, 8700, 10100, 9800, 11050)
print(receita_diaria)


custo_diario <- c (6400, 6000, 7200, 6800, 7600)
custo_diario


# Vetorizacao: operacoes elementos a elemento
lucro_diario <- receita_diaria - custo_diario
margem_diaria <- lucro_diario / receita_diaria



# Funções úteis para vetores numéricos ------------------------------------

# logaritmo da receita diária
log(receita_diaria)

# receita total da semana
sum(receita_diaria)

# receita media da semana
mean(receita_diaria)

# tamanho do vetor de receita
# Nesse caso é o número de dias registrados
length(receita_diaria)

# receita minima da semana
min(receita_diaria)

# receita maxima da semana
max(receita_diaria)

# vendo a ajuda de uma funcao
?mean
?length



# Vetores de caracteres e lógicos -----------------------------------------

# vetores devem conter o mesmo tipo de dados, ou seja,
# todos os elementos devem ser do mesmo tipo

# vetor de caracteres
nome_empresa <- c ("Loja A", "Loja B", "Loja C")
# exibe o vetor criado
nome_empresa

# vetor logico (booleano) indicando se a meta de vendas foi batida
meta_batida <- c(TRUE, FALSE, TRUE)
# exibe o vetor criado
meta_batida




# Fatores -----------------------------------------------------------------

# Fatores são usados para armazenar variáveis categóricas
# nominais ou ordinais.

# vetor de caracteres com meses do ano
meses <- c("Dez", "Abr", "Jan", "Mar")
meses

# um vetor de caracteres é ordenado por ordem alfabética
sort(meses)


# definindo os níveis dos meses em ordem cronológica
niveis_meses <- c(
  "Jan", "Fev", "Mar", "Abr", "Mai", "Jun",
  "Jul", "Ago", "Set", "Out", "Nov", "Dez"
)

# converte o vetor meses para fator, usando os niveis definidos
meses <- factor(meses, levels = niveis_meses)
meses

# ordena os meses
sort(meses)



# Importa arquivo de dados ------------------------------------------------


