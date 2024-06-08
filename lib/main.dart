import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

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
  String _data = ''; // 웹 페이지의 내용을 저장할 변수

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    _fetchData(); // initState에서 _fetchData 메서드를 호출
  }

  void _getTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://www.mokpo.ac.kr/www/275/subview.do'));

    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      String today = "${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().day.toString().padLeft(2, '0')}"; // Get today's date in 'mm.dd' format
      today = '06.05'; // 테스트를 위해 임의로 날짜를 변경

      List<dom.Element> dateElements = document.querySelectorAll('.date'); // Select all spans with class 'date'

      for (var dateElement in dateElements) {
        if (dateElement.text == today) { // Check if the text of the span is today's date
          dom.Element? parentElement = dateElement.parent?.parent?.parent; // Get the parent 'li' element
          if (parentElement != null) {
            List<dom.Element> mainElements = parentElement.querySelectorAll('.main'); // Select all divs with class 'main' under the 'li' element
            List<dom.Element> menuElements = parentElement.querySelectorAll('.menu'); // Select all divs with class 'menu' under the 'li' element

            if (mainElements.length > 1 && menuElements.length > 1) {
              setState(() {
                _data = 'Main: ${mainElements[1].text}, Menu: ${menuElements[1].text}';

              });
            }
          }
          print(_data);
          break; // Exit the loop once the desired date is found
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
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

            ),
          ),
          Text(
            _data, // 웹 페이지의 내용을 표시
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w100,
              color: Colors.blue,
              decoration: TextDecoration.none,
            ),
          ),
          const Text(
            "컴퓨터학부 2024",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w100,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}