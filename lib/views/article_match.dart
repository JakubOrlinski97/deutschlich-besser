import 'package:deutschlich_besser/models/adjective.dart';
import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/models/exercise.dart';
import 'package:deutschlich_besser/models/noun.dart';
import 'package:deutschlich_besser/models/verb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/word.dart';

class ArticleMatch extends StatefulWidget {
  const ArticleMatch({
    super.key,
    required this.appState,
    this.title = "Article match",
    this.lengthOfPause = 1,
  });

  final AppState appState;
  final String title;
  final int lengthOfPause;

  @override
  State<ArticleMatch> createState() => _ArticleMatchState();
}

class _ArticleMatchState extends State<ArticleMatch>
    with TickerProviderStateMixin {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late AnimationController progressController;

  final articleController = TextEditingController();
  final FocusNode articleFocusNode = FocusNode();

  bool submitted = false;
  bool wasCorrectArticle = false;

  int points = 0;
  int nounsLeft = 0;

  late Noun currentNoun;
  late List<Noun> currentNouns;

  bool translationShown = false;

  void loadNextExercise({bool first = false}) {
    articleController.clear();
    formkey.currentState?.validate();

    if (currentNouns.isEmpty) {
      widget.appState.goToNextStep();
      return;
    }

    setState(() {
      nounsLeft = currentNouns.length;
      currentNoun = currentNouns.removeAt(0);
      submitted = false;
      translationShown = false;
    });

    if (!first) {
      articleFocusNode.requestFocus();
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
      wasCorrectArticle = currentNoun.article == articleController.text;
      if (!wasCorrectArticle) {
        currentNouns.add(currentNoun);
      }
      if (wasCorrectArticle) {
        points++;
      }
    });

    Future.delayed(Duration(seconds: widget.lengthOfPause), loadNextExercise);
  }

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(vsync: this);

    currentNouns = widget.appState.currentNouns.toList();
    loadNextExercise(first: true);
  }

  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  String? validateArticle(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    if (value != currentNoun.article) {
      return currentNoun.article;
    }
    return null;
  }

  void onArticleChanged(String value) {
    if ([
      "der",
      "die",
      "das",
    ].contains(value)) {
      checkCorrectness(value);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Nomen ${widget.appState.currentNouns.length - currentNouns.length} / ${widget.appState.currentNouns.length}"),
          SizedBox(height: 20,),
          Form(
            key: formkey,
            child: IntrinsicHeight(
              child: Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                spacing: 20,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      onFieldSubmitted: checkCorrectness,
                      validator: validateArticle,
                      focusNode: articleFocusNode,
                      controller: articleController,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: onArticleChanged,
                      decoration: InputDecoration(
                        helperText: ' ',
                        filled: true,
                        fillColor:
                        submitted
                            ? (wasCorrectArticle ? Colors.green : Colors.red)
                            : null,
                        border: OutlineInputBorder(),
                        hintText: 'artikel',
                        isDense: true,
                        errorStyle: TextStyle(height: 0),
                      ),
                    ),
                  ),
                  Text(
                    currentNoun.root,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 40,
            child: translationShown ?
            Text(currentNoun.translation, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
                :
            ElevatedButton(onPressed: () {
              setState(() {
                translationShown = true;
              });
            }, child: Text("Zeig die Übersetzung")),
          ),

          SizedBox(height: 40,),

          if (submitted)
            LinearProgressIndicator(value: progressController.value),
        ],
      ),
    );
  }
}
