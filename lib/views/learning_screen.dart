import 'package:deutschlich_besser/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Stepper(
                      steps: appState.stepPages,
                      type: StepperType.horizontal,
                      elevation: 0,
                      currentStep: appState.currentStep,
                        physics: NeverScrollableScrollPhysics(),
                      // stepIconMargin: EdgeInsets.all(2),
                      margin: EdgeInsets.all(0),
                      connectorThickness: 2,
                      stepIconBuilder: (int index, StepState state) {
                        if (appState.finishedSteps.contains(index)) {
                          return Icon(Icons.check, color: Colors.white, size: 20,  );
                        } else {
                          return Text(
                              (index + 1).toString(),
                            style: TextStyle(color: Colors.white),
                          );
                        }
                      },
                      controlsBuilder: (BuildContext ctx, ControlsDetails deets) {
                        return Container();
                      },
                      onStepTapped: (int step) {
                        appState.setStep(step);
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: BackButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Text("${appState.getCurrentSetName} for ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}",
                        style: Theme.of(context).textTheme.titleSmall,),
                      SizedBox(width: 50,),
                    ],
                  ),

                  SizedBox(height: 20,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
