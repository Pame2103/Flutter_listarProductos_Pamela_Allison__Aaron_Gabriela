import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAqCWl1FmoM5Nq7ku_7siZqnQUdYv3XWBE",
      authDomain: "flutter-firebase-ff30e.firebaseapp.com",
      projectId: "flutter-firebase-ff30e",
      storageBucket: "flutter-firebase-ff30e.appspot.com",
      messagingSenderId: "523521391104",
      appId: "1:523521391104:web:09e1512b718257ee8036e5"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Productos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color.fromARGB(255, 175, 151, 215)),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Lista de Productos')),
        ),
        body: Container(
          color: Colors.white, 
          padding: EdgeInsets.all(20.0), 
          child: Center(
            child: ProductListView(), 
          ),
        ),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Productos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: No se pudieron cargar los datos de Firestore'),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No hay productos disponibles'),
          );
        } else {
          var products = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20, 
              columns: [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('Cantidad')),
              ],
              rows: products.map<DataRow>((product) {
                var productData = product.data();
                var cantidad = int.tryParse(productData['cantidad'] ?? '0') ?? 0;
                var precio = productData['precio'] != null ? '\$${productData['precio']}' : 'N/A';
                return DataRow(
                  cells: [
                    DataCell(Text(productData['nombre'])),
                    DataCell(Text(precio)),
                    DataCell(Text('$cantidad')),
                  ],
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
