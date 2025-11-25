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

}