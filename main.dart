import 'dart:io';
import 'dart:math';

// ============================================================================
// MODÈLES
// ============================================================================

class Word {
  final String _mot;
  final List<bool> _lettresDevinees;
  
  Word(String mot) 
    : _mot = mot.toLowerCase(),
      _lettresDevinees = List.filled(mot.length, false) {
    if (mot.length != 5) {
      throw ArgumentError('Le mot doit contenir exactement 5 lettres');
    }
  }
  
  String get mot => _mot;
  
  bool devinerLettre(String lettre) {
    lettre = lettre.toLowerCase();
    bool trouve = false;
    
    for (int i = 0; i < _mot.length; i++) {
      if (_mot[i] == lettre && !_lettresDevinees[i]) {
        _lettresDevinees[i] = true;
        trouve = true;
      }
    }
    
    return trouve;
  }
  
  String afficherMot() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < _mot.length; i++) {
      if (_lettresDevinees[i]) {
        sb.write(_mot[i].toUpperCase());
      } else {
        sb.write('_');
      }
      if (i < _mot.length - 1) sb.write(' ');
    }
    return sb.toString();
  }
  
  bool estComplet() {
    return _lettresDevinees.every((devinees) => devinees);
  }
  
  int get longueur => _mot.length;
}

class Player {
  final String nom;
  final Set<String> lettresEssayees;
  int erreurs;
  
  Player(this.nom) 
    : lettresEssayees = {},
      erreurs = 0;
  
  bool aEssayeLettre(String lettre) {
    return lettresEssayees.contains(lettre.toLowerCase());
  }
  
  void ajouterLettre(String lettre) {
    lettresEssayees.add(lettre.toLowerCase());
  }
  
  void incrementerErreur() {
    erreurs++;
  }
}

class Dictionary {
  static final List<String> _mots = [
    'pizza',
    'ocean',
    'livre',
    'avion',
    'plage'
  ];
  
  static String obtenirMotAleatoire() {
    final random = Random();
    return _mots[random.nextInt(_mots.length)];
  }
}

// ============================================================================
// LOGIQUE MÉTIER
// ============================================================================

class InputService {
  static String lireLettre(String prompt) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    
    if (input == null || input.isEmpty) {
      return '';
    }
    
    return input[0].toLowerCase();
  }
  
  static String lireMotSecret() {
    print('\n🔒 Entrez le mot secret (5 lettres) :');
    print('(Le mot ne sera pas visible à l\'écran)');
    
    stdin.echoMode = false;
    String? mot1 = stdin.readLineSync();
    stdin.echoMode = true;
    
    if (mot1 == null || mot1.length != 5) {
      print('\n❌ Le mot doit contenir exactement 5 lettres.');
      return '';
    }
    
    print('\n🔒 Confirmez le mot secret :');
    stdin.echoMode = false;
    String? mot2 = stdin.readLineSync();
    stdin.echoMode = true;
    
    if (mot1 != mot2) {
      print('\n❌ Les deux mots ne correspondent pas.');
      return '';
    }
    
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(mot1)) {
      print('\n❌ Le mot doit contenir uniquement des lettres.');
      return '';
    }
    
    print('\n✅ Mot secret enregistré !');
    return mot1.toLowerCase();
  }
  
  static void effacerEcran() {
    for (int i = 0; i < 50; i++) {
      print('');
    }
  }
  
  static bool estLettreValide(String lettre) {
    return lettre.length == 1 && RegExp(r'^[a-zA-Z]$').hasMatch(lettre);
  }
}

class GameService {
  static const int maxErreurs = 6;
  
  final Word motSecret;
  final Player joueur;
  
  GameService(this.motSecret, this.joueur);
  
  void afficherEtat() {
    print('\n' + '='*40);
    print('Mot à deviner : ${motSecret.afficherMot()}');
    print('Erreurs : ${joueur.erreurs}/$maxErreurs');
    
    if (joueur.lettresEssayees.isNotEmpty) {
      List<String> lettresTriees = joueur.lettresEssayees.toList()..sort();
      print('Lettres essayées : ${lettresTriees.join(', ').toUpperCase()}');
    }
    print('='*40);
  }
  
  bool tourDeJeu() {
    String lettre = InputService.lireLettre('\nProposez une lettre : ');
    
    if (!InputService.estLettreValide(lettre)) {
      print('❌ Veuillez entrer une lettre valide (a-z).');
      return true;
    }
    
    if (joueur.aEssayeLettre(lettre)) {
      print('⚠️  Vous avez déjà essayé cette lettre.');
      return true;
    }
    
    joueur.ajouterLettre(lettre);
    
    if (motSecret.devinerLettre(lettre)) {
      print('✅ Bonne lettre !');
    } else {
      joueur.incrementerErreur();
      print('❌ Mauvaise lettre !');
    }
    
    return !estPartieTerminee();
  }
  
  bool estPartieTerminee() {
    return motSecret.estComplet() || joueur.erreurs >= maxErreurs;
  }
  
  bool aGagne() {
    return motSecret.estComplet();
  }
  
  void afficherResultat() {
    print('\n' + '='*40);
    if (aGagne()) {
      print('🎉 FÉLICITATIONS ${joueur.nom.toUpperCase()} !');
      print('Vous avez trouvé le mot : ${motSecret.mot.toUpperCase()}');
      print('Nombre d\'erreurs : ${joueur.erreurs}/$maxErreurs');
    } else {
      print('💀 GAME OVER ${joueur.nom.toUpperCase()} !');
      print('Le mot était : ${motSecret.mot.toUpperCase()}');
    }
    print('='*40);
  }
}

// ============================================================================
// CONTRÔLEUR
// ============================================================================

class GameController {
  final GameService _gameService;
  final String _modeJeu;
  
  GameController._(this._gameService, this._modeJeu);
  
  static GameController creerModeVsCPU() {
    print('\n╔════════════════════════════════╗');
    print('║   MODE: UTILISATEUR vs CPU     ║');
    print('╚════════════════════════════════╝\n');
    
    String motAleatoire = Dictionary.obtenirMotAleatoire();
    Word motSecret = Word(motAleatoire);
    Player joueur = Player('Joueur');
    
    print('🤖 L\'ordinateur a choisi un mot de 5 lettres.');
    print('À vous de le deviner !\n');
    
    GameService service = GameService(motSecret, joueur);
    return GameController._(service, 'CPU');
  }
  
  static GameController creerModeDeuxJoueurs() {
    print('\n╔════════════════════════════════╗');
    print('║   MODE: JOUEUR 1 vs JOUEUR 2   ║');
    print('╚════════════════════════════════╝\n');
    
    print('👤 JOUEUR 1 : C\'est à vous de choisir le mot secret !');
    
    String motSecret = '';
    while (motSecret.isEmpty) {
      motSecret = InputService.lireMotSecret();
      if (motSecret.isEmpty) {
        print('Veuillez réessayer.\n');
      }
    }
    
    InputService.effacerEcran();
    
    print('\n╔════════════════════════════════╗');
    print('║   JOUEUR 2 : À vous de jouer ! ║');
    print('╚════════════════════════════════╝\n');
    
    print('Le Joueur 1 a choisi un mot de 5 lettres.');
    print('À vous de le deviner !\n');
    
    Word mot = Word(motSecret);
    Player joueur = Player('Joueur 2');
    
    GameService service = GameService(mot, joueur);
    return GameController._(service, 'PVP');
  }
  
  void demarrer() {
    print('🎮 La partie commence !\n');
    
    while (true) {
      _gameService.afficherEtat();
      
      if (!_gameService.tourDeJeu()) {
        break;
      }
    }
    
    _gameService.afficherResultat();
  }
}

// ============================================================================
// POINT D'ENTRÉE PRINCIPAL
// ============================================================================

void main() {
  print('╔════════════════════════════════╗');
  print('║     JEU DU PENDU - 5 LETTRES   ║');
  print('╚════════════════════════════════╝\n');
  
  bool continuer = true;
  
  while (continuer) {
    print('Choisissez le mode de jeu :');
    print('1. Utilisateur vs CPU');
    print('2. Utilisateur 1 vs Utilisateur 2');
    print('0. Quitter');
    print('\nVotre choix : ');
    
    String? choix = stdin.readLineSync();
    
    if (choix == '1') {
      final game = GameController.creerModeVsCPU();
      game.demarrer();
    } else if (choix == '2') {
      final game = GameController.creerModeDeuxJoueurs();
      game.demarrer();
    } else if (choix == '0') {
      continuer = false;
    } else {
      print('\n❌ Choix invalide. Veuillez choisir 1, 2 ou 0.\n');
      continue;
    }
    
    if (continuer && (choix == '1' || choix == '2')) {
      print('\n\nVoulez-vous rejouer ? (o/n) : ');
      String? reponse = stdin.readLineSync()?.toLowerCase();
      continuer = reponse == 'o' || reponse == 'oui';
      print('\n');
    }
  }
  
  print('╔════════════════════════════════╗');
  print('║  Merci d\'avoir joué ! À bientôt ║');
  print('╚════════════════════════════════╝');
}