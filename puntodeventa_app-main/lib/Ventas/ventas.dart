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

class Ventas extends StatefulWidget {
  const Ventas({Key? key}) : super(key: key);

  @override
  _AlmacenState createState() => _AlmacenState();
}

class _AlmacenState extends State<Ventas> {
  final TextEditingController _busquedaController = TextEditingController();
  TextEditingController _descontarController = TextEditingController();
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  List<Producto> _productosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    _busquedaController.addListener(_filtrarProductos);
  }

  void _agregarProductoAlCarrito(String nombre, int cantidad, double total) {
    var box = Hive.box('carrito');
    box.add({
      'nombre': nombre,
      'cantidad': cantidad,
      'total': total,
      // 'fecha': DateTime.now().toIso8601String(),
      // 'hora': TimeOfDay.now().format(context),
    });
  }

  void _realizarVenta() {
    var box = Hive.box('carrito');
    var productosSeleccionados = box.values.toList();
    box.clear();
    var venta = {
      'fecha': DateTime.now().toIso8601String().substring(0, 10),
      'hora': TimeOfDay.now().format(context),
      // 'hora': DateTime.now().toIso8601String(),
      'productos': productosSeleccionados,
    };
    var boxVentas = Hive.box('ventas');
    boxVentas.add(venta);
    // boxVentas.clear();

    // Limpia la lista de productos seleccionados
    setState(() {
      _productosSeleccionados.clear();
    });

    // Muestra un diálogo indicando que la venta se realizó correctamente
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Venta realizada'),
          content: Text('Venta realizada correctamente'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // print(boxVentas.values.toList());
                // //print
                // print('fsfs');
                var box = Hive.box('ventas');
                print(productosSeleccionados.length);

                print(box.values.toList());
                print(productosSeleccionados.length);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).whenComplete(() => Navigator.pop(context));
  }

  void _cargarProductos() async {
    await Hive.openBox('carrito');
    var box = await Hive.box('products');
    List<Producto> productos = await box.values.map((productoDb) {
      return Producto(
        id: productoDb['id'],
        nombre: productoDb['name'],
        cantidad: productoDb['quantity'],
        precio: productoDb['price'],
      );
    }).toList();
    setState(await () {
      _productos = productos;
      _productosFiltrados = _productos;
    });
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    _descontarController.dispose();
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
                  const Text('Cantidad:'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          int currentValue =
                              int.parse(_descontarController.text);
                          _descontarController.text =
                              (currentValue > 0 ? currentValue - 1 : 0)
                                  .toString();
                        },
                      ),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _descontarController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          int currentValue =
                              int.parse(_descontarController.text);
                          _descontarController.text =
                              (currentValue + 1).toString();
                        },
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
                    _descontarController.clear(); // Limpia el TextField
                    Navigator.of(context).pop();
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Aceptar'),
                  onPressed: () {
                    setState(() {
                      producto.cantidad -= int.parse(_descontarController.text);
                      _productosSeleccionados.add(Producto(
                        id: producto.id,
                        nombre: producto.nombre,
                        cantidad: int.parse(_descontarController.text),
                        precio: producto.precio,
                      ));
                      // Agregar producto al carrito
                      _agregarProductoAlCarrito(
                        producto.nombre,
                        int.parse(_descontarController.text),
                        producto.precio * int.parse(_descontarController.text),
                      );
                    });
                    var box = Hive.box('products');
                    box.put(producto.id, {
                      'id': producto.id,
                      'name': producto.nombre,
                      'quantity': producto.cantidad,
                      'price': producto.precio,
                    });
                    _descontarController.clear(); // Limpia el TextField
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
          'V E N T A S',
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
              colors: [Colors.red, Colors.redAccent],
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
      body: Stack(
        children: [
          Container(
            color: Colors.red,
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _busquedaController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: _productosSeleccionados.map((producto) {
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 210, 210, 210),
                                  child: Text(
                                    '${producto.id}',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                title: Text(
                                  producto.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('Cantidad: ${producto.cantidad}'),
                                trailing: Text(
                                  '\$${producto.precio * producto.cantidad}',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_busquedaController.text.isNotEmpty)
            Positioned(
              top: 100, // Ajusta este valor según tus necesidades
              left: 16,
              right: 16,
              child: Container(
                color: const Color.fromARGB(255, 204, 204, 204),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _productosFiltrados.length > 3
                      ? 3
                      : _productosFiltrados.length, // Limita a 3 elementos
                  itemBuilder: (context, index) {
                    final producto = _productosFiltrados[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      onTap: () {
                        _busquedaController.text = producto.nombre;
                        //_filtrarProductos();
                        _mostrarDialogo(producto);
                        _descontarController.text = '1';
                      },
                    );
                  },
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background color
                    padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24), // increase padding for a bigger button
                  ),
                  onPressed: () {
                    // Aquí va la lógica de pagar
                    _realizarVenta();
                  },
                  icon: Icon(Icons.shopping_cart,
                      color: Colors.white, size: 24), // increase icon size
                  label: Text('PAGAR',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18)), // increase text size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
