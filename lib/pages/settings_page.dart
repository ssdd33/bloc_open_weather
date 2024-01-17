import 'package:bloc_open_weather/blocs/temp_settings/temp_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
      ),
      body: ListTile(
          title: const Text('Temperature Unit'),
          subtitle: const Text(
            'Celsius/Fahrenheit (Default: Celsius)',
            style: TextStyle(fontSize: 13),
          ),
          trailing: Padding(
              padding: const EdgeInsets.all(10),
              child: Switch(
                  value: context.watch<TempSettingsBloc>().state.tempUnit ==
                      TempUnit.celsius,
                  onChanged: (_) {
                    context.read<TempSettingsBloc>().add(ToggleTempUnitEvent());
                  }))),
    );
  }
}
