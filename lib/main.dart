import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Calculator');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
    }
    notifyListeners();
  }

  void setvalue(double val) {
    value = val.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Age Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  Map<String, dynamic> _getAgeCategory(int age) {
    if (age <= 12) {
      return {'message': "You're a child!", 'color': Colors.lightBlueAccent};
    } else if (age <= 19) {
      return {'message': "Teenager time!", 'color': Colors.lightGreen};
    } else if (age <= 35) {
      return {
        'message': "You're a young adult!",
        'color': const Color.fromARGB(255, 204, 255, 0)
      };
    } else if (age <= 67) {
      return {'message': "You're an adult now!", 'color': Colors.orange};
    } else {
      return {
        'message': "Golden years!",
        'color': const Color.fromARGB(255, 209, 16, 16)
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        var ageCategory = _getAgeCategory(counter.value);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Age Calculator App'),
            backgroundColor: Colors.lightBlueAccent,
          ),
          backgroundColor: ageCategory['color'],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I am ${counter.value} years old',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 10),
                Text(
                  ageCategory['message'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                Slider(
                  min: 0,
                  max: 100,
                  value: context.read<Counter>().value.toDouble(),
                  onChanged: (double value) {
                    var counter = context.read<Counter>();
                    counter.setvalue(value);
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        var counter = context.read<Counter>();
                        counter.increment();
                      },
                      child: Text('Increase the age "+1"'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        var counter = context.read<Counter>();
                        counter.decrement();
                      },
                      child: Text('Reduce the age "-1"'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
