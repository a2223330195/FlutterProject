import 'package:flutter/material.dart';
import 'package:school_management_app/Modelo/modelo_clase.dart';
import 'package:school_management_app/Vista/vista_detalle_clase.dart';
import 'package:school_management_app/Controlador/controlador_nueva_clase.dart';

class VistaClases extends StatefulWidget {
  const VistaClases({super.key});

  @override
  VistaClasesState createState() => VistaClasesState();
}

class VistaClasesState extends State<VistaClases> {
  final List<Clase> _clases = [];

  void _agregarClase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NuevaClase()),
    ).then((nuevaClase) {
      if (nuevaClase != null) {
        setState(() {
          _clases.add(nuevaClase);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Clases'),
      ),
      body: ListView(
        children: _clases
            .map((clase) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetalleClase(clase: clase)),
                    );
                  },
                  child: clase,
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarClase,
        child: const Icon(Icons.add),
      ),
    );
  }
}
