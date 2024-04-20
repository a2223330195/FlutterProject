import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Producto {
  int id;
  String nombre;
  int cantidad;
  double precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
  });
}

class Almacen extends StatefulWidget {
  const Almacen({Key? key}) : super(key: key);

  @override
  _AlmacenState createState() => _AlmacenState();
}

class _AlmacenState extends State<Almacen> {
  final TextEditingController _busquedaController = TextEditingController();
  final TextEditingController _agregarController = TextEditingController();
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    _busquedaController.addListener(_filtrarProductos);
  }

  void _cargarProductos() async {
    var box = await Hive.box('products');
    List<Producto> productos = await box.values.map((productoDb) {
      return Producto(
        id: productoDb['id'] ?? 0,
        nombre: productoDb['name'] ?? '',
        cantidad: productoDb['quantity'] ?? 0,
        precio: productoDb['price'] ?? 0.0,
      );
    }).toList();
    setState(() {
      _productos = productos;
      _productosFiltrados = _productos;
    });
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    _agregarController.dispose();
    super.dispose();
  }

  void _filtrarProductos() {
    setState(() {
      _productosFiltrados = _productos.where((producto) {
        return producto.nombre
                .toLowerCase()
                .contains(_busquedaController.text.toLowerCase()) ||
            producto.id.toString() == _busquedaController.text;
      }).toList();
    });
  }

  void _mostrarDialogo(Producto producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ID: ${producto.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nombre:'),
                  Text('Precio:'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    '\$${producto.precio}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cantidad:'),
                      Text(
                        '${producto.cantidad}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Agregar:'),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _agregarController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('Cancelar'),
                  onPressed: () {
                    _agregarController.clear(); // Limpia el TextField
                    Navigator.of(context).pop();
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Aceptar'),
                  onPressed: () {
                    setState(() {
                      producto.cantidad += int.parse(_agregarController.text);
                    });
                    var box = Hive.box('products');
                    box.put(producto.id, {
                      'id': producto.id,
                      'name': producto.nombre,
                      'quantity': producto.cantidad,
                      'price': producto.precio,
                    });
                    _agregarController.clear(); // Limpia el TextField
                    Navigator.of(context).pop();
                  },
                ),
              ],
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
          'A L M A C E N',
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
              colors: [Colors.green, Colors.lightGreen],
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: _filtrarProductos,
          // ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightGreen, Colors.green],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _busquedaController,
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
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          title: Text(
                            producto.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Cantidad: ${producto.cantidad}'),
                          trailing: Text(
                            '\$${producto.precio}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                          onTap: () => _mostrarDialogo(producto),
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
    );
  }
}
