import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWatchFace(),
    );
  }
}
class MyWatchFace extends StatefulWidget {
  const MyWatchFace({Key? key}) : super(key: key);

  @override
  _MyWatchFaceState createState() => _MyWatchFaceState();
}

class _MyWatchFaceState extends State<MyWatchFace> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${_dateTime.year}년 ${_dateTime.month.toString().padLeft(2, '0')}월 ${_dateTime.day.toString().padLeft(2, '0')}일",
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              decoration: TextDecoration.none,
              height: 2,
            ),
          ),
          Text(
            "${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}:${_dateTime.second.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              decoration: TextDecoration.none,
              height: 2,
            ),
          ),
          const Text(
            "컴퓨터학부 2024",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w100,
              color: Colors.blue,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
