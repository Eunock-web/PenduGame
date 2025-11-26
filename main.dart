import 'dart:math';

class Main{
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


    String MotDevine() {
    String motdeviner = " ";
    for (var i = 0; i < 5; i++) {
      motdeviner += genererLettreAleatoire(majuscule: true);
    }
    return motdeviner;
  }

  List<String> motdevinerListe = [];

  void motdevinerListes() {
    motdevinerListe = MotDevine().split("");
  }

  List<String> lettreFinal = [];
  // for(var i = 1; i < motdevinerListe.length; i++) {
  //   lettreFinal.add("*");
  // }
}

void main(){
  Main main = Main();
  main.motdevinerListes();
  print(main.motdevinerListe); 
}