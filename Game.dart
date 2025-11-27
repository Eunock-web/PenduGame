import 'dart:io';
import 'dart:math';

class Game {
  String ANSI_CLEAR_SCREEN = '\x1B[2J'; //Effacer l'écran de la console
  String ANSI_HOME_CURSOR =
      '\x1B[H'; //Deplacer curseur à la position d'origine(Hat-Gauche)
  String ANSI_BOLD = '\x1B[1m'; //Texte en gras
  final String nomJeu = "HANGMAN GAME";
  String nomJoueur = "";
  List<String> lettreinitiales = [" * ", " * ", " * ", " * ", " * "];
  static int Score = 5;
  String message = " ";
  String motSecretActuel = "";
  List<String> motSecretListe = [];
  List<String> lettresProposees = [];

  //Fonction pour effacer la console
  void clearConsole() {
    stdout.write(ANSI_CLEAR_SCREEN);
    stdout.write(ANSI_HOME_CURSOR);
  }

  //Fonction pour centrer un texte horizontalement
  String CenterText(String text) {
    /**
       * Cette fonction prends en parametre un texte et calcule la largeur de la console moins la longueur du mot sur deux pour trover la position du texte dans la console
       * @param text
       * @return String
    */

    //Largeur de la console
    final TerminalWidth = stdout.terminalColumns;

    //Longueur du mot
    final TextLength = text.length;

    //Position du texte
    final Position = (TerminalWidth - TextLength) ~/ 2;

    //Créer la chaine d'espacements puis l'ajouter au texte
    final spaces = ' ' * Position;
    return '$spaces$text';
  }

  /**
   * Fonction pour demander une lettre à l'utilisateur
   * @param message
   * @return String
   */
  String prompt(String message) {
    stdout.write(message);

    String? input = stdin.readLineSync();

    while (input?.length != 1) {
      clearConsole();
      print("Veuillez entrer une seule lettre.");
      input = stdin.readLineSync();
    }

    return input!;
  }

  //Fonction pour generer un mot devine
  /**
   * Cette fonction genere un mot devine de 5 lettres
   * @return String
   */
  String MotDevine() {
    String mot = " ";
    for (var i = 0; i < 5; i++) {
      mot += genererLettreAleatoire(majuscule: true);
    }
    return mot;
  }

  List<String> ListMotdevine(String motsimple) {
    return motsimple.split("");
  }

  //Fonction pour generer une lettre aleatoire
  /**
   * Cette fonction genere une lettre aleatoire
   * @param majuscule
   * @return String
   */
  String genererLettreAleatoire({bool majuscule = false}) {
    final random = Random();
    int min, max;

    if (majuscule) {
      min = 65; // 'A'
      max = 90; // 'Z'
    } else {
      min = 97; // 'a'
      max = 122; // 'z'
    }

    // La fonction nextInt(n) génère un nombre entre 0 (inclus) et n (exclus).
    // Donc, pour une plage de 26 lettres, on utilise random.nextInt(26).
    final codeASCII = min + random.nextInt(max - min + 1);

    return String.fromCharCode(codeASCII);
  }

  /**
   * Cette fonction met a jour la lettre deviné dans le cadre du jeu
   * @param lettre
   * @return String
   */
  List<String> updateLettre(String lettre) {
    // Convertir la lettre en majuscule pour comparaison
    String lettreUpperCase = lettre.toUpperCase();

    bool lettreValide = false;

    // Vérifier si la lettre est dans le mot secret
    for (var i = 0; i < motSecretListe.length; i++) {
      if (motSecretListe[i] == lettreUpperCase) {
        lettreinitiales[i] = lettreUpperCase;
        lettreValide = true;
        Score = Score;
      }
    }

    // Si la lettre n'a pas été trouvée, décrémenter le score
    if (!lettreValide) {
      Score = Score - 1;
    }

    // Ajouter la lettre à la liste des lettres proposées
    if (!lettresProposees.contains(lettreUpperCase)) {
      lettresProposees.add(lettreUpperCase);
    }

    return lettreinitiales;
  }

  /**
   * Cette fonction demande le nom du joueur et l'enregistre dans une variable
   * @param nom
   * @return String
   */
  String DemanderNomJoueur(String nom) {
    stdout.write("Veuillez entrez votre nom Joueur : ");
    nom = stdin.readLineSync()!;

    //Si il saisi une espace ou une chaine vide, on redemande
    if (nom.isEmpty) {
      print("Veuillez entrer un nom valide. \n");
      return DemanderNomJoueur(nom);
    }

    return nom;
  }

  void afficherCadre() {
    print(
      CenterText(
        " ----------------------------------------------------------------------------------------------------------------",
      ),
    );
    print(
      CenterText(
        "|                                                                                                                |",
      ),
    );
    print(
      CenterText(
        "|                                                                                                                |",
      ),
    );
    print(
      CenterText(
        "   ${lettreinitiales[0]} ${lettreinitiales[1]} ${lettreinitiales[2]} ${lettreinitiales[3]} ${lettreinitiales[4]}  ",
      ),
    );
    print(
      CenterText(
        "|                                                                                                                |",
      ),
    );
    print(
      CenterText(
        "|                                                                                                                |",
      ),
    );
    print(
      CenterText(
        " ----------------------------------------------------------------------------------------------------------------",
      ),
    );

    afficherScore();
  }

  void afficherScore() {
    print(CenterText("Score : $Score"));
  }

  /**
   * Fonction pour afficherbgvgv le Jeux complet
   */
  void afficherJeux() {
    clearConsole();
    nomJoueur = DemanderNomJoueur(nomJoueur);
    clearConsole();
    print("Joueur:${nomJoueur}");
    stdout.write(ANSI_BOLD);
    sleep(Duration(seconds: 1));
    print(CenterText(nomJeu));
  }

  /**
   * Fonction pour demarrer le jeu
   */
  void DemarrerJeu() {
    sleep(Duration(seconds: 1));
    print(CenterText("Bienvenu dans le jeu"));
    sleep(Duration(seconds: 2));
    clearConsole();
    afficherJeux();
  }

  /**
   * Fonction pour afficher le Menu
   */
  void Menu() {
    print(CenterText(" -----------------------------"));
    print(CenterText("|            Menu             |"));
    print(CenterText(" -----------------------------"));
    print(CenterText("|  1- Demarrer Jeu            |"));
    print(CenterText("|                             |"));
    print(CenterText("|  2- Tutoriel                |"));
    print(CenterText("|                             |"));
    print(CenterText("|  3 -Quitter                 |"));
    print(CenterText(" -----------------------------"));
  }

  /**
   * Fonction pour gerer le menu
   */
  void GestionMenu() {
    print(
      "Veuillez choisir une option. De preferance entrez un nombre entre 1 et 3.",
    );
    String? choix = stdin.readLineSync();

    if (choix == null || choix.isEmpty) {
      print("Veuillez choisir une option valide s'il vous plait.");
      Menu();
      return GestionMenu();
    }

    switch (choix) {
      case "1":
        clearConsole();
        DemarrerJeu();
        break;
      case "2":
        clearConsole();
        print("Tutoriel");
        break;
      case "3":
        clearConsole();
        print("Au revoir");
        sleep(Duration(seconds: 2));
        break;
      default:
        print("Option invalide. Veuillez choisir une option valide.\n");
        clearConsole();
        return GestionMenu();
    }
  }

void LogiqueJeu() {
    // Générer le mot secret une seule fois au début
    motSecretActuel = "LIGHT".toUpperCase();
    motSecretListe = ListMotdevine(motSecretActuel);

    // Réinitialiser les variables du jeu
    lettreinitiales = [" * ", " * ", " * ", " * ", " * "];
    lettresProposees = [];
    Score = 5;

    // Afficher le cadre initial
    afficherCadre();

    // Boucle principale du jeu
    bool partieEnCours = true;
    while (partieEnCours && Score > 0) {
      // Vérifier si le joueur a gagné (tous les * sont remplacés)
      bool gagne = true;
      for (var i = 0; i < lettreinitiales.length; i++) {
        if (lettreinitiales[i] == " * ") {
          gagne = false;
          break;
        }
      }

      if (gagne) {
        clearConsole();
        sleep(Duration(seconds: 2));
        afficherCadre();
        print(
          CenterText("🎉 Bravo! Tu as gagné! Le mot était: $motSecretActuel"),
        );
        sleep(Duration(seconds: 3));
        partieEnCours = false;
        break;
      }

      // Demander une lettre au joueur
      String? lettreProposee = prompt("Proposez une lettre: \t");

      // Valider que c'est une seule lettre
      while (lettreProposee == null || lettreProposee.length != 1) {
        clearConsole();
        print("Veuillez entrer une seule lettre.");
        afficherCadre();
        lettreProposee = prompt("Proposez une lettre: \t");
      }

      // Mettre à jour le jeu avec la lettre proposée
      updateLettre(lettreProposee);

      // Afficher l'état actuel du jeu
      clearConsole();
      afficherCadre();
    }

    // Si le score atteint 0, le joueur a perdu
    if (Score == 0) {
      print(CenterText("💀 Perdu! Le mot était: $motSecretActuel"));
      sleep(Duration(seconds: 3));
    }
  }
  void LancerJeu() {
    bool continuer = true;

    while (continuer) {
      clearConsole();
      Menu();

      String? choix = stdin.readLineSync();

      if (choix == null || choix.isEmpty) {
        print("Veuillez choisir une option valide s'il vous plait.");
        continue;
      }

      switch (choix) {
        case "1":
          clearConsole();
          DemarrerJeu();
          sleep(Duration(seconds: 2));
          LogiqueJeu();
          break;

        case "2":
          clearConsole();
          print(CenterText("=== TUTORIEL ==="));
          print(CenterText("Bienvenue dans Hangman!"));
          print(CenterText("Vous devez deviner un mot de 5 lettres."));
          print(CenterText("Vous avez 5 tentatives."));
          print(CenterText("Entrez une lettre à chaque tour."));
          print(CenterText("Si la lettre est correcte, elle s'affiche."));
          print(CenterText("Si elle est fausse, vous perdez une tentative."));
          print(CenterText("Bonne chance!"));
          sleep(Duration(seconds: 5));
          break;

        case "3":
          clearConsole();
          print(CenterText("Au revoir!"));
          sleep(Duration(seconds: 1));
          continuer = false;
          break;

        default:
          print(
            "Option invalide. Veuillez choisir une option valide (1, 2 ou 3).",
          );
          sleep(Duration(seconds: 2));
      }
    }
  }
}

void main() {
  Game Jeu = new Game();
  Jeu.LancerJeu();
}
