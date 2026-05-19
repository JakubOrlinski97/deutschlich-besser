import 'package:deutschlich_besser/constants.dart';
import 'package:deutschlich_besser/models/adjective.dart';
import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/models/enums.dart';
import 'package:deutschlich_besser/models/exercise.dart';
import 'package:deutschlich_besser/models/noun.dart';
import 'package:deutschlich_besser/models/subject.dart';
import 'package:deutschlich_besser/models/verb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MakeSentences extends StatefulWidget {
  const MakeSentences({
    super.key,
    required this.appState,
    this.lengthOfPause = 5,
  });

  final AppState appState;
  final int lengthOfPause;

  @override
  State<MakeSentences> createState() => _MakeSentencesState();
}

class _MakeSentencesState extends State<MakeSentences>
    with TickerProviderStateMixin {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late AnimationController progressController;

  final verbController = TextEditingController();
  final articleController = TextEditingController();
  final adjectiveController = TextEditingController();
  final FocusNode verbFocusNode = FocusNode();
  final FocusNode articleFocusNode = FocusNode();
  final FocusNode adjectiveFocusNode = FocusNode();

  int points = 0;

  Exercise exercise = Exercise.Empty();

  bool submitted = false;
  bool wasCorrectVerb = false;
  bool wasCorrectArticle = false;
  bool wasCorrectAdjective = false;

  void loadNextExercise({bool first = false}) {
    verbController.clear();
    articleController.clear();
    adjectiveController.clear();
    formkey.currentState?.validate();

    Exercise newEx;

    if (currentVerbs.isEmpty) {
      widget.appState.goToNextStep();
      return;
    } else {
      newEx = getNewExercise();
    }


    setState(() {
      exercise = newEx;

      submitted = false;
      wasCorrectVerb = false;
      wasCorrectArticle = false;
      wasCorrectAdjective = false;
    });

    if (newEx.correctArticle.startsWith("ein")) {
      articleController.text = "ein";
    }

    if (!first) {
      verbFocusNode.requestFocus();
    }
  }

  void checkCorrectness(String value) {
    if (submitted) {
      return;
    }

    formkey.currentState?.validate();
    progressController
      ..value = 0
      ..animateTo(1, duration: Duration(seconds: widget.lengthOfPause))
      ..addListener(() => setState(() {}));

    setState(() {
      submitted = true;
      if (exercise.tense == Tense.Present) {
        wasCorrectVerb = exercise.verb.root == verbController.text;
      } else if (exercise.tense == Tense.Praeteritum) {
        wasCorrectVerb = exercise.verb.praeteritum == verbController.text;
      }
      wasCorrectArticle = exercise.correctArticle == articleController.text;
      wasCorrectAdjective = exercise.adjective.word + exercise.correctEnding == adjectiveController.text;

      if (wasCorrectArticle && wasCorrectAdjective) {
        points++;
      }

      if (!wasCorrectVerb || !wasCorrectAdjective || !wasCorrectArticle) {
        currentVerbs.add(exercise.verb);
        currentNouns.add(exercise.noun);
        currentAdjectives.add(exercise.adjective);

        currentVerbs = currentVerbs.customShuffle(widget.appState.random);
        currentNouns = currentNouns.customShuffle(widget.appState.random);
        currentAdjectives = currentAdjectives.customShuffle(widget.appState.random);
      }
    });

    Future.delayed(Duration(seconds: widget.lengthOfPause), loadNextExercise);
  }

  @override
  void initState() {
    super.initState();

    currentVerbs = widget.appState.currentVerbs.toList().customShuffle(widget.appState.random);
    currentNouns = widget.appState.currentNouns.toList().customShuffle(widget.appState.random);
    currentAdjectives = widget.appState.currentAdjectives.toList().customShuffle(widget.appState.random);

    progressController = AnimationController(vsync: this);

    loadNextExercise(first: true);
  }

  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  void onArticleChanged(String value) {
    if ([
      "der",
      "die",
      "das",
      "den",
      "dem",
      "einer",
      "einen",
      "einem",
    ].contains(value)) {
      adjectiveFocusNode.requestFocus();
    }
  }

  String? validateVerb(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    if (exercise.tense == Tense.Present) {
      if (value != exercise.verb.root) {
        return exercise.verb.root;
      }
    } else if (exercise.tense == Tense.Praeteritum) {
      if (value != exercise.verb.praeteritum) {
        return exercise.verb.praeteritum;
      }
    }
    return null;
  }

  String? validateArticle(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    if (value != exercise.correctArticle) {
      return exercise.correctArticle;
    }
    return null;
  }

  String? validateAdjective(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    var correct = exercise.adjective.word + exercise.correctEnding;
    if (value != correct) {
      return correct;
    }
    return null;
  }

  late List<Verb> currentVerbs;
  late List<Noun> currentNouns;
  late List<Adjective> currentAdjectives;

  Exercise getNewExercise() {
    Verb verb = currentVerbs.removeAt(0);
    Noun noun = currentNouns.removeAt(0);
    Adjective adjective = currentAdjectives.removeAt(0);

    bool isDefinite = true;
    if (widget.appState.random.nextDouble() > 0.5) {
      isDefinite = false;
    }

    Tense tense = Tense.Present;
    Subject subject = Subject(person: Person.First, number: Number.Singular);
    if (widget.appState.random.nextDouble() > 0.0) {
      tense = Tense.Praeteritum;
      subject = Subject(person: Person.First, number: Number.Singular);
    }
    if (verb.praeteritum == "") {
      tense = Tense.Present;
      subject = Subject(person: Person.First, number: Number.Plural);
    }

    String article = noun.adjustArticleToCase(
      verb.caseOfSpeech,
      isDefinite,
    );

    String ending = noun.getAdjectiveEnding(
      verb.caseOfSpeech,
      isDefinite,
    );

    return Exercise(
      subject: subject,
      verb: verb,
      tense: tense,
      adjective: adjective,
      noun: noun,
      splitSuffix: verb.separable,
      correctArticle: article,
      correctEnding: ending,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Satz ${widget.appState.currentVerbs.length - currentVerbs.length} / ${widget.appState.currentVerbs.length}'),

          SizedBox(height: 20),

          SelectionArea(
            child: Form(
              key: formkey,
              child: IntrinsicHeight(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 20,
                  // runAlignment: WrapAlignment.spaceBetween,
                  runSpacing: 10,
                  children: [
                    Text(
                      exercise.subject.personal.capitalize(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        onFieldSubmitted: checkCorrectness,
                        validator: validateVerb,
                        focusNode: verbFocusNode,
                        controller: verbController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          helperText: exercise.verb.translation,
                          filled: true,
                          fillColor:
                          submitted
                              ? (wasCorrectVerb
                              ? Colors.green
                              : Colors.red)
                              : null,
                          border: OutlineInputBorder(),
                          hintText: exercise.tense.name,
                          isDense: true,
                        ),
                      ),
                    ),

                    if (exercise.verb.reflexiv)
                      Text(
                        exercise.subject.reflexive,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    if (exercise.verb.someoneElse != "")
                      Text(
                        exercise.verb.someoneElse,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                    Text(
                      exercise.verb.preposition,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        onFieldSubmitted: checkCorrectness,
                        validator: validateArticle,
                        focusNode: articleFocusNode,
                        controller: articleController,
                        onChanged: onArticleChanged,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          helperText: ' ',
                          filled: true,
                          fillColor:
                              submitted
                                  ? (wasCorrectArticle
                                      ? Colors.green
                                      : Colors.red)
                                  : null,
                          border: OutlineInputBorder(),
                          hintText: '',
                          isDense: true,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        validator: validateAdjective,
                        onFieldSubmitted: checkCorrectness,
                        focusNode: adjectiveFocusNode,
                        controller: adjectiveController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          helperText: exercise.adjective.translation,
                          filled: true,
                          fillColor:
                              submitted
                                  ? (wasCorrectAdjective
                                      ? Colors.green
                                      : Colors.red)
                                  : null,
                          contentPadding: EdgeInsets.fromLTRB(
                            0,
                            10,
                            0,
                            10,
                          ),
                          border: OutlineInputBorder(),
                          hintText: '',
                          isDense: true,
                          errorStyle: TextStyle(height: 0),
                        ),
                      ),
                    ),

                    Text(
                      exercise.noun.root,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    if (exercise.splitSuffix.isNotEmpty)
                      Text(
                        exercise.splitSuffix,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (submitted)
            LinearProgressIndicator(value: progressController.value),
        ],
      ),
    );
  }
}
