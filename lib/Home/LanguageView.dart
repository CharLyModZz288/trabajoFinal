import 'package:flutter/material.dart';

import '../main.dart';

class LanguageView extends StatefulWidget {
  @override
  _LanguageViewState createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idioma'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecciona tu idioma:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: <String>['English', 'Spanish']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Cambiar el idioma de toda la aplicación
                if (_selectedLanguage == 'Spanish') {
                  MyApp.setLocale(context, Locale('es'));
                } else {
                  MyApp.setLocale(context, Locale('en'));
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to: $_selectedLanguage'),
                  ),
                );
              },
              child: Text('Aplicar'),
            ),
          ],
        ),
      ),
    );
  }
}
