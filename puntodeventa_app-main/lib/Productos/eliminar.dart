import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:puntodeventa_app/Almacen/almacen.dart';

class Eliminar extends StatelessWidget {
  final TextEditingController idController = TextEditingController();

  Eliminar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E L I M I N A R',
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
              colors: [Colors.red, Colors.orange],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.red],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: 'ID DEL PRODUCTO',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // Aquí va el código para buscar el producto

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
                    print(product.nombre);
                    print(product.precio);
                    print(product.id);

                    // if (prod == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Eliminar Producto'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                  'ID: ${product.id}\nNombre: ${product.nombre}\nPrecio: \$${product.precio}',
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Confirmar'),
                              onPressed: () {
                                // Handle delete action
                                Hive.box('products')
                                    .delete(int.parse(idController.text));
                                Navigator.of(context).pop();

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Producto Eliminado Exitosamente!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ).whenComplete(() => Navigator.pop(context));
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: const Text('Eliminar Producto'),
                    //         content: SingleChildScrollView(
                    //           child: ListBody(
                    //             children: <Widget>[
                    //               Text(
                    //                   'ID: ${prod.id}\nNombre: ${prod.nombre}\nPrecio: \$${prod.precio}'),
                    //             ],
                    //           ),
                    //         ),
                    //         actions: <Widget>[
                    //           TextButton(
                    //             child: const Text('Cancelar'),
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //           ),
                    //           TextButton(
                    //             child: const Text('Confirmar'),
                    //             onPressed: () {
                    //               // Handle delete action
                    //               Hive.box('products')
                    //                   .delete(idController.text);
                    //               Navigator.of(context).pop();
                    //             },
                    //           ),
                    //         ],
                    //       );
                    //     });

                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     final TextEditingController newIdController =
                    //         TextEditingController();
                    //     return AlertDialog(
                    //       title: const Text('Eliminar Producto'),
                    //       content: SingleChildScrollView(
                    //         child: ListBody(
                    //           children: <Widget>[
                    //             Text(
                    //                 'ID: ${idController.text}\nNombre: Producto\nPrecio: \$100'),
                    //             TextField(
                    //               controller: newIdController,
                    //               decoration: const InputDecoration(
                    //                 labelText: 'Nuevo ID',
                    //               ),
                    //             ),
                    //             // Add more widgets here as needed
                    //             // for (int i = 0; i < 100; i++)
                    //             //   Padding(
                    //             //     padding: const EdgeInsets.all(8.0),
                    //             //     child: Text('Contenido de prueba $i'),
                    //             //   ),
                    //           ],
                    //         ),
                    //       ),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           child: const Text('Cancelar'),
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //         TextButton(
                    //           child: const Text('Confirmar'),
                    //           onPressed: () {
                    //             // Handle delete action
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
