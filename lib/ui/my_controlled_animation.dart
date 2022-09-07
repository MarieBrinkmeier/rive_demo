import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/cubits/focus_cubit.dart';
import 'package:rive_animation/cubits/text_length_cubit.dart';

class MyControlledAnimation extends StatefulWidget {
  const MyControlledAnimation({Key? key}) : super(key: key);

  @override
  State<MyControlledAnimation> createState() => _MyControlledAnimationState();
}

class _MyControlledAnimationState extends State<MyControlledAnimation> {
  late SMIInput? isChecking;
  late SMIInput? numLook;
  late Artboard? _riveArtboard = null;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() {
    rootBundle.load('assets/animations/dash.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artBoard = file.mainArtboard;

        var wernerController =
            StateMachineController.fromArtboard(artBoard, 'State Machine 1');

        if (wernerController != null) {
          artBoard.addController(wernerController);
          isChecking = wernerController.findInput<bool>('isChecking');
          numLook = wernerController.findInput<double>('numLook');
        }
        setState(() => _riveArtboard = artBoard);
      },
    );
  }

  void lookLeftToRight(double textLength) {
    if (isChecking?.value == true) {
      numLook?.value = textLength * 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TextLengthCubit, double>(
          listener: (context, textLength) {
            lookLeftToRight(textLength);
          },
        ),
        BlocListener<FocusCubit, bool>(
          listener: (context, hasFocus) {
            isChecking?.value = hasFocus;
          },
        ),
      ],
      child: _riveArtboard != null
          ? Rive(
              artboard: _riveArtboard!,
              fit: BoxFit.cover,
            )
          : const SizedBox(),
    );
  }
}
