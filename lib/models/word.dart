

class Word {
  String word;
  String translation;

  Word(this.word, this.translation);

  static Word Empty() {
    return Word("", "");
  }
}