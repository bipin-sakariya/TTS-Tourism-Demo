import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Text to Speech'),
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
  String text = '';
  FlutterTts flutterTts = FlutterTts();

  readFile(String language) async {
    flutterTts.stop();

    String tempText = await loadAsset(context, language);

    setState(() {
      text = tempText;
    });

    const platform = MethodChannel('flutter.native/helper');
    final String languageCode = await platform.invokeMethod('getLanguageCode', text);
    print('AA_S --- ' + languageCode);

    _speak(languageCode);
  }

  Future _speak(String languageCode) async {
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    var result = await flutterTts.speak(text);
    //if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future<String> loadAsset(BuildContext context, String language) async {
    if (language == 'English') {
      return await DefaultAssetBundle.of(context).loadString('assets/DummyText.txt');
    } else if (language == 'Hindi') {
      return await DefaultAssetBundle.of(context).loadString('assets/DummyTextHindi.txt');
    } else {
      return await DefaultAssetBundle.of(context).loadString('assets/DummyTextGujarati.txt');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            GestureDetector(
              onTap: () {
                flutterTts.stop();
                setState(() {
                  text = '';
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Center(
                  child: Text(
                    'Stop',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          readFile('English');
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: const Center(
                            child: Text(
                              'English',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          readFile('Hindi');
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: const Center(
                            child: Text(
                              'Hindi',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          readFile('Gujarati');
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: const Center(
                            child: Text(
                              'Gujarati',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  Text(
                    text,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
