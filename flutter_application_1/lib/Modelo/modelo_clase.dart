import 'package:flutter/material.dart';

class Clase extends StatelessWidget {
  final String nombre;
  final String horario;

  const Clase({super.key, required this.nombre, required this.horario});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.book),
        title: Text(nombre),
        subtitle: Text(horario),
      ),
    );
  }
}
