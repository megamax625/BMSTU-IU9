import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Painter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyPainter(),
    );
  }
}


class MyPainter extends StatefulWidget {
  const MyPainter({super.key});

  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  double radius = 100;
  bool hmuriy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smailik/Hmurik'),
      ),
      body: CustomPaint(
        painter: ShapePainter(radius: radius, hmuriy: hmuriy),
        child: Container(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Radius:'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      value: radius,
                      min: 50,
                      max: 200,
                      onChanged: (value) {
                        setState(() {
                          radius = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Hmuriy:'),
                  const SizedBox(width: 10),
                  Radio(
                    value: false,
                    groupValue: hmuriy,
                    onChanged: (value) {
                      setState(() {
                        hmuriy = value as bool;
                      });
                    },
                  ),
                  const Text('False'),
                  Radio(
                    value: true,
                    groupValue: hmuriy,
                    onChanged: (value) {
                      setState(() {
                        hmuriy = value as bool;
                      });
                    },
                  ),
                  const Text('True'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class ShapePainter extends CustomPainter {
  final double radius;
  final bool hmuriy;

  ShapePainter({required this.radius, required this.hmuriy});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;


    Offset center = Offset(size.width / 2, size.height / 2); // <---------- окружность
    canvas.drawCircle(center, radius, paint);

    Offset leftEyeCenter = Offset(center.dx - radius / 3, center.dy - radius / 3); // <------ глаза
    Offset rightEyeCenter = Offset(center.dx + radius / 3, center.dy - radius / 3);
    canvas.drawCircle(leftEyeCenter, radius / 10, paint);
    canvas.drawCircle(rightEyeCenter, radius / 10, paint);

    var nosePath = Path(); // <------- нос
    nosePath.moveTo(center.dx, center.dy - radius / 10);
    nosePath.lineTo(center.dx - radius / 5, center.dy + radius / 5);
    nosePath.lineTo(center.dx + radius / 6, center.dy + radius / 5);
    canvas.drawPath(nosePath, paint);

    var mouthPath = Path(); // <------ рот (улыбка или хмурый в зависимости от hmuriy)
    if (!hmuriy) {
      // рисуем смайлика
      mouthPath.moveTo(center.dx - radius / 2, center.dy + radius / 2);
      mouthPath.arcToPoint(Offset(center.dx + radius / 2, center.dy + radius / 2), radius: Radius.circular(radius), clockwise: false);
      canvas.drawPath(mouthPath, paint);
    } else {
      // рисуем хмурика
      mouthPath.moveTo(center.dx - radius / 2, center.dy + radius / 2);
      mouthPath.arcToPoint(Offset(center.dx + radius / 2, center.dy + radius / 2), radius: Radius.circular(radius));
      canvas.drawPath(mouthPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}