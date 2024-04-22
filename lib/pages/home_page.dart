import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  bool _end=false;
  String _completingWord='';
  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    print('started');
    await _speechToText.listen(onResult: _onSpeechResult,pauseFor: const Duration(minutes: 5));
  }

  void _onSpeechResult(result) {
    setState(() {
      if(!_end){
       _wordsSpoken=result.recognizedWords;
      print('!!!!!!!${_wordsSpoken}');
      }
    });
  }

  
  void _stopListening() async {
    print('stoped');
    await _speechToText.stop();
    setState(() {
      _wordsSpoken='';
      _completingWord='';
      _end=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Speech Demo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(onPressed: (){
                _stopListening();
                Future.delayed(const Duration(seconds: 2),(){
                    setState(() {
                      _end=false;
                    });
                });
          }, 
          child: const Text('End',style: TextStyle(color: Colors.white,fontSize: 20)))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                _end? "": _speechToText.isNotListening?(_completingWord +='$_wordsSpoken '): _wordsSpoken,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: Colors.red,
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}