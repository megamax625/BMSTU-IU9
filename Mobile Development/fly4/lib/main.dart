import 'dart:math';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _R = 5;
  double _r = 3;

  List<Group3D> get _torus => _generateTorus(_R, _r).toList(); // draw torus

  @override
  void initState() {
    super.initState();
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
          label: label == "R" ? _R.toStringAsFixed(2) : _r.toStringAsFixed(2),
          onChanged: (newValue) {
            setState(() {
              if (label == "R") {
                _R = newValue;
              } else if (label == "r") {
                _r = newValue;
              }
            });
            _delayedUpdateTorus();
          },
        ),
      ],
    );
  }

  void _delayedUpdateTorus() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
        });
      }
    });
  }

  final _controller = DiTreDiController(
    rotationX: -20,
    rotationY: 30,
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      title: 'DiTreDi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Expanded(
                child: DiTreDiDraggable(
                  controller: _controller,
                  child: DiTreDi(
                    figures: _torus,
                    controller: _controller,
                  ),
                ),
              ),
              _buildSlider("R", 1, 10, _R, (value) {
                setState(() {
                  _R = value;
                });
                _delayedUpdateTorus();
              }),
              _buildSlider("r", 0.5, 10, _r, (value) {
                setState(() {
                  _r = value;
                });
                _delayedUpdateTorus();
              }),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Drag to rotate. Scroll to zoom"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Iterable<Group3D> _generateTorus(double R, double r) sync* {
  final colors = [
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
  ];

  const int pointNum = 50;
  for (var i = 0; i <= pointNum; i++) {
    double theta = 2 * pi * i / pointNum;
    for (var j = 0; j <= pointNum; j++) {
      double phi = 2 * pi * j / pointNum;

      List<double> coords = _calculateCoordinates(R, r, theta, phi);
      double x = coords[0];
      double y = coords[1];
      double z = coords[2];

      List<double> coordsNext = _calculateCoordinates(R, r, theta + 2 * pi / pointNum, phi + 2 * pi / pointNum);
      double xNext = coordsNext[0];
      double yNext = coordsNext[1];
      double zNext = coordsNext[2];

      Color colorValue = colors.elementAt(((colors.length * (i / 2 + j) ~/ pointNum).clamp(0, colors.length - 1)));
      yield Group3D([
        Point3D(vector.Vector3(x, y, z), color: colorValue),
        Line3D(vector.Vector3(x, y, z), vector.Vector3(xNext, yNext, zNext), color: colorValue),
      ]);
    }
  }
}

List<double> _calculateCoordinates(double R, double r, double theta, double phi) {
  double x = (R + r * cos(theta)) * cos(phi);
  double y = (R + r * cos(theta)) * sin(phi);
  double z = r * sin(theta);
  return [x, y, z];
}