# ==============================================================================
# SCRIPT DE GERAÇÃO DA APRESENTAÇÃO HTML - CORREÇÃO DEFINITIVA DOS GRÁFICOS
# ==============================================================================

# 1. Definindo os caminhos
caminho_saida <- "C:/R/GitHub/mpa_icfadf2026-/trabalhos/3-trabalho"
path_scatter_L <- "C:/Knime/IC Apl Decisões Financeiras 2026-1/Aula 6 - Trabalho/Scatter Plot Linear.png"
path_scatter_RF <- "C:/Knime/IC Apl Decisões Financeiras 2026-1/Aula 6 - Trabalho/Scatter Plot Random Forest.png"

if (!dir.exists(caminho_saida)) dir.create(caminho_saida, recursive = TRUE)

# Função Robusta para limpar o SVG e torná-lo responsivo (Sem quebrar o conteúdo)
ler_svg_limpo <- function(caminho) {
  if (file.exists(caminho)) {
    # Lê o arquivo completo
    svg_txt <- paste(readLines(caminho, warn = FALSE), collapse = "\n")
    
    # 1. Captura apenas a tag de abertura <svg ... >
    tag_match <- regexpr("<svg[^>]*>", svg_txt)
    if (tag_match == -1) return(svg_txt)
    
    tag_abertura <- regmatches(svg_txt, tag_match)
    
    # 2. Extrai largura e altura originais para compor a viewBox
    w_val <- regmatches(tag_abertura, regexec('width="([0-9.]+)(px)?"', tag_abertura))[[1]][2]
    h_val <- regmatches(tag_abertura, regexec('height="([0-9.]+)(px)?"', tag_abertura))[[1]][2]
    
    if (!is.na(w_val) && !is.na(h_val)) {
      # 3. Cria uma tag de abertura nova e limpa, apenas com viewBox e estilo flexível
      # Isso evita que o viewBox entre em tags de círculos e retângulos internos
      nova_tag <- sprintf('<svg viewBox="0 0 %s %s" preserveAspectRatio="xMidYMid meet" style="width:100%%; height:100%%;" xmlns="http://www.w3.org/2000/svg">', w_val, h_val)
      
      # Substitui APENAS a primeira ocorrência (a tag raiz)
      svg_txt <- sub("<svg[^>]*>", nova_tag, svg_txt)
    }
    
    # Remove declarações XML e DOCTYPE que podem causar bugs no HTML5
    svg_txt <- sub("<\\?xml[^>]*\\?>", "", svg_txt)
    svg_txt <- sub("<!DOCTYPE[^>]*>", "", svg_txt)
    
    return(svg_txt)
  } else {
    return("<div style='color:red;'>Erro: Arquivo não encontrado.</div>")
  }
}

# Lendo os gráficos com a nova lógica
svg_scatter <- ler_svg_limpo(path_scatter)
svg_pie     <- ler_svg_limpo(path_pie)

# 2. Construindo o HTML Final
html_content <- paste0('<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Classificação Geoquímica - Mineração Cazanga</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { 
            background-color: #0b0f19; 
            color: #f5f5f5;
            font-family: "Urbanist", sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }

        .presentation-deck {
            width: 1280px;
            height: 720px;
            background-color: #020617;
            position: relative;
            border-radius: 12px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.7);
            border: 1px solid rgba(222, 255, 154, 0.1);
        }

        .slide-container {
            display: none;
            width: 100%;
            height: 100%;
            padding: 50px 80px;
            flex-direction: column;
            position: absolute;
            animation: fadeIn 0.4s ease-out;
        }

        .slide-container.active { display: flex; }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        span { color: #deff9a; font-weight: 700; }
        
        .slide-title { 
            font-size: 44px; 
            margin-bottom: 35px; 
            text-transform: uppercase; 
            letter-spacing: 2px;
            border-left: 6px solid #deff9a;
            padding-left: 20px;
            font-weight: 700;
        }

        .content-area { 
            display: flex; 
            flex-grow: 1; 
            align-items: center; 
            width: 100%;
        }

        .two-column { 
            display: grid; 
            grid-template-columns: 1fr 1.3fr; 
            gap: 50px; 
            width: 100%; 
            align-items: center;
        }

        .bullet-list { list-style: none; }
        .bullet-list li { 
            padding-left: 35px; 
            position: relative; 
            margin-bottom: 22px; 
            font-size: 22px;
            color: #daffde;
        }
        .bullet-list li::before { 
            color: #deff9a; content: "•"; font-size: 45px; left: 0; position: absolute; top: -14px; 
        }

        /* CONTAINER DA IMAGEM: Fundo branco para contraste e sem cortes */
        .image-container { 
            border-radius: 12px; 
            height: 500px; 
            width: 100%;
            background-color: #ffffff;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            overflow: hidden;
        }

        .title-layout { 
            text-align: center; height: 100%; display: flex; flex-direction: column; justify-content: center; 
        }
        .title-layout h1 { font-size: 72px; margin-bottom: 20px; }
        .title-layout p { font-size: 26px; color: #daffde; opacity: 0.8; }

        .footer-tag { 
            color: #deff9a; font-size: 13px; position: absolute; bottom: 25px; right: 80px; text-transform: uppercase; opacity: 0.7; letter-spacing: 1px;
        }

        .controls { position: absolute; bottom: 20px; left: 80px; display: flex; gap: 15px; z-index: 10; }
        .btn-nav {
            background: rgba(222, 255, 154, 0.1); border: 1px solid rgba(222, 255, 154, 0.3);
            color: #deff9a; padding: 10px 20px; border-radius: 6px; cursor: pointer; text-transform: uppercase; font-size: 12px; font-weight: 600;
        }
        .btn-nav:hover { background: #deff9a; color: #020617; transform: translateY(-1px); }
    </style>
</head>
<body>

    <div class="presentation-deck">
        
        <!-- Slide 1 -->
        <div class="slide-container active" id="slide1">
            <div class="title-layout">
                <h1>Classificação Geoquímica <span>Mineração Cazanga</span></h1>
                <p>Exploração de Dados e Machine Learning</p>
                <div style="margin-top: 50px;">
                    <p style="font-size: 18px; opacity: 0.6;">Inteligência Computacional Aplicada às Decisões Financeiras (2026-1)</p>
                    <p style="font-size: 18px; opacity: 0.6;">Jonathan Vargas Silva</p>
                </div>
            </div>
            <div class="footer-tag">Mineração Cazanga - Slide 1 de 3</div>
        </div>

        <!-- Slide 2 -->
        <div class="slide-container" id="slide2">
            <h2 class="slide-title">Tratamento e <span>Clusterização</span></h2>
            <div class="content-area">
                <div class="two-column">
                    <div>
                        <ul class="bullet-list">
                            <li>Dataset: sondagem mineral completa</li>
                            <li>Objetivo: classificar reservas por tipologia</li>
                            <li>Limpeza: correção de ruídos laboratoriais (<span>&lt;0,01</span>)</li>
                            <li>Interpolação: dados faltantes (média local)</li>
                            <li>Filtro: isolamento de <span>CaO, MgO e SiO2</span></li>
                            <li>Modelo: K-Means (k=3) | Distância Euclidiana</li>
                            <li>Auditoria: trava geoquímica via <span>Rule Engine</span></li>
                        </ul>
                    </div>
                    <div class="image-container">', svg_scatter, '</div>
                </div>
            </div>
            <div class="footer-tag">Ajuste de Atração e Densidade - Slide 2 de 3</div>
        </div>

        <!-- Slide 3 -->
        <div class="slide-container" id="slide3">
            <h2 class="slide-title">Resultados e <span>Insights</span></h2>
            <div class="content-area">
                <div class="two-column">
                    <div>
                        <ul class="bullet-list">
                            <li><span>Calcítico (82%)</span>: alto CaO | Industrial</li>
                            <li><span>Dolomítico (8%)</span>: alto MgO | Agrícola</li>
                            <li><span>Silicoso (10%)</span>: alto SiO2 | Agregados</li>
                            <li>Informações claras para planejamento de lavra</li>
                            <li>Redução dos custos operacionais e de transporte</li>
                            <li>Tomadas de decisão baseadas em dashboards</li>
                        </ul>
                    </div>
                    <div class="image-container">', svg_pie, '</div>
                </div>
            </div>
            <div class="footer-tag">Geração de Valor Econômico - Slide 3 de 3</div>
        </div>

        <!-- Navegação -->
        <div class="controls">
            <button class="btn-nav" onclick="changeSlide(-1)">Anterior</button>
            <button class="btn-nav" onclick="changeSlide(1)">Próximo</button>
            <span id="slideCounter" style="color:rgba(218,255,222,0.5); font-size:14px; align-self:center; margin-left:10px;">1 / 3</span>
        </div>

    </div>

    <script>
        let currentSlide = 1;
        const totalSlides = 3;
        function changeSlide(direction) {
            document.getElementById("slide" + currentSlide).classList.remove("active");
            currentSlide += direction;
            if (currentSlide > totalSlides) currentSlide = 1;
            if (currentSlide < 1) currentSlide = totalSlides;
            document.getElementById("slide" + currentSlide).classList.add("active");
            document.getElementById("slideCounter").innerText = currentSlide + " / " + totalSlides;
        }
        document.addEventListener("keydown", (e) => {
            if (e.key === "ArrowRight" || e.key === " ") changeSlide(1);
            if (e.key === "ArrowLeft") changeSlide(-1);
        });
    </script>
</body>
</html>')

# Salvando o arquivo
arquivo_final <- file.path(caminho_saida, "apresentacao_kmeans_calcario.html")
writeLines(html_content, con = arquivo_final, useBytes = TRUE)
cat("Sucesso! Apresentação gerada com gráficos corrigidos em:", arquivo_final, "\n")