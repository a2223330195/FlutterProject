// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database_manager.dart';

final dbManager = DatabaseManager();

class Producto {
  final int id;
  final String nombre;
  final double precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
  });
}

class Buscar extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  final TextEditingController idController = TextEditingController();
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  // List<Producto> _productosCarrito = [];
  //un widget para mostrar los productos
  //un widget para mostrar el carrito
  //un card de lista para los productos

  //List<Card> _cards = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    idController.addListener(_filtrarProductos);
    print('_productos.length');
    print(_productos.length);
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  void _cargarProductos() async {
//cargar en var box los datos de la caja 'products'
    var box = await Hive.box('products');

    print(box.values);

    _productos = box.values.map((productoDb) {
      return Producto(
        id: productoDb['id'],
        nombre: productoDb['name'],
        precio: productoDb['price'],
      );
    }).toList();
    _productosFiltrados = _productos;
    setState(
        () {}); // Agrega esta línea para actualizar la interfaz de usuario después de cargar los productos

    // List<Map> productosDb = await dbManager.getAll('products');
    // _productos = productosDb.map((productoDb) {
    //   return Producto(
    //     id: productoDb['id'],
    //     nombre: productoDb['nombre'],
    //     precio: productoDb['precio'],
    //   );
    // }).toList();
    // _productosFiltrados = _productos;
  }

  void _filtrarProductos() {
    // setState(() {
    // _productosFiltrados = _productos.where((producto) {
    //   return producto.nombre.toLowerCase().contains(idController.text.toLowerCase()) ||
    //       producto.id.toString() == idController.text;
    // }).toList();
    _productosFiltrados = _productos.where((producto) {
      return producto.nombre
              .toLowerCase()
              .contains(idController.text.toLowerCase()) ||
          producto.id.toString() == idController.text;
    }).toList();
    //});
  }

  void _mostrarProductos() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Todos los productos'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: _productos.map((producto) {
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'B U S C A R',
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
              colors: [Color.fromARGB(255, 96, 182, 252), Colors.blue],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Color.fromARGB(255, 96, 182, 252)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: 'ID/NOMBRE',
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
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _filtrarProductos(); // Agrega esta línea para filtrar los productos cuando se haga clic en el botón de búsqueda
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _productosFiltrados.map((producto) {
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              '${producto.id}',
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                producto.nombre,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              const Spacer(),
                              Text(
                                '\$${producto.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _mostrarProductos,
      //   child: Icon(Icons.list),
      // ),
    );
  }
}
