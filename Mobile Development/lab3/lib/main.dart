import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Cube Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;

  double _distance = 20;

  double _mass1 = 10;
  double _mass2 = 10;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 50;
    _cube = Object();
    final Object sphere1 = Object(
      position: Vector3(-_distance, 0.0, 0.0),
      fileName: 'assets/earth/earth.obj',
      name: "sphere1",
    );
    final Object sphere2 = Object(
      position: Vector3(_distance, 0.0, 0.0),
      fileName: 'assets/earth/earth.obj',
      name: "sphere2",
    );
    _cube!.add(sphere1);
    _cube!.add(sphere2);
    scene.world.add(_cube!);
    }

    void attract() {
      double attraction = _mass1 * _mass2 / (_distance * _distance) / 100;
      if (kDebugMode) {
        print(attraction);
        print(_distance);
      }
      if (_distance - attraction > 0) {
        _distance = _distance - attraction;
      } else {
        _distance = 0;
      }

      _cube!.children.last.position.setFrom(Vector3(-_distance, 0.0, 0.0));
      _cube!.children.first.position.setFrom(Vector3(_distance, 0.0, 0.0));
      _cube!.children.first.updateTransform();
      _cube!.children.last.updateTransform();
    }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          // _cube!.rotation.y = _controller.value * 360;
          // _cube!.updateTransform();
          _scene.update();
          attract();
        }
      })
      ..repeat();
  }

  Widget _buildSlider(String label, double min, double max, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Text("$label = ${value.toStringAsFixed(2)}"),
        Slider(
          min: min,
          max: max,
          divisions: 20,
          value: value,
          label: label,
          onChanged: (newValue) {
            setState(() {
              if (label == "distance") {
                _distance = newValue;
              } else if (label == "mass1") {
                _mass1 = newValue;
              } else if (label == "mass2") {
                _mass2 = newValue;
              }
            });
          },
        ),
      ],
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SafeArea(
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Expanded(child: Cube(onSceneCreated: _onSceneCreated)),
            _buildSlider("mass1", 10, 100, _mass1, (value) {
              setState(() {
                _mass1 = value;
                attract();
              });
            }),
            _buildSlider("mass2", 10, 100, _mass2, (value) {
              setState(() {
                _mass2 = value;
                attract();
              });
            }),
            _buildSlider("distance", 0, 100, _distance, (value) {
              setState(() {
                _distance = value;
                attract();
              });
            }),
          ],
        )
      ),
    );
  }
}