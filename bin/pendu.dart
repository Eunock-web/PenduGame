import 'dart:io';
import 'dart:math';

class HangmanGame {
  final List<String> words;
  late String secretWord;
  Set<String> guessedLetters = {};
  int lives;
  late String displayedWord;
  bool isGameOver = false;
  bool isWinner = false;

  HangmanGame({required this.words, this.lives = 6}) {
    startGame();
  }

  void startGame() {
    final rnd = Random();
    secretWord = words[rnd.nextInt(words.length)].toUpperCase();
    guessedLetters.clear();
    isGameOver = false;
    isWinner = false;
    displayedWord = _maskWord();
  }

  String _maskWord() {
    return secretWord.split('').map((c) => c == ' ' ? ' ' : '_').join('');
  }

  void guessLetter(String input) {
    final letter = input.toUpperCase();

    if (isGameOver) return;
    if (letter.length != 1) return;
    if (!RegExp(r'^[A-Z]$').hasMatch(letter)) return;
    if (guessedLetters.contains(letter)) return;

    guessedLetters.add(letter);

    if (secretWord.contains(letter)) {
      _revealLetters(letter);
    } else {
      lives -= 1;
    }

    _checkGameStatus();
  }

  void _revealLetters(String letter) {
    final secretChars = secretWord.split('');
    final disp = displayedWord.split('');
    for (var i = 0; i < secretChars.length; i++) {
      if (secretChars[i] == letter) disp[i] = letter;
    }
    displayedWord = disp.join('');
  }

  void _checkGameStatus() {
    if (!displayedWord.contains('_')) {
      isWinner = true;
      isGameOver = true;
    } else if (lives <= 0) {
      isWinner = false;
      isGameOver = true;
    }
  }

  String getDisplayedWord() {
    return displayedWord.split('').join(' ');
  }

  void resetGame() {
    lives = 6;
    startGame();
  }
}

void main() {
 final words = [
  'DARTS',
  'PLAGE',
  'NAGER',
  'MAISON',
  'TABLE',
  'CHAIR',
'RIVER',
];

  final game = HangmanGame(words: words, lives: 6);

  while (true) {
    print('\nMot : ${game.getDisplayedWord()}');
    print('Vies restantes : ${'❤' * game.lives}${'🖤' * (6 - game.lives)}');
    print('Lettres utilisées : ${game.guessedLetters.join(", ")}');

    if (game.isGameOver) {
      if (game.isWinner) {
        print('\n🎉 BRAVO ! Tu as trouvé le mot : ${game.secretWord}');
      } else {
        print('\n💀 PERDU ! Le mot était : ${game.secretWord}');
      }

      stdout.write('\nRejouer (O/N) : ');
      final reponse = stdin.readLineSync();
      if (reponse != null && reponse.toUpperCase() == 'O') {
        game.resetGame();
        continue;
      } else {
        print('\nMerci d\'avoir joué !');
        break;
      }
    }

    stdout.write('\nTape une lettre : ');
    final input = stdin.readLineSync();
    if (input == null || input.isEmpty) continue;

    game.guessLetter(input[0]);
}
}

