// main.dart
import 'dart:io';
// Importe la classe Pendu à partir du fichier créé
import 'pendu.dart'; 

void main() {
  // 1. Initialisation : Demander le mode de jeu
  print('Choisissez un mode de jeu:');
  print('1 - Contre l\'ordinateur');
  print('2 - Contre un ami (vous proposez un mot)');
  stdout.write('Votre choix (1 ou 2): ');
  String? modeChoice = stdin.readLineSync();

  // 2. Détermination du mot
  String motADeviner;
  
  if (modeChoice == '2') {
    motADeviner = Pendu.demanderMotJoueur();
  } else {
    motADeviner = Pendu.choisirMotAleatoire();
  }

  // 3. Créer et démarrer l'instance du jeu
  Pendu jeu = Pendu(motADeviner);
  jeu.demarrer();
}