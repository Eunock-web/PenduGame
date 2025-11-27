import 'dart:io';
import 'dart:math';

void main() {
  // === INITIALISATION DU JEU ===
  
  print('=== JEU DU PENDU ===\n');
  
  // Demander le mode de jeu
  print('Choisissez un mode de jeu:');
  print('1 - Contre l\'ordinateur');
  print('2 - Contre un ami (vous proposez un mot)');
  stdout.write('Votre choix (1 ou 2): ');
  String? modeChoice = stdin.readLineSync();
  
  String wordToGuess;
  
  if (modeChoice == '2') {
    // Mode ami : demander un mot
    stdout.write('\nJoueur 1, entrez le mot à deviner (il sera caché): ');
    String? customWord = stdin.readLineSync()?.toUpperCase();
    
    if (customWord == null || customWord.isEmpty) {
      print('Mot invalide. Fin du jeu.');
      return;
    }
    
    wordToGuess = customWord;
    
    // Effacer l'écran pour cacher le mot
    print('\x1B[2J\x1B[0;0H');
    print('Le mot a été choisi ! Joueur 2, à vous de jouer !\n');
  } else {
    // Mode ordinateur : choisir un mot aléatoire
    final List<String> words = ['programmation', 'dart', 'flutter', 'developpeur', 'ordinateur'];
    final Random random = Random();
    wordToGuess = words[random.nextInt(words.length)].toUpperCase();
    print('');
  }
  
  // Stocker les lettres déjà proposées par le joueur
  Set<String> guessedLetters = {};
  
  // Nombre d'erreurs commises (6 parties du corps maximum)
  int errors = 0;
  int maxErrors = 6;

  // === BOUCLE PRINCIPALE DU JEU ===
  while (errors < maxErrors) {
    // Effacer l'écran et repositionner le curseur
    stdout.write('\x1B[2J\x1B[0;0H');
    
    // Dessiner le pendu
    _drawHangman(errors);
    print('');
    
    // Construire le mot à afficher (lettres trouvées + underscores)
    String displayWord = '';
    bool wordComplete = true;
    
    for (int i = 0; i < wordToGuess.length; i++) {
      String letter = wordToGuess[i];
      if (guessedLetters.contains(letter)) {
        displayWord += letter + ' ';
      } else {
        displayWord += '_ ';
        wordComplete = false;
      }
    }
    
    // Afficher le mot à deviner
    print('Mot: $displayWord');
    print('Erreurs: $errors/$maxErrors');
    print('Lettres proposées: ${guessedLetters.isEmpty ? 'Aucune' : guessedLetters.join(', ')}');
    print('');

    // Vérifier si le joueur a gagné
    if (wordComplete) {
      print('🎉 Félicitations ! Vous avez trouvé le mot: $wordToGuess');
      return;
    }

    // Demander une lettre ou le mot complet
    stdout.write('Proposez une lettre ou le mot complet: ');
    String? input = stdin.readLineSync()?.toUpperCase();

    // Valider l'entrée du joueur
    if (input == null || input.isEmpty) {
      continue;
    }

    // Si l'entrée contient plusieurs lettres, c'est une tentative de mot complet
    if (input.length > 1) {
      if (input == wordToGuess) {
        stdout.write('\x1B[2J\x1B[0;0H');
        _drawHangman(errors);
        print('\n🎉 Bravo ! Vous avez trouvé le mot: $wordToGuess');
        return;
      } else {
        errors++;
        continue;
      }
    }

    // Vérifier si la lettre a déjà été proposée
    if (guessedLetters.contains(input)) {
      continue;
    }

    // Ajouter la lettre aux lettres proposées
    guessedLetters.add(input);

    // Vérifier si la lettre est dans le mot
    if (!wordToGuess.contains(input)) {
      errors++;
    }
  }

  // === FIN DE PARTIE (DÉFAITE) ===
  stdout.write('\x1B[2J\x1B[0;0H');
  _drawHangman(errors);
  print('\n💀 Dommage ! Vous avez perdu.');
  print('Le mot était: $wordToGuess\n');
}

// === FONCTION POUR DESSINER LE PENDU ===
void _drawHangman(int errors) {
  print('  +---+');
  print('  |   |');
  
  // Tête (erreur 1)
  if (errors >= 1) {
    print('  O   |');
  } else {
    print('      |');
  }
  
  // Corps et bras (erreurs 2, 3, 4)
  if (errors >= 4) {
    print(' /|\\  |'); // Corps + 2 bras
  } else if (errors >= 3) {
    print(' /|   |'); // Corps + bras gauche
  } else if (errors >= 2) {
    print('  |   |'); // Corps seulement
  } else {
    print('      |');
  }
  
  // Jambes (erreurs 5, 6)
  if (errors >= 6) {
    print(' / \\  |'); // 2 jambes
  } else if (errors >= 5) {
    print(' /    |'); // Jambe gauche
  } else {
    print('      |');
  }
  
  print('      |');
  print('=========');
}