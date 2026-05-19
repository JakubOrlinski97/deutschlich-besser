import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:deutschlich_besser/constants.dart';
import 'package:deutschlich_besser/models/adjective.dart';
import 'package:deutschlich_besser/models/noun.dart';
import 'package:deutschlich_besser/models/verb.dart';
import 'package:deutschlich_besser/models/word.dart';
import 'package:deutschlich_besser/views/article_match.dart';
import 'package:deutschlich_besser/views/make_sentences.dart';
import 'package:deutschlich_besser/views/past_tense.dart';
import 'package:deutschlich_besser/views/set_selection.dart';
import 'package:deutschlich_besser/views/speed_match.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class WidgetWithProps {
  String title;
  Widget widget;

  WidgetWithProps({required this.title, required this.widget});
}

class AppState extends ChangeNotifier {
  late Random random;

  // late Step _currentPage;
  // Step get currentPage => _currentPage;

  late List<String> _availableSets;

  UnmodifiableListView<String> get availableSets =>
      UnmodifiableListView(_availableSets);

  int _selectedSet;

  String get getCurrentSetPath =>
      "assets/set_${_selectedSet.toString().padLeft(2, "0")}";

  late List<Step> stepPages;
  int _currentStep = 0;

  int get currentStep => _currentStep;

  List<Noun> _nouns;
  List<Verb> _verbs;
  List<Adjective> _adjectives;

  UnmodifiableListView<Noun> get nouns => UnmodifiableListView(_nouns);

  UnmodifiableListView<Verb> get verbs => UnmodifiableListView(_verbs);

  UnmodifiableListView<Adjective> get adjectives =>
      UnmodifiableListView(_adjectives);

  List<Noun> currentNouns = [];
  List<Verb> currentVerbs = [];
  List<Adjective> currentAdjectives = [];

  List<int> finishedSteps = [];
  var stepTitles = ["", "", "", ""];

  AppState(this._selectedSet, this._nouns, this._verbs, this._adjectives) {
    _availableSets = ["Set 1 (A-G)", "Set 2 (H-Q)", "Set 3 (Q-Z)"];

    resetSteps();
  }

  static AppState Empty() {
    return AppState(0, List.empty(), List.empty(), List.empty());
  }

  String get getCurrentSetName => _availableSets[_selectedSet];

  Future<void> selectSet(int setIndex) async {
    var now = DateTime.now();
    random = Random(
      DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
        0,
        0,
        0,
      ).millisecondsSinceEpoch + setIndex,
    );

    finishedSteps.clear();

    _selectedSet = setIndex;

    _nouns = await getNounSelection();
    _verbs = await getVerbSelection();
    _adjectives = await getAdjectiveSelection();

    _currentStep = 0;

    resetSteps();

    resetWordsAfterExercise();

    notifyListeners();
  }

  void markStepAsDone(int step) {
    finishedSteps.add(step);
  }

  resetSteps() {
    stepPages = [
      Step(
        title: Text(stepTitles[0]),
        content: ArticleMatch(appState: this),
        isActive: _currentStep == 0,
        stepStyle: StepStyle(
          color: finishedSteps.contains(0) ? Colors.green : null,
        ),
      ),
      Step(
        title: Text(stepTitles[1]),
        content: PastTense(appState: this),
        isActive: _currentStep == 1,
        stepStyle: StepStyle(
          color: finishedSteps.contains(1) ? Colors.green : null,
        ),
      ),
      Step(
        title: Text(stepTitles[2]),
        content: SpeedMatch(appState: this),
        isActive: _currentStep == 2,
        stepStyle: StepStyle(
          color: finishedSteps.contains(2) ? Colors.green : null,
        ),
      ),
      Step(
        title: Text(stepTitles[3]),
        content: MakeSentences(appState: this),
        isActive: _currentStep == 3,
        stepStyle: StepStyle(
          color: finishedSteps.contains(3) ? Colors.green : null,
        ),
      ),
    ];
  }

  void setStep(int step) {
    _currentStep = step;

    FocusManager.instance.primaryFocus?.unfocus();

    resetSteps();

    resetWordsAfterExercise();

    notifyListeners();
  }

  void goToNextStep() {
    markStepAsDone(currentStep);
    setStep(currentStep + 1);
  }

  void resetWordsAfterExercise() {
    currentNouns = nouns.toList();
    currentVerbs = verbs.toList();
    currentAdjectives = adjectives.toList();
  }

  Future<List<Noun>> getNounSelection() async {
    String data = await rootBundle.loadString(
      "${getCurrentSetPath}/nouns.json",
    );
    final jsonResult = jsonDecode(data) as List<dynamic>;

    List<Noun> nouns =
        jsonResult
            .map((item) => Noun.fromJson(item as Map<String, dynamic>))
            .toList();

    nouns = getTodaysSelection<Noun>(nouns);

    return nouns;
  }

  Future<List<Verb>> getVerbSelection() async {
    String data = await rootBundle.loadString(
      "${getCurrentSetPath}/verbs.json",
    );
    final jsonResult = jsonDecode(data) as List<dynamic>;

    List<Verb> verbs =
        jsonResult
            .map((item) => Verb.fromJson(item as Map<String, dynamic>))
            .toList();

    verbs = getTodaysSelection<Verb>(verbs);

    return verbs;
  }

  Future<List<Adjective>> getAdjectiveSelection() async {
    String data = await rootBundle.loadString(
      "${getCurrentSetPath}/adjectives.json",
    );
    final jsonResult = jsonDecode(data) as List<dynamic>;

    List<Adjective> adjectives =
        jsonResult
            .map((item) => Adjective.fromJson(item as Map<String, dynamic>))
            .toList();

    adjectives = getTodaysSelection<Adjective>(adjectives);

    return adjectives;
  }

  List<T> getTodaysSelection<T>(List<T> items) {
    return items.customShuffle(random).take(WORDS_PER_DAY).toList() as List<T>;
  }
}
