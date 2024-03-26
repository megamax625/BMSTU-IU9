import 'package:flutter/material.dart';
import 'dart:math';

class LinePainter extends CustomPainter {
  List<double> coefficients;

  LinePainter(this.coefficients);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var ticks = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
    double height = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height;

    double xScale = width / 1000 * 3.5;

    print("xScale = $xScale");

    List<double> xs = [];
    List<double> ys = [];

    for (double x = 0; x <= 101; x += 1) {
      double y = evaluateCubicPolynomial(x, coefficients);
      xs.add(x);
      ys.add(y);
    }

    for (double h = height + 20; h >= 0; h -= 100) {
      canvas.drawLine(Offset(-width / xScale * 0.7, h), Offset(-width / xScale * 0.7 + 10, h), ticks);
    }

    for (int i = 0; i <= 100; i += 1) {
      Offset start = Offset(xs[i] * xScale - width / xScale * 0.7, size.height - ys[i]);
      Offset end = Offset(xs[i + 1] * xScale - width / xScale * 0.7, size.height - ys[i + 1]);
      print("Start: $start, End: $end");

      canvas.drawLine(start, end, paint);
      if ((i % 10) == 0) {
        canvas.drawLine(Offset(xs[i] * xScale - width / xScale * 0.7, size.height), Offset(xs[i] * xScale - width / xScale * 0.7, size.height - 10), ticks);
        print("Tick");
      }
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;

  double evaluateCubicPolynomial(double x, List<double> coefficients) {
    double res = coefficients[3] * pow(x, 3) + coefficients[2] * pow(x, 2) +
        coefficients[1] * x + coefficients[0];
    print("x = $x, a-s = $coefficients, res = $res");
    return res;
  }
}

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GraphApp(),
  ),
);

class GraphApp extends StatefulWidget {
  @override
  _GraphAppState createState() => _GraphAppState();
}

class _GraphAppState extends State<GraphApp> {
  List<double> coefficients = [0, 0, 0, 0];
  TextEditingController controllerA3 = TextEditingController();
  TextEditingController controllerA2 = TextEditingController();
  TextEditingController controllerA1 = TextEditingController();
  TextEditingController controllerA0 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polynomial Grapher'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCoefficientInput(3, controllerA3),
                buildCoefficientInput(2, controllerA2),
                buildCoefficientInput(1, controllerA1),
                buildCoefficientInput(0, controllerA0),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: LinePainter(coefficients),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCoefficientInput(int index, TextEditingController controller) {
    return Flexible(
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'a$index'),
        controller: controller,
        onEditingComplete: () {
          setState(() {
            coefficients[index] = double.parse(controller.text);
          });
        },
      ),
    );
  }
}