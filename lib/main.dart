import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/GoogleMaps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Maps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Örnek Map uygulamam',),
            SizedBox(height: 40,),
            RaisedButton(
              child: Text('Google Maps sayfama git'),
              onPressed: () {
               Navigator.push(context, MaterialPageRoute<bool>(builder: (context) => GoogleMaps(title: 'Google maps')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
