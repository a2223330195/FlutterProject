import 'package:flutter/material.dart';
import 'package:puntodeventa_app/Productos/ingresar.dart';
import 'package:puntodeventa_app/Productos/modificar.dart';
import 'package:puntodeventa_app/Productos/buscar.dart';
import 'package:puntodeventa_app/Productos/eliminar.dart';


class Productos extends StatelessWidget {
  const Productos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Oculta el botón de retroceso
        title: const Text(
          'Productos',
          style: TextStyle(
            color: Colors.white, // Cambia el color del texto a blanco
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Aplica la fuente Roboto
            decorationThickness: 1.0,
            decorationColor: Colors.black,
          ),
        ),
        backgroundColor: Colors.blue,
        toolbarHeight: 80, // Duplica el tamaño del AppBar
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home,
              size: 30, // Incrementa el tamaño del icono
              color: Colors.white, // Cambia el color del icono a blanco
            ),
            onPressed: () {
              Navigator.pop(context); // Devuelve al main.dart
            },
          ),
        ],
        shadowColor: Colors.black, // Agrega el color de sombra
        elevation: 6.0, // Ajusta la elevación de la sombra
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ingresar()), 
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.redAccent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'I N G R E S A R',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Modificar()), 
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.green,
                      Colors.lightGreen,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'M O D I F I C A R',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Buscar()), 
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'B U S C A R',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Eliminar()), 
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.orange,
                      Colors.deepOrange,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'E L I M I N A R',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}