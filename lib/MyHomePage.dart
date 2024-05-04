import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late stt.SpeechToText speech;
  bool _isListening = false;
  String _text = '';
  int _helloCount = 0;
  int _goodMorningCount = 0;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (_text == 'السلام عليكم') {
              _helloCount++;
            } else if (_text == 'صباح الخير') {
              _goodMorningCount++;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      speech.stop();
    }
  }

  void _resetCounters() {
    setState(() {
      _helloCount = 0;
      _goodMorningCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'عدد مرات السلام عليكم: $_helloCount',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'عدد مرات صباح الخير: $_goodMorningCount',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _isListening
                ? ElevatedButton(
              onPressed: _listen,
              child: Text('توقف'),
            )
                : ElevatedButton(
              onPressed: _listen,
              child: Text('بدء'),
            ),
            ElevatedButton(
              onPressed: _resetCounters,
              child: Text('تصفير'),
            ),
          ],
        ),
      ),
    );
  }
}