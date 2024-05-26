import 'package:flutter/material.dart';
import 'ThemeManager.dart';

class ThemeView extends StatefulWidget {
  @override
  _ThemeViewState createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {
  int _selectedThemeIndex = 0; // Índice del tema seleccionado

  List<String> _themes = ['Light', 'Dark', 'System']; // Lista de temas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Tema'),
      ),
      body: ListView.builder(
        itemCount: _themes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_themes[index]),
            leading: Radio(
              value: index,
              groupValue: _selectedThemeIndex,
              onChanged: (value) {
                setState(() {
                  _selectedThemeIndex = value as int;
                });

                // Aplicar el nuevo tema seleccionado
                ThemeManager.applyTheme(context, _selectedThemeIndex);
              },
            ),
          );
        },
      ),
    );
  }
}
