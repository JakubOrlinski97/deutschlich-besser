
import 'dart:math';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension ListShuffleExtension on List {
  List<T> customShuffle<T>(Random random) {
    List<T> items = toList() as List<T>;
    // Go through all elements.
    for (var i = length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}

const int WORDS_PER_DAY = 6;
