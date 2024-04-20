import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Menú de punto de Venta',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Altas')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('Bajas')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('Buscar')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('Listado')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('Salir')),
          ],
        ),
      ),
    );
  }
}
