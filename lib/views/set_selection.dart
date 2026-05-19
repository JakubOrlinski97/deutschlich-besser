import 'package:deutschlich_besser/models/app_state.dart';
import 'package:deutschlich_besser/models/exercise.dart';
import 'package:deutschlich_besser/views/widgets/set_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SetSelection extends StatefulWidget {
  const SetSelection({super.key, this.title = "Set Selection"});

  final String title;

  @override
  State<SetSelection> createState() => _SetSelectionState();
}

class _SetSelectionState extends State<SetSelection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Please select your set:"),

          Consumer<AppState>(
            builder: (context, appState, child) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: ScrollPhysics(),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  shrinkWrap: true,
                  children: List.generate(appState.availableSets.length, (
                    int setIndex,
                  ) {
                    return SetItem(appState: appState, setIndex: setIndex);
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
