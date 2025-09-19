import 'package:examen1/constantes.dart';
import 'package:flutter/material.dart';
import 'dart:math';
class BuscaminasExam1 extends StatefulWidget {
  const BuscaminasExam1({super.key});

  @override
  State<BuscaminasExam1> createState() => _BuscaminasExam1State();
}
class _BuscaminasExam1State extends State<BuscaminasExam1> {
  static const int cuadriculaLado = 6;//6*6 cuadritos
  static const int totalCuadritos = cuadriculaLado * cuadriculaLado;
  static const int totalBombitas = 5; //num de bombas escondidas
  //lista de si el cuadrito ya fue volteado o no
  List<bool> cuadritoVolteado = List.filled(totalCuadritos, false);
  //lista de si en el cuadrito hay bomba o no
  List<bool> cuadritoEsBomba = List.filled(totalCuadritos, false);
  //juego terminado
  bool juegoYaValio = false;

  @override
  void initState() {
    super.initState();
    reiniciarJuego();
  }
  //INICIO/REINICIO DEL JUEGO
  void reiniciarJuego() {
    cuadritoVolteado = List.filled(totalCuadritos, false);
    cuadritoEsBomba = List.filled(totalCuadritos, false);
    juegoYaValio = false;
    //colocamos bombitas a lo random
    Random random = Random();
    int bombasColocadas = 0;
    while (bombasColocadas < totalBombitas) {
      int posRandom = random.nextInt(totalCuadritos);
      if (!cuadritoEsBomba[posRandom]) {
        cuadritoEsBomba[posRandom] = true;
        bombasColocadas++;
      }
    }

    setState(() {});
  }

  // ACCIÓN AL TOCAR UN CUADRITO
  void tocarCuadrito(int index) {
    if (juegoYaValio || cuadritoVolteado[index]) return;

    setState(() {
      cuadritoVolteado[index] = true;
      // Si la bomba es tocada 
      if (cuadritoEsBomba[index]) {
        juegoYaValio = true;
        //mostrar todas las bombitas
        for (int i = 0; i < totalCuadritos; i++) {
          if (cuadritoEsBomba[i]) cuadritoVolteado[i] = true;
        }
      }
    });
  }
  // colores de constantes.dart
  Color colorDelCuadrito(int index) {
    if (!cuadritoVolteado[index]) return grisecito; //escondido
    if (cuadritoEsBomba[index]) return rojito;//bomba
    return verdecito;//seguro
  }
  //CONSTRUCCIÓN TABLERO
  //crear un cuadrito
  Widget armarCuadrito(int index) {
    return Expanded(
      child: InkWell(
        onTap: () => tocarCuadrito(index),//acción al tocar
        child: Container(
          margin: const EdgeInsets.all(2), //espacio entre cuadritos
          color: colorDelCuadrito(index),
        ),
      ),
    );
  }

  //crear una fila completa
  Widget armarFila(int inicioFila) {
    return Expanded(
      child: Row(
        children: List.generate(cuadriculaLado, (col) { //6 columnas list.generate sirve para repetir widgets
          int index = inicioFila + col;
          return armarCuadrito(index);
        }),
      ),
    );
  }
  //LO QUE SE VE EN PANTALLA)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examen Fundamentos de Desarrollo Móvil"),
        backgroundColor:verdecin,
        foregroundColor: blanco,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Alumna: Claudia Espinosa Guzmán",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          //tablero
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(cuadriculaLado, (fila) { //esto es para las filas , funciona igual que list.generate de las columnas
                  int inicioFila = fila * cuadriculaLado;
                  return armarFila(inicioFila);
                }),
              ),
            ),
          ),

          //btn reiniciar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: reiniciarJuego,
              style: ElevatedButton.styleFrom(
                backgroundColor: naranjota,
                foregroundColor: blanco,
              ),
              child: const Text("Reiniciar Juego"),
            ),
          ),
        ],
      ),
    );
  }
}
