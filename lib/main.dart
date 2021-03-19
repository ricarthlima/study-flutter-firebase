import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listString = <String>["Local"];
  TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  var url =
      "https://realtimedb-test-bfe20-default-rtdb.firebaseio.com/words.json";

// var url = Uri.https(
//     "realtimedb-test-bfe20-default-rtdb.firebaseio.com",
//     "/words",
//     {'q': '{http}'},
//   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: (isLoading)
              ? CircularProgressIndicator()
              : RefreshIndicator(
                  onRefresh: () => _getInformation(context),
                  child: ListView(children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "Palavra:"),
                      textAlign: TextAlign.center,
                      controller: _textController,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addText();
                      },
                      child: Text("Gravar"),
                    ),
                    Text("Palavras gravadas:"),
                    for (String s in listString) Text(s),
                  ])),
        ),
      ),
    );
  }

  void _addText() {
    setState(() {
      isLoading = true;
    });

    http.post(url, body: json.encode({"word": _textController.text})).then(
      (value) {
        _getInformation(context).then((value) {
          setState(() {
            isLoading = false;
          });
          _textController.text = "";
        });
      },
    );
  }

  Future<void> _getInformation(BuildContext context) async {
    //await Future.delayed(Duration(seconds: 2));
    return http.get(url).then((value) {
      Map<String, dynamic> map = json.decode(value.body);
      this.listString = [];
      for (String key in map.keys) {
        setState(() {
          this.listString.add(map[key]["word"]);
        });
      }
    });
  }
}
