import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/UVR/uvr_notifier.dart';

class UVRScreen extends StatelessWidget {
  const UVRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo UVR')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: UVRForm(),
      ),
    );
  }
}

class UVRForm extends ConsumerWidget {
  const UVRForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uvrFormState = ref.watch(uvrProvider);
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cálculo de UVR", style: textStyles.titleLarge),
        const Divider(thickness: 2),

        //* Capital input
        TextFormField(
          decoration: const InputDecoration(labelText: 'Capital'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            ref
                .read(uvrProvider.notifier)
                .onCapitalChanged(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 15),

        //* Interest rate input
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tasa de Interés (%)'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            ref
                .read(uvrProvider.notifier)
                .onInterestRateChanged(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 15),

        //* Periods input
        TextFormField(
          decoration: const InputDecoration(labelText: 'Períodos'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            ref
                .read(uvrProvider.notifier)
                .onPeriodsChanged(int.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 30),

        //* Calculate button
        ElevatedButton(
          onPressed: () {
            ref.read(uvrProvider.notifier).calculateUVR();
          },
          child: const Text('Calcular'),
        ),
        const SizedBox(height: 30),

        //* Result display
        if (uvrFormState.isFormPosted)
          Text(
            "Resultado: ${uvrFormState.result}",
            style: textStyles.headlineMedium,
          ),
      ],
    );
  }
}
