import 'package:deutschlich_besser/models/verb.dart';
import 'package:deutschlich_besser/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpeedMatchItem extends StatelessWidget {
  const SpeedMatchItem({
    super.key,
    required this.word,
    required this.isLastSelected,
    required this.isMatchedCorrectly,
    required this.isMatchedIncorrectly,
    required this.isTranslation,
    required this.onPressed,
  });

  final Function() onPressed;

  final Word word;
  final bool isTranslation;

  final bool isLastSelected;
  final bool isMatchedCorrectly;
  final bool isMatchedIncorrectly;

  Color containerColor() {
    if (isLastSelected) {
      return Color.fromRGBO(170, 231, 255, 0.5);
    }
    if (isMatchedCorrectly) {
      return Color.fromRGBO(181, 255, 166, 0.5);
    }
    if (isMatchedIncorrectly) {
      return Color.fromRGBO(255, 171, 171, 0.5);
    }
    return Colors.white;
  }

  Color outlineColor() {
    if (isLastSelected) {
      return Color.fromRGBO(71, 205, 255, 1.0);
    }
    if (isMatchedCorrectly) {
      return Color.fromRGBO(102, 255, 70, 1.0);
    }
    if (isMatchedIncorrectly) {
      return Color.fromRGBO(255, 70, 70, 1.0);
    }
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    var wordToShow = word.word;
    if (word is Verb && (word as Verb).preposition != "") {
      wordToShow += " " + (word as Verb).preposition;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: outlineColor()),
          color: containerColor(),
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          isTranslation ? wordToShow : word.translation,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
          // style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
