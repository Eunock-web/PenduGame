import 'dart:io';

class Game {
  String ANSI_CLEAR_SCREEN = '\x1B[2J'; //Effacer l'écran de la console
  String ANSI_HOME_CURSOR = '\x1B[H'; //Deplacer curseur à la position d'origine(Hat-Gauche)
  String ANSI_BOLD = '\x1B[1m'; //Texte en gras
  final String nomJeu = "HANGMAN";
  String nomJoueur = "";

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

  /**
   * Fonction pour afficher le Jeux complet
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

}