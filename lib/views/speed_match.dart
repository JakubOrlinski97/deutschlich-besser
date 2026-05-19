import 'dart:async';

import 'package:deutschlich_besser/constants.dart';
import 'package:deutschlich_besser/models/adjective.dart';
import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/models/exercise.dart';
import 'package:deutschlich_besser/models/noun.dart';
import 'package:deutschlich_besser/models/verb.dart';
import 'package:deutschlich_besser/models/word.dart';
import 'package:deutschlich_besser/views/widgets/speed_match_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpeedMatch extends StatefulWidget {
  const SpeedMatch({
    super.key,
    required this.appState,
    this.title = "Speed match",
    this.lengthOfPause = 2,
  });

  final AppState appState;
  final String title;
  final int lengthOfPause;

  @override
  State<SpeedMatch> createState() => _SpeedMatchState();
}

class _SpeedMatchState extends State<SpeedMatch> with TickerProviderStateMixin {
  late AnimationController progressController;

  static int wordsPerRound = 6;
  List<Word> wordsForRound = List.filled(wordsPerRound * 2, Word.Empty());
  List<int> translationIndexes = [];

  int? lastSelected;
  List<Word> matched = [];

  List<int> matchedIncorrectly = [];

  bool submitted = false;
  int board = 0;
  int boardsTotal = 0;

  List<Word> currentWords = [];

  void loadNextExercise() {
    setState(() {
      submitted = false;
      board += 1;
      boardsTotal = ((
          widget.appState.currentAdjectives.length +
              widget.appState.currentNouns.length +
              widget.appState.currentVerbs.length
      ) / wordsPerRound).floor();

      wordsForRound = List.filled(wordsPerRound * 2, Word.Empty());
      matched = List.empty(growable: true);
      translationIndexes = List.empty(growable: true);
      lastSelected = null;

      List<int> originalIndexes = [];

      for (int i = 0; i < wordsPerRound; i++) {
        if (currentWords.isEmpty) {
          widget.appState.goToNextStep();
          return;
        }

        Word randWord = currentWords.removeAt(0);

        int indexForOriginal = 0;
        do {
          indexForOriginal = widget.appState.random.nextInt(wordsPerRound * 2);
        } while (translationIndexes.contains(indexForOriginal) ||
            originalIndexes.contains(indexForOriginal));
        originalIndexes.add(indexForOriginal);

        wordsForRound[indexForOriginal] = randWord;

        int indexForTranslation = 0;
        do {
          indexForTranslation = widget.appState.random.nextInt(
            wordsPerRound * 2,
          );
        } while (translationIndexes.contains(indexForTranslation) ||
            originalIndexes.contains(indexForTranslation));
        translationIndexes.add(indexForTranslation);

        wordsForRound[indexForTranslation] = randWord;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(vsync: this);

    currentWords.addAll(widget.appState.currentVerbs.toList().customShuffle(widget.appState.random));
    currentWords.addAll(widget.appState.currentNouns.toList().customShuffle(widget.appState.random));
    currentWords.addAll(widget.appState.currentAdjectives.toList().customShuffle(widget.appState.random));

    currentWords = currentWords.customShuffle(widget.appState.random) as List<Word>;

    loadNextExercise();
  }

  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  void resetIncorrect() {
    setState(() {
      matchedIncorrectly = List.empty(growable: true);
    });
  }

  onButtonClicked(int index) {
    setState(() {
      if (matched.contains(index)) {
        return;
      }

      if (lastSelected != null) {
        if (index == lastSelected) {
          // deselect current item
          lastSelected = null;
          return;
        }

        if (wordsForRound[lastSelected!].word == wordsForRound[index].word) {
          // was correct
          matched.add(wordsForRound[index]);
        } else {
          //was incorrect
          matchedIncorrectly.add(index);
          matchedIncorrectly.add(lastSelected!);

          Future.delayed(Duration(seconds: 1), resetIncorrect);
        }

        lastSelected = null;
      } else {
        // first selected
        lastSelected = index;
      }
    });
    if (matched.length == wordsPerRound) {
      setState(() {
        submitted = true;
      });

      progressController
        ..value = 0
        ..animateTo(1, duration: Duration(seconds: widget.lengthOfPause))
        ..addListener(() => setState(() {}));

      Future.delayed(Duration(seconds: 2), loadNextExercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Brett ${board} / ${boardsTotal}"),

        GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(wordsPerRound * 2, (int wordIndex) {
            bool isTranslation = translationIndexes.contains(wordIndex);

            return SpeedMatchItem(
              onPressed: () => onButtonClicked(wordIndex),
              word: wordsForRound[wordIndex],
              isTranslation: isTranslation,
              isLastSelected: lastSelected == wordIndex,
              isMatchedCorrectly: matched.contains(wordsForRound[wordIndex]),
              isMatchedIncorrectly: matchedIncorrectly.contains(wordIndex),
            );
          }),
        ),

        SizedBox(height: 10,),

        if (submitted)
          LinearProgressIndicator(value: progressController.value),
      ],
    );
  }
}
