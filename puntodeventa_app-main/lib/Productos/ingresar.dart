import 'package:flutter/material.dart';
import '../database_manager.dart';
import 'package:hive/hive.dart';

class Ingresar extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Ingresar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'I N G R E S A R',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange, Colors.red],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.orange],
          ),
        ),
        padding:
            const EdgeInsets.fromLTRB(16, 32, 16, 16), // Updated top padding
        child: Column(
          children: [
            const SizedBox(height: 10), // Updated height
            TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Updated textfield_padding
              ),
            ),
            const SizedBox(height: 42),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Updated textfield_padding
              ),
            ),
            const SizedBox(height: 42),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Precio',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Updated textfield_padding
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle cancel action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize
                        .min, // Para que la fila tenga el tamaño de sus hijos
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        color:
                            Colors.white, // Cambia el color del ícono a blanco
                      ),
                      Text(' Cancelar'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Handle form submission
                    int id = int.parse(idController.text);
                    String name = nameController.text;
                    double price = double.parse(priceController.text);
                    int quantity = 1; // Por defecto, la cantidad es 1

                    // Crear una instancia de DatabaseManager
                    DatabaseManager dbManager = DatabaseManager();

                    // Abrir la caja de productos
                    //  await Hive.openBox('products');
                    var box = Hive.box('products');

                    // Agregar el nuevo producto
                    dbManager.addProduct('products', id, name, quantity, price);
                    box.put(id, {
                      'id': id,
                      'name': name,
                      'quantity': quantity,
                      'price': price
                    });
                    // Limpiar los campos del formulario
                    idController.clear();
                    nameController.clear();
                    priceController.clear();

                    // Mostrar el pop up con los datos recolectados
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Datos almacenados'),
                          content:
                              const Text('Datos Registrados Correctamente'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    ).whenComplete(() => Navigator.pop(context));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize
                        .min, // Para que la fila tenga el tamaño de sus hijos
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color:
                            Colors.white, // Cambia el color del ícono a blanco
                      ),
                      Text(' Guardar'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
