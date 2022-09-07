import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive_animation/cubits/focus_cubit.dart';
import 'package:rive_animation/ui/my_controlled_animation.dart';
import 'package:rive_animation/cubits/text_length_cubit.dart';

class MyRiveDemoApp extends StatelessWidget {
  const MyRiveDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => TextLengthCubit()),
        BlocProvider(create: (BuildContext context) => FocusCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Rive Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const MyHomePage(title: 'Flutter Rive Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();

    focusNode.addListener(() {
      context.read<FocusCubit>().setFocus(focusNode.hasFocus);
    });
  }

  OutlineInputBorder _getOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 64,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            constraints: const BoxConstraints(maxHeight: 300),
            child: const AspectRatio(
              aspectRatio: 1,
              child: MyControlledAnimation(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: const TextStyle(
                color: Colors.grey,
              ),
              focusNode: focusNode,
              controller: controller,
              onChanged: (text) {
                context
                    .read<TextLengthCubit>()
                    .changeLength(text.characters.length.toDouble());
              },
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                labelText: 'E-Mail',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: _getOutlineInputBorder(),
                border: _getOutlineInputBorder(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
