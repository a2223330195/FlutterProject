import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:puntodeventa_app/Almacen/almacen.dart';

class Modificar extends StatelessWidget {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextFormField textname = TextFormField();
  TextFormField textprice = TextFormField();

  Modificar({super.key});

  @override
  void initState() {
    textname = TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Nombre',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
    textprice = TextFormField(
      controller: priceController,
      decoration: InputDecoration(
        labelText: 'Precio',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
    // super.initState();
    // _cargarProductos();
    // idController.addListener(_filtrarProductos);
    // print('_productos.length');
    // print(_productos.length);
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'M O D I F I C A R',
          style: TextStyle(
            color: Colors.white,
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
              colors: [Colors.greenAccent, Colors.green],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.greenAccent],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          children: [
            TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            textname,
            const SizedBox(height: 20),
            textprice,
            // Text('Precio'),
            // TextFormField(
            //   controller: priceController,
            //   decoration: InputDecoration(
            //     labelText: 'Precio',
            //     filled: true,
            //     fillColor: Colors.white,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //   ),
            // ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
//hacer la busqueda del producto

                    var box = Hive.box('products');
                    Producto product = box.values
                        .map((productoDb) {
                          return Producto(
                            id: productoDb['id'],
                            nombre: productoDb['name'],
                            precio: productoDb['price'],
                            cantidad: 1,
                          );
                        })
                        .toList()
                        .firstWhere((producto) =>
                            producto.id == int.parse(idController.text));
                    nameController.text = product.nombre;
                    priceController.text = product.precio.toString();

                    // var box = Hive.box('products');
                    // Producto product = box.values
                    //     .map((productoDb) {
                    //       return Producto(
                    //         id: productoDb['id'],
                    //         nombre: productoDb['name'],
                    //         precio: productoDb['price'],
                    //         cantidad: 1,
                    //       );
                    //     })
                    //     .toList()
                    //     .firstWhere((producto) =>
                    //         producto.id == int.parse(idController.text));
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Aceptar'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle modify action
                    // Apply the changes
                    var box = Hive.box('products');
                    box.put(
                      int.parse(idController.text),
                      {
                        'id': int.parse(idController.text),
                        'name': nameController.text,
                        'price': double.parse(priceController.text),
                      },
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Modificación Exitosa'),
                          content: const Text(
                              'La modificación se ha realizado exitosamente.'),
                          actions: [
                            TextButton(
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
                  icon: const Icon(Icons.edit),
                  label: const Text('Modificar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
