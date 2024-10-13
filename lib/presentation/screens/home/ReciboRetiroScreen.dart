import 'package:flutter/material.dart';

class ReciboRetiroScreen extends StatelessWidget {
  final double montoRetirado;
  final double nuevoSaldo;
  final String nombreUsuario;
  final DateTime fechaRetiro;
  final String documento; // Agregado

  const ReciboRetiroScreen({
    super.key,
    required this.montoRetirado,
    required this.nuevoSaldo,
    required this.nombreUsuario,
    required this.fechaRetiro,
    required this.documento, // Agregado
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recibo de Retiro'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
          child: ClipPath(
            clipper: ReceiptClipper(),
            child: Material(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.3),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda para el contenido
                  children: [
                    // Título centrado
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'FinancyBank',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Tipo de Transacción: Retiro', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10), // Separación
                    Text('Ref: ${(DateTime.now().millisecondsSinceEpoch % 10000000000).toString().padLeft(10, '0')}', style: const TextStyle(fontSize: 18)), // Código generado aleatoriamente con 10 dígitos
                    const SizedBox(height: 10), // Separación
                    Text('Fecha Retiro: ${fechaRetiro.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10), // Separación
                    _buildDashedLine(), // Línea de guiones
                    Text('Nombre: $nombreUsuario', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10), // Separación
                    Text('Documento: ${'******' + documento.substring(6)}', style: const TextStyle(fontSize: 18)), // Mostrar parte del documento
                    const SizedBox(height: 10), // Separación
                    Text('Monto Retirado: \$${montoRetirado.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10), // Separación
                    Text('Nuevo Balance: \$${nuevoSaldo.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                    _buildDashedLine(), // Línea de guiones
                    const SizedBox(height: 10), // Separación
                    const Text('Verifique el monto retirado', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10), // Separación
                    const Text('Línea de Atención: 3002308960', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashedLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(40, (index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.0), // Espaciado entre guiones
          child: Text('-', style: TextStyle(fontSize: 18)), // Guión
        );
      }),
    );
  }
}

// Clase personalizada para dibujar el recibo con triángulos
class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Parte superior
    path.lineTo(0, size.height - 20);

    // Parte inferior con triángulos
    for (double i = 0; i < size.width; i += 20) {
      path.lineTo(i, size.height);
      path.lineTo(i + 10, size.height - 10); // Triángulo
      path.lineTo(i + 20, size.height); // Regresa al fondo
    }

    path.lineTo(size.width, size.height - 20); // Asegurarse que la línea sea recta al final
    path.lineTo(size.width, 0); // Parte superior derecha
    path.lineTo(0, 0); // Parte superior izquierda
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
