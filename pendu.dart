// hangman_game.dart
import 'dart:io';
import 'dart:math';

/// Classe représentant le jeu du Pendu.
class Pendu {
  final String motADeviner;
  Set<String> lettresProposees = {};
  int erreurs = 0;
  final int maxErreurs = 5;
  
  static const List<String> motsPossibles = [
    'PROGRAMMATION',
    'DART',
    'FLUTTER',
    'DEVELOPPEUR',
    'ORDINATEUR',
    'MODULAIRE',
    'POO'
  ];

  /// Constructeur pour démarrer le jeu.
  Pendu(this.motADeviner);

  // --- Méthodes Statiques Publiques pour l'Initialisation ---

  /// Demande au joueur de choisir le mot dans le mode ami.
  static String demanderMotJoueur() {
    stdout.write('\nJoueur 1, entrez le mot à deviner (il sera caché): ');
    String? customWord = stdin.readLineSync()?.toUpperCase();

    if (customWord == null || customWord.isEmpty) {
      print('Mot invalide. Utilisation d\'un mot par défaut.');
      return motsPossibles[0];
    }

    // Effacer l'écran pour cacher le mot
    stdout.write('\x1B[2J\x1B[0;0H');
    print('Le mot a été choisi ! Joueur 2, à vous de jouer !\n');
    return customWord;
  }

  /// Choisit un mot au hasard dans la liste.
  static String choisirMotAleatoire() {
    final Random random = Random();
    return motsPossibles[random.nextInt(motsPossibles.length)];
  }

  // --- Logique du Jeu ---

  /// Lance la boucle principale du jeu.
  void demarrer() {
    print('=== JEU DU PENDU ===\n');
    sleep(Duration(seconds: 1)); // Pause pour lire le titre

    while (!estFini()) {
      afficherEtatDuJeu();
      traiterProposition();
    }

    afficherResultatFinal();
  }

  /// Vérifie si le jeu est terminé (victoire ou défaite).
  bool estFini() {
    return erreurs >= maxErreurs || estMotComplet();
  }

  /// Vérifie si toutes les lettres du mot ont été trouvées.
  bool estMotComplet() {
    for (int i = 0; i < motADeviner.length; i++) {
      if (!lettresProposees.contains(motADeviner[i])) {
        return false;
      }
    }
    return true;
  }

  // --- Méthodes d'Affichage et I/O ---
  
  void afficherEtatDuJeu() {
    // Efface l'écran et repositionne le curseur à chaque mise à jour
    stdout.write('\x1B[2J\x1B[0;0H');

    dessinerPendu();
    print('');

    print('Mot: ${construireMotAffiche()}');
    print('Erreurs: $erreurs/$maxErreurs');
    print('Lettres proposées: ${lettresProposees.isEmpty ? 'Aucune' : lettresProposees.join(', ')}');
    print('');
  }

  String construireMotAffiche() {
    String displayWord = '';
    for (int i = 0; i < motADeviner.length; i++) {
      String letter = motADeviner[i];
      if (lettresProposees.contains(letter)) {
        displayWord += letter + ' ';
      } else {
        displayWord += '_ ';
      }
    }
    return displayWord.trim();
  }

  void traiterProposition() {
    stdout.write('Proposez une lettre ou le mot complet: ');
    String? input = stdin.readLineSync()?.toUpperCase();

    if (input == null || input.isEmpty) {
      return;
    }

    // Tentative de deviner le mot complet
    if (input.length > 1) {
      if (input == motADeviner) {
        lettresProposees.addAll(motADeviner.split('')); 
      } else {
        erreurs++;
      }
      return;
    }

    // Tentative de deviner une seule lettre
    if (lettresProposees.contains(input)) {
      print('Cette lettre a déjà été proposée !');
      sleep(Duration(seconds: 1));
      return;
    }

    // Ajouter la lettre et vérifier
    lettresProposees.add(input);
    if (!motADeviner.contains(input)) {
      erreurs++;
    }
  }

  void afficherResultatFinal() {
    // Effacement final et affichage du résultat
    stdout.write('\x1B[2J\x1B[0;0H');
    dessinerPendu();
    
    if (estMotComplet()) {
      print('\n🎉 Félicitations ! Vous avez trouvé le mot: $motADeviner');
    } else {
      print('\n💀 Dommage ! Vous avez perdu.');
      print('Le mot était: $motADeviner\n');
    }
  }
  
  /// Dessine le pendu en fonction du nombre d'erreurs.
  void dessinerPendu() {
    print('  +---+');
    print('  |   |');
    
    // Tête (erreur 1)
    print(erreurs >= 1 ? '  O   |' : '      |');
    
    // Corps et bras (erreurs 2, 3, 1)
    if (erreurs >= 3) {
      print(' /|\\  |');
    } else if (erreurs >= 2) {
      print(' /|   |');
    } else if (erreurs >= 1) {
      print('  |   |');
    } else {
      print('      |');
    }
    
    // Jambes (erreurs 5, 4)
    if (erreurs >= 5) {
      print(' / \\  |');
    } else if (erreurs >= 4) {
      print(' /    |');
    } else {
      print('      |');
    }
    
    print('      |');
    print('=========');
  }
}