import 'package:deutschlich_besser/constants.dart';
import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/models/verb.dart';
import 'package:deutschlich_besser/views/widgets/shake_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PastTense extends StatefulWidget {
  const PastTense({
    super.key,
    required this.appState,
    this.title = "Article match",
    this.lengthOfPause = 3,
  });

  final AppState appState;
  final String title;
  final int lengthOfPause;

  @override
  State<PastTense> createState() => _PastTenseState();
}

class _PastTenseState extends State<PastTense> with TickerProviderStateMixin {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late AnimationController progressController;

  final prepositionController = FixedExtentScrollController(initialItem: 0);

  final presentController = TextEditingController();
  final FocusNode presentFocusNode = FocusNode();

  final praeteritumController = TextEditingController();
  final FocusNode praeteritumFocusNode = FocusNode();

  final perfektController = TextEditingController();
  final FocusNode perfektFocusNode = FocusNode();

  List<String> prepositions = [
    "als",
    "an",
    "auf",
    "aus",
    "bei",
    "durch",
    "für",
    "gegen",
    "gegenüber",
    "in",
    "mit",
    "nach",
    "um",
    "unter",
    "von",
    "vor",
    "zu",
    "über"
  ];

  int selectedPrepositionIndex = 0;

  bool showPresentResult = false;

  bool submitted = false;
  bool wasCorrectPreposition = false;
  bool wasCorrectPresent = false;
  bool wasCorrectPraeteritum = false;
  bool wasCorrectPerfekt = false;

  late Verb currentVerb;
  late List<Verb> currentVerbs;

  bool translationShown = false;

  void loadNextExercise({bool first = false}) {
    selectedPrepositionIndex = 0;
    presentController.clear();
    praeteritumController.clear();
    perfektController.clear();
    formkey.currentState?.validate();

    if (currentVerbs.isEmpty) {
      widget.appState.goToNextStep();
      return;
    }

    setState(() {
      currentVerb = currentVerbs.removeAt(0);
      submitted = false;
      translationShown = false;
      selectedPrepositionIndex = 0;
    });

    if (!first) {
      presentFocusNode.requestFocus();
    }
  }

  void checkCorrectness(String value) {
    formkey.currentState?.validate();
    progressController
      ..value = 0
      ..animateTo(1, duration: Duration(seconds: widget.lengthOfPause))
      ..addListener(() => setState(() {}));

    setState(() {
      submitted = true;
      showPresentResult = false;
      wasCorrectPraeteritum =
          currentVerb.praeteritum == praeteritumController.text;
      wasCorrectPerfekt = currentVerb.perfect == perfektController.text;
      if (!wasCorrectPresent ||
          (currentVerb.preposition != "" && !wasCorrectPreposition) ||
          !wasCorrectPraeteritum ||
          !wasCorrectPerfekt) {
        currentVerbs.add(currentVerb);
      }
    });

    Future.delayed(Duration(seconds: widget.lengthOfPause), loadNextExercise);
  }

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(vsync: this);

    currentVerbs = widget.appState.currentVerbs.toList();
    currentVerbs = currentVerbs.customShuffle(widget.appState.random);
    loadNextExercise(first: true);
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  String? validatePresent(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value != currentVerb.word) {
      print(currentVerb.word);
      return currentVerb.word;
    }
    return null;
  }

  String? validatePraeteritum(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value != currentVerb.praeteritum) {
      return currentVerb.praeteritum;
    }
    return null;
  }

  String? validatePerfekt(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value != currentVerb.perfect) {
      return currentVerb.perfect;
    }
    return null;
  }

  void presentSubmitted() {
    if (currentVerb.word != presentController.text) {
      presentController.text = currentVerb.word;
      setState(() {
        wasCorrectPresent = false;
      });
    } else {
      setState(() {
        wasCorrectPresent = true;
      });
    }
    if (currentVerb.preposition != prepositions[selectedPrepositionIndex]) {
      int correctPrepositionIndex = prepositions.indexOf(
        currentVerb.preposition,
      );
      prepositionController.animateToItem(
        correctPrepositionIndex,
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
      setState(() {
        selectedPrepositionIndex = correctPrepositionIndex;
        wasCorrectPreposition = false;
      });
    } else {
      setState(() {
        wasCorrectPreposition = true;
      });
    }

    setState(() {
      showPresentResult = true;
    });
    praeteritumFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Verben ${widget.appState.currentNouns.length -
                currentVerbs.length} / ${widget.appState.currentVerbs.length}",
          ),

          SizedBox(height: 30),

          Form(
            key: formkey,
            child: Column(
              spacing: 20,
              children: [
                Text(
                  currentVerb.translation,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,
                ),

                Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        onFieldSubmitted: (String? val) {
                          presentSubmitted();
                        },
                        validator: validatePresent,
                        focusNode: presentFocusNode,
                        controller: presentController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                          submitted || showPresentResult
                              ? (wasCorrectPresent
                              ? Colors.green
                              : Colors.red)
                              : null,
                          border: OutlineInputBorder(),
                          hintText: 'Present',
                          isDense: true,
                          errorStyle: TextStyle(height: 0),
                        ),
                      ),
                    ),

                    if (currentVerb.preposition != "")
                      Flexible(
                        flex: 5,
                        child: CupertinoPicker(
                          backgroundColor:
                          submitted || showPresentResult
                              ? (wasCorrectPreposition
                              ? Colors.green
                              : Colors.red)
                              : null,
                          magnification: 1.5,
                          squeeze: 0.5,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          // This sets the initial item.
                          scrollController: prepositionController,
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              selectedPrepositionIndex = selectedItem;
                            });
                          },
                          children: List<Widget>.generate(
                              prepositions.length, (int index,) {
                            return Center(child: Text(prepositions[index]));
                          }),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 0),

                IntrinsicHeight(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          onTapAlwaysCalled: true,
                          onTap: () {
                            if (!showPresentResult &&
                                presentController.text.length > 0) {
                              presentSubmitted();
                            }
                          },
                          onFieldSubmitted: (String? val) {
                            perfektFocusNode.requestFocus();
                          },
                          validator: validatePraeteritum,
                          controller: praeteritumController,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            helperText: ' ',
                            filled: true,
                            fillColor:
                            submitted
                                ? (wasCorrectPraeteritum
                                ? Colors.green
                                : Colors.red)
                                : null,
                            border: OutlineInputBorder(),
                            hintText: 'Präteritum',
                            isDense: true,
                            errorStyle: TextStyle(height: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                IntrinsicHeight(
                  child: Flex(
                    direction: Axis.horizontal,
                    spacing: 20,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          onFieldSubmitted: checkCorrectness,
                          onTap: () {
                            if (!showPresentResult &&
                                presentController.text.length > 0) {
                              presentSubmitted();
                            }
                          },
                          validator: validatePerfekt,
                          controller: perfektController,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            helperText: ' ',
                            filled: true,
                            fillColor:
                            submitted
                                ? (wasCorrectPerfekt
                                ? Colors.green
                                : Colors.red)
                                : null,
                            border: OutlineInputBorder(),
                            hintText: 'Perfekt',
                            isDense: true,
                            errorStyle: TextStyle(height: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          if (submitted)
            LinearProgressIndicator(value: progressController.value),
        ],
      ),
    );
  }
}
