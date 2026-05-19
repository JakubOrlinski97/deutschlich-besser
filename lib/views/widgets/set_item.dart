
import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/views/learning_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetItem extends StatelessWidget {
  const SetItem({super.key, required this.appState, required this.setIndex});

  final AppState appState;
  final int setIndex;

  void selectSet(BuildContext context) {
    Provider.of<AppState>(context, listen: false).selectSet(setIndex)
        .then((Object? val) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LearningScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => selectSet(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(
            child: (Text(
              appState.availableSets[setIndex],
              style: TextStyle(
                color: Colors.white
              ),
            )),
          ),
        ),
      ),
    );
  }
}
