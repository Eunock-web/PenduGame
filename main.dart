import 'dart:io';
import 'dart:math';

/// Classe représentant le jeu du Pendu.
class Pendu {
  final String _motADeviner;
  Set<String> _lettresProposees = {};
  int _erreurs = 0;
  final int _maxErreurs = 5; // Changé à 6 pour correspondre aux 6 parties du corps dans le dessin
  
  // Liste de mots pour le mode ordinateur
  static const List<String> _motsPossibles = [
    'PROGRAMMATION',
    'DART',
    'FLUTTER',
    'DEVELOPPEUR',
    'ORDINATEUR',
    'MODULAIRE',
    'POO'
  ];

  /// Constructeur pour démarrer le jeu.
  Pendu(this._motADeviner);

  // --- Méthodes Statiques pour l'initialisation du jeu ---

  /// Choisit le mot en fonction du mode de jeu.
  static String choisirMot(String? modeChoice) {
    if (modeChoice == '2') {
      return _demanderMotJoueur();
    } else {
      return _choisirMotAleatoire();
    }
  }

  /// Demande un mot au joueur dans le mode ami.
  static String _demanderMotJoueur() {
    stdout.write('\nJoueur 1, entrez le mot à deviner (assurez-vous de bien le cacher ): ');
    String? customWord = stdin.readLineSync()?.toUpperCase();

    // Nettoyer et valider
    if (customWord == null || customWord.isEmpty) {
      print('Mot invalide. Utilisation d\'un mot par défaut.');
      return _motsPossibles[0]; // Mot par défaut en cas d'échec
    }

    // Effacer l'écran pour cacher le mot
    print('\x1B[2J\x1B[0;0H');
    print('Le mot a été choisi ! Joueur 2, à vous de jouer !\n');
    return customWord;
  }

  /// Choisit un mot au hasard dans la liste.
  static String _choisirMotAleatoire() {
    final Random random = Random();
    return _motsPossibles[random.nextInt(_motsPossibles.length)];
  }

  // --- Logique du jeu ---

  /// Lance la boucle principale du jeu.
  void demarrer() {
    print('=== JEU DU PENDU ===\n');

    // Boucle de jeu
    while (!estFini()) {
      _afficherEtatDuJeu();
      _traiterProposition();
    }

    // Affichage du résultat final
    _afficherResultatFinal();
  }

  /// Vérifie si le jeu est terminé (victoire ou défaite).
  bool estFini() {
    return _erreurs >= _maxErreurs || _estMotComplet();
  }

  /// Vérifie si toutes les lettres du mot ont été trouvées.
  bool _estMotComplet() {
    for (int i = 0; i < _motADeviner.length; i++) {
      if (!_lettresProposees.contains(_motADeviner[i])) {
        return false;
      }
    }
    return true;
  }

  /// Construit le mot à afficher avec les lettres trouvées et les underscores.
  String _construireMotAffiche() {
    String displayWord = '';
    for (int i = 0; i < _motADeviner.length; i++) {
      String letter = _motADeviner[i];
      if (_lettresProposees.contains(letter)) {
        displayWord += letter + ' ';
      } else {
        displayWord += '_ ';
      }
    }
    return displayWord.trim();
  }

  /// Affiche l'état actuel du jeu (pendu, mot, erreurs, lettres).
  void _afficherEtatDuJeu() {
    // Effacer l'écran
    stdout.write('\x1B[2J\x1B[0;0H');

    _dessinerPendu();
    print('');

    print('Mot: ${_construireMotAffiche()}');
    print('Erreurs: $_erreurs/$_maxErreurs');
    print('Lettres proposées: ${_lettresProposees.isEmpty ? 'Aucune' : _lettresProposees.join(', ')}');
    print('');
  }

  /// Gère l'entrée du joueur (proposition de lettre ou mot).
  void _traiterProposition() {
    stdout.write('Proposez une lettre ou le mot complet: ');
    String? input = stdin.readLineSync()?.toUpperCase();

    if (input == null || input.isEmpty) {
      return;
    }

    // Tentative de deviner le mot complet
    if (input.length > 1) {
      if (input == _motADeviner) {
        // Ajouter toutes les lettres pour marquer la victoire dans le mot à afficher
        _lettresProposees.addAll(_motADeviner.split('')); 
      } else {
        _erreurs++;
      }
      return;
    }

    // Tentative de deviner une seule lettre
    if (_lettresProposees.contains(input)) {
      print('Cette lettre a déjà été proposée !');
      sleep(Duration(seconds: 1)); // Pause pour lire le message
      return;
    }

    // Ajouter la lettre et vérifier
    _lettresProposees.add(input);
    if (!_motADeviner.contains(input)) {
      _erreurs++;
    }
  }

  /// Affiche le message de victoire ou de défaite.
  void _afficherResultatFinal() {
    _afficherEtatDuJeu(); // Dernier affichage
    
    if (_estMotComplet()) {
      print('\n🎉 Félicitations ! Vous avez trouvé le mot: $_motADeviner');
    } else {
      print('\n💀 Dommage ! Vous avez perdu.');
      print('Le mot était: $_motADeviner\n');
    }
  }
  
  // --- Affichage du Pendu ---

  /// Dessine le pendu en fonction du nombre d'erreurs.
  void _dessinerPendu() {
    print('  +---+');
    print('  |   |');
    
    // Tête (erreur 1)
    print(_erreurs == 1 ? '  O   |' : '      |');
    
    // Corps et bras (erreurs 2, 3, 1)
    if (_erreurs >= 3) {
      print(' /|\\  |'); // Corps + 2 bras
    } else if (_erreurs >= 2) {
      print(' /|   |'); // Corps + bras gauche
    } else if (_erreurs >= 1) {
      print('  |   |'); // Corps seulement
    } else {
      print('      |');
    }
    
    // Jambes (erreurs 5, 4)
    if (_erreurs >= 5) {
      print(' / \\  |'); // 2 jambes
    } else if (_erreurs >= 5) {
      print(' /    |'); // Jambe gauche
    } else {
      print('      |');
    }
    
    print('      |');
    print('=========');
  }
}

// === POINT D'ENTRÉE PRINCIPAL ===
void main() {
  // 1. Initialisation : Demander le mode de jeu
  print('Choisissez un mode de jeu:');
  print('1 - Contre l\'ordinateur');
  print('2 - Contre un ami (vous proposez un mot)');
  stdout.write('Votre choix (1 ou 2): ');
  String? modeChoice = stdin.readLineSync();

  // 2. Choisir le mot à deviner
  String motADeviner = Pendu.choisirMot(modeChoice);

  // 3. Créer et démarrer l'instance du jeu
  Pendu jeu = Pendu(motADeviner);
  jeu.demarrer();
}