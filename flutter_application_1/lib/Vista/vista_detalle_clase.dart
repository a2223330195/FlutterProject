import 'package:flutter/material.dart';
import 'package:school_management_app/Modelo/modelo_clase.dart';

class DetalleClase extends StatelessWidget {
  final Clase clase;

  const DetalleClase({super.key, required this.clase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clase.nombre),
      ),
      body: Center(
        child: Text('Horario: ${clase.horario}'),
      ),
    );
  }
}
