import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_management_app/Vista/vista_principal.dart';

final Logger logger = Logger('Main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configura el logger
  Logger.root.level = Level.ALL; // Muestra todos los mensajes de registro
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escuela',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ignore: deprecated_member_use
      home: WillPopScope(
        onWillPop: () async {
          // Aquí puedes manejar el evento de presionar el botón de retroceso.
          // Si devuelves false, se cancelará el evento de retroceso.
          // Si devuelves true, se permitirá el evento de retroceso.
          return true;
        },
        child: const HomePage(),
      ),
    );
  }
}
