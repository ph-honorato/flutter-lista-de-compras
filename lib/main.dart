import 'package:flutter/material.dart';
import 'pages/PaginaListaDeCompras.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
    ),
    home: PaginaListaDeCompras(),
  ));
}
