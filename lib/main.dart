import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'アンケート'
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                  leading: Text(
                    'A'
                  ),
                  title: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '入力してください'
                    ),
                  ),
                )
              ),
              Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: Text(
                        'B'
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '入力してください'
                      ),
                    ),
                  )
              ),
              Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: Text(
                        'C'
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '入力してください'
                      ),
                    ),
                  )
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                onPressed: () {
                  gotoSecondActivity(context);
                },
                textColor: Colors.white,
                padding: EdgeInsets.all(8),
                child: Text(
                  '確認',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NextAct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Survey'
          ),
        ),
      ),
    );
  }
}
gotoSecondActivity(BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context) => NextAct()));
}
