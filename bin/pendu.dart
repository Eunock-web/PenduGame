import 'dart:io';
import 'dart:math';

class HangmanGame {
  final List<String> words;
  late String secretWord;
  Set<String> guessedLetters = {};
  int lives;
  late String displayedWord;
  bool isGameOver = false, isWinner = false;

  HangmanGame({required this.words, this.lives = 6}) {
    startGame();
  }

  void startGame() {
    secretWord = words[Random().nextInt(words.length)].toUpperCase();
    displayedWord = List.filled(secretWord.length, '_').join();
  }

  void guessLetter(String letter) {
    letter = letter.toUpperCase();
    if (guessedLetters.contains(letter) || isGameOver) return;

    guessedLetters.add(letter);

    if (secretWord.contains(letter)) {
      updateDisplayedWord();
      if (!displayedWord.contains('_')) {
        isWinner = true;
        isGameOver = true;
      }
    } else {
      lives--;
      if (lives == 0) isGameOver = true;
    }
  }

  void updateDisplayedWord() {
    displayedWord = secretWord
        .split('')
        .map((c) => guessedLetters.contains(c) ? c : '_')
        .join();
  }
}

void main() {
  final game = HangmanGame(
    words: ['PLAGE', 'TABLE', 'MAISON', 'RIVRE', 'NAGER'],
    lives: 6,
  );

  while (!game.isGameOver) {
    print("\nMot : ${game.displayedWord}");
    print("Vies restantes : ${game.lives}");
    stdout.write("Lettre : ");
    String input = stdin.readLineSync() ?? '';

    if (input.isEmpty || input.length > 1) {
      print("➡️ Entre une seule lettre !");
      continue;
    }

    game.guessLetter(input);
  }

  if (game.isWinner) {
    print("\n🎉 Bravo ! Tu as gagné ! Le mot était : ${game.secretWord}");
  } else {
    print("\n💀 Tu as perdu ! Le mot était : ${game.secretWord}");
  }
}
