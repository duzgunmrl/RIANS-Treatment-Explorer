# presentation.R

presentation_page <- function() {
  
  tagList(
    
    tags$style(HTML("
      .intro-header {
        background: white;
        padding: 28px 32px;
        border-radius: 22px;
        margin-bottom: 25px;
        border-left: 6px solid #6C63FF;
        box-shadow: 0 4px 18px rgba(0,0,0,0.06);
      }

      .intro-header h1 {
        margin-bottom: 6px;
        font-weight: 700;
        color: #222222;
      }

      .intro-header h4 {
        color: #555555;
        font-weight: 400;
        margin-bottom: 0;
      }

      .section-card {
        background: white;
        border-radius: 22px;
        padding: 26px;
        margin-bottom: 25px;
        box-shadow: 0 4px 18px rgba(0,0,0,0.07);
      }

      .section-card h2 {
        margin-bottom: 18px;
        color: #222222;
      }

      .section-card h3 {
        margin-top: 22px;
        color: #333333;
      }

      .step-card {
        background: #F8F9FF;
        border-left: 5px solid #6C63FF;
        padding: 18px 20px;
        border-radius: 16px;
        margin-bottom: 16px;
      }

      .step-card h4 {
        margin-bottom: 8px;
        color: #333333;
      }

      .variable-table td, .variable-table th {
        padding: 10px;
        border-bottom: 1px solid #EAEAEA;
      }

      .info-tag {
        display: inline-block;
        background: #F1F2FF;
        color: #4B45C6;
        padding: 7px 13px;
        border-radius: 999px;
        font-weight: 600;
        margin: 5px;
      }

      .schema-img {
        width: 100%;
        max-width: 850px;
        display: block;
        margin: 22px auto;
        border-radius: 18px;
        box-shadow: 0 4px 18px rgba(0,0,0,0.10);
      }

      .note-box {
        background: #FAFAFA;
        border: 1px solid #E6E6E6;
        border-radius: 18px;
        padding: 18px;
        margin-top: 18px;
      }
    ")),
    
    div(
      class = "intro-header",
      h1("RIANS Simulator"),
      h4("Outil interactif de simulation de la dynamique ATM–ApoE")
    ),
    
    div(
      class = "section-card",
      h2("1. Contexte biologique"),
      
      h3("Le modèle RIANS : comprendre la réponse cellulaire au stress"),
      
      p("Lorsqu’une cellule subit un stress, par exemple un stress oxydant ou une irradiation, son ADN peut être endommagé. La protéine ATM joue alors un rôle central : elle doit rejoindre le noyau afin de participer à la reconnaissance et à la réparation des cassures double-brin de l’ADN."),
      
      p("Le modèle RIANS décrit cette migration d’ATM du cytoplasme vers le noyau. Selon l’efficacité de ce transport, trois profils de réponse cellulaire peuvent être distingués :"),
      
      tags$ul(
        tags$li(strong("Profil radiorésistant : "), "ATM atteint efficacement le noyau, ce qui permet une réparation rapide de l’ADN."),
        tags$li(strong("Profil radiosensible : "), "une partie d’ATM est retenue dans le cytoplasme ou autour du noyau, ce qui ralentit la réparation."),
        tags$li(strong("Profil hyper-radiosensible : "), "ATM ne permet plus une reconnaissance efficace des dommages, ce qui compromet fortement la réponse cellulaire.")
      ),
      
      tags$img(
        src = "PROFIL_REPONSE_CELLULAIRE.png",
        class = "schema-img",
        alt = "Trois profils de réponse cellulaire selon le modèle RIANS"
      ),
      
      h3("Application au contexte Alzheimer"),
      
      p("Dans ce projet, le modèle RIANS est appliqué à un mécanisme potentiel de la maladie d’Alzheimer. L’hypothèse étudiée est qu’ApoE pourrait retenir une partie des monomères ATM dans la région périnucléaire."),
      
      p("Sous stress oxydant chronique, les dimères ATM se dissocient en monomères actifs. Normalement, ces monomères devraient rejoindre le noyau. Cependant, dans le contexte étudié ici, une partie d’entre eux interagit avec ApoE autour du noyau. Cette accumulation progressive peut former une couronne périnucléaire."),
      
      p("Lorsque cette couronne devient dense, elle peut limiter l’entrée d’ATM dans le noyau. La conséquence attendue est une diminution de la disponibilité nucléaire d’ATM, ce qui pourrait altérer la réparation des dommages de l’ADN."),
      
      tags$img(
        src = "MODELE_RIANS.png",
        class = "schema-img",
        alt = "Modèle RIANS appliqué à la maladie d’Alzheimer"
      ),
      
      h3("Objectif de l’interface"),
      
      p("Cette interface permet de reproduire in silico des phénomènes qui seraient difficiles à suivre directement dans le temps en condition expérimentale. L’objectif est de modéliser la formation de la couronne périnucléaire, sa destruction transitoire après irradiation, puis sa possible reformation sous stress chronique."),
      
      p("L’enjeu principal est donc de tester différents scénarios : stress seul, irradiation seule, puis irradiation associée à un traitement. Le but est d’identifier les conditions qui permettent non seulement de casser la couronne, mais aussi de la maintenir désorganisée sur le long terme."),
      
      div(
        class = "note-box",
        strong("Idée générale : "),
        "l’irradiation peut désorganiser temporairement la couronne, tandis que le traitement vise à réduire le stress chronique et à limiter sa reformation."
      ),
      
      h3("Notions clés"),
      
      div(class = "info-tag", "Stress oxydant : stress chronique pouvant favoriser la formation de la couronne"),
      div(class = "info-tag", "ATM : protéine impliquée dans la réparation de l’ADN"),
      div(class = "info-tag", "ApoE : protéine pouvant retenir ATM autour du noyau"),
      div(class = "info-tag", "Couronne périnucléaire : accumulation autour du noyau"),
      div(class = "info-tag", "Traitement : stratégie visant à limiter la reformation de la couronne")
    ),
    
    div(
      class = "section-card",
      h2("Paramètres et variables du modèle"),
      
      tags$table(
        class = "variable-table",
        style = "width:100%;",
        
        tags$thead(
          tags$tr(
            tags$th("Paramètre"),
            tags$th("Signification biologique"),
            tags$th("Unité")
          )
        ),
        
        tags$tbody(
          
          # Stress et irradiation          
          tags$tr(
            tags$td(tags$b("Stress et irradiation")),
            tags$td(""),
            tags$td("")
          ),
          
          tags$tr(
            tags$td("Stress basal"),
            tags$td("Niveau de stress oxydant chronique appliqué au système"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("Amplitude irradiation"),
            tags$td("Intensité maximale de l’irradiation appliquée"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("Moment d'application de l’irradiation"),
            tags$td("Temps auquel l’irradiation est appliquée"),
            tags$td("h")
          ),
          
          tags$tr(
            tags$td("Durée de montée au pic d’irradiation"),
            tags$td("Temps nécessaire pour atteindre le maximum de l’effet d’irradiation"),
            tags$td("h")
          ),
          
          tags$tr(
            tags$td("Durée de décroissance"),
            tags$td("Temps caractéristique de disparition progressive de l’effet d’irradiation"),
            tags$td("h")
          ),
          
          
          # Traitement          
          tags$tr(
            tags$td(tags$b("Traitement")),
            tags$td(""),
            tags$td("")
          ),
          
          tags$tr(
            tags$td("Début du traitement"),
            tags$td("Temps auquel le traitement est introduit dans la simulation"),
            tags$td("h")
          ),
          
          tags$tr(
            tags$td("Temps action traitement"),
            tags$td("Temps caractéristique d’installation de l’effet du traitement"),
            tags$td("h")
          ),
          
          tags$tr(
            tags$td("Effet antioxydant"),
            tags$td("Capacité du traitement à réduire le stress oxydant chronique"),
            tags$td("Sans unité")
          ),
          
          tags$tr(
            tags$td("Effet sur l’entrée nucléaire d’ATM"),
            tags$td("Capacité du traitement à favoriser le passage des ATM vers le noyau"),
            tags$td("Sans unité")
          ),
          
          tags$tr(
            tags$td("Réduction du piégeage ATM–ApoE"),
            tags$td("Capacité du traitement à limiter l'interaction entre ATM et ApoE"),
            tags$td("Sans unité")
          ),
          
          tags$tr(
            tags$td("Réduction des dimères périnucléaires"),
            tags$td("Capacité du traitement à limiter l'accumulation d'ATM dans la région périnucléaire"),
            tags$td("Sans unité")
          ),
          
          tags$tr(
            tags$td("Dispersion périnucléaire"),
            tags$td("Capacité du traitement à favoriser la désorganisation de la couronne périnucléaire"),
            tags$td("Sans unité")
          ),
          
          
          # Paramètres RIANS          
          tags$tr(
            tags$td(tags$b("Paramètres RIANS")),
            tags$td(""),
            tags$td("")
          ),
          
          tags$tr(
            tags$td("k1"),
            tags$td("Vitesse de redimérisation des ATM dans le cytoplasme"),
            tags$td("concentration-1.h-1")
          ),
          
          tags$tr(
            tags$td("k2"),
            tags$td("Migration des ATM monomériques vers la région périnucléaire"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("k3"),
            tags$td("Entrée nucléaire des ATM monomériques"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("k4"),
            tags$td("Formation des complexes ATM–ApoE"),
            tags$td("concentration-1.h-1")
          ),
          
          tags$tr(
            tags$td("k5"),
            tags$td("Formation des dimères ATM périnucléaires"),
            tags$td("concentration-1.h-1")
          ),
          
          tags$tr(
            tags$td("k6"),
            tags$td("Dispersion ou dissociation de la couronne périnucléaire"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("Seuil de couronne périnucléaire"),
            tags$td("Valeur à partir de laquelle la couronne inhibe fortement l’entrée nucléaire"),
            tags$td("Sans unité")
          ),
          
          tags$tr(
            tags$td("Intensité de l’effet inhibiteur"),
            tags$td("Force de l’inhibition exercée par la couronne périnucléaire"),
            tags$td("Sans unité")
          ),
          
          
          # Production / dégradation          
          tags$tr(
            tags$td(tags$b("Production / dégradation")),
            tags$td(""),
            tags$td("")
          ),
          
          tags$tr(
            tags$td("LAMBDA 1 - Production ATM"),
            tags$td("Production globale d’ATM dans le cytoplasme"),
            tags$td("concentration.h-1")
          ),
          
          tags$tr(
            tags$td("LAMBDA 2 - Production ApoE"),
            tags$td("Production d’ApoE libre"),
            tags$td("concentration.h-1")
          ),
          
          tags$tr(
            tags$td("Dégradation ATM cytoplasmique"),
            tags$td("Dégradation naturelle des ATM cytoplasmiques"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("Dégradation ATM nucléaire"),
            tags$td("Dégradation naturelle des ATM présentes dans le noyau"),
            tags$td("h-1")
          ),
          
          tags$tr(
            tags$td("Dégradation ApoE"),
            tags$td("Dégradation naturelle d’ApoE libre"),
            tags$td("h-1")
          ),
          
          
          # Conditions initiales
          
          tags$tr(
            tags$td(tags$b("Conditions initiales")),
            tags$td(""),
            tags$td("")
          ),
          
          tags$tr(
            tags$td("DC"),
            tags$td("Quantité initiale d’ATM sous forme dimérique dans le cytoplasme"),
            tags$td("concentration")
          ),
          
          tags$tr(
            tags$td("MC"),
            tags$td("Quantité initiale d’ATM monomérique dans le cytoplasme"),
            tags$td("concentration")
          ),
          
          tags$tr(
            tags$td("MA"),
            tags$td("Quantité initiale d’ATM monomérique dans la région périnucléaire"),
            tags$td("concentration")
          ),
          
          tags$tr(
            tags$td("MN"),
            tags$td("Quantité initiale d’ATM monomérique dans le noyau"),
            tags$td("concentration")
          ),
          
          tags$tr(
            tags$td("ApoE libre"),
            tags$td("Quantité initiale d’ApoE non complexée"),
            tags$td("concentration")
          ),
          
          tags$tr(
            tags$td("CA"),
            tags$td("Quantité initiale de complexes ATM–ApoE"),
            tags$td("concentration")
          ),
          
          tags$tr(
            tags$td("DA"),
            tags$td("Quantité initiale de dimères ATM dans la région périnucléaire"),
            tags$td("concentration")
          ),
          
          
          # Simulation          
          tags$tr(
            tags$td(tags$b("Simulation")),
            tags$td(""),
            tags$td("")
          ),
          
          tags$tr(
            tags$td("Temps max"),
            tags$td("Durée totale de la simulation"),
            tags$td("h")
          ),
          
          tags$tr(
            tags$td("Pas de temps"),
            tags$td("Intervalle temporel utilisé pour le calcul numérique"),
            tags$td("h")
          )
          
        )
      )
    ),
    
    div(
      class = "section-card",
      h2("2. Prise en main de la simulation"),
      
      p("La partie Simulation permet de construire manuellement un scénario biologique et d’observer son effet sur la dynamique ATM–ApoE. Elle sert à modéliser, dans un cadre in silico, la formation progressive de la couronne périnucléaire, sa destruction après irradiation, puis sa reformation éventuelle selon l’intensité du stress et du traitement."),
      
      div(
        class = "step-card",
        h4("1 — Régler le stress et l’irradiation"),
        p("Le stress basal représente un stress chronique appliqué au système. L’irradiation correspond à un stress transitoire plus intense, appliqué à un temps choisi, qui peut provoquer une rupture temporaire de la couronne.")
      ),
      
      div(
        class = "step-card",
        h4("2 — Régler le traitement"),
        p("Le traitement représente une stratégie combinée. Une partie agit comme un effet antioxydant, en diminuant le stress chronique. Une autre partie favorise l’entrée d’ATM dans le noyau et limite son piégeage autour du noyau.")
      ),
      
      div(
        class = "step-card",
        h4("3 — Lancer la simulation"),
        p("Le bouton RUN SIMULATION calcule l’évolution des différentes populations d’ATM et d’ApoE au cours du temps.")
      ),
      
      div(
        class = "step-card",
        h4("4 — Lire les graphiques"),
        p("Les graphiques permettent de suivre les compartiments biologiques : cytoplasme, région périnucléaire, noyau et ApoE libre. Une couronne élevée indique un piégeage important d’ATM autour du noyau, tandis qu’une augmentation d’ATM nucléaire traduit une meilleure disponibilité pour la réparation de l’ADN.")
      )
    ),
    
    div(
      class = "section-card",
      h2("3. Prise en main de l'aide à la décision"),
      
      p("L'aide à la décision permet de ne plus tester les paramètres un par un. L’objectif est d’explorer automatiquement de nombreuses combinaisons d’irradiation et de traitement afin d’identifier les scénarios les plus favorables."),
      
      div(
        class = "step-card",
        h4("Objectif recherché"),
        p("Identifier les combinaisons capables de désorganiser efficacement la couronne périnucléaire après irradiation tout en limitant sa reformation à long terme.")
      ),
      
      div(
        class = "step-card",
        h4("Paramètres explorés"),
        p("L’algorithme explore différentes amplitudes d’irradiation ainsi que différentes intensités de traitement. Dans l’aide à la décision, le traitement est résumé par une dose globale appliquée simultanément aux antioxydants et aux statines. Cette dose combine plusieurs effets : diminution du stress oxydant, réduction du piégeage ATM–ApoE, limitation de la reformation de la couronne périnucléaire et amélioration du passage des ATM vers le noyau.")
      ),
      
      div(
        class = "step-card",
        h4("Résultat attendu"),
        p("Le scénario optimal correspond à une forte désorganisation initiale de la couronne périnucléaire après irradiation, suivie d’une reformation limitée au cours du temps.")
      )
    )
  )
}