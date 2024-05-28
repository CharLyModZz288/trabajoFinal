import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EncuestasView extends StatefulWidget {
  @override
  _EncuestasViewState createState() => _EncuestasViewState();
}

class _EncuestasViewState extends State<EncuestasView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedRating = 0;
  Map<int, double> _ratingsPercentage = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  void _submitRating() async {
    if (_selectedRating > 0) {
      await _firestore.collection('ratings').add({'rating': _selectedRating});
      _calculateRatingsPercentage();
    }
  }

  void _calculateRatingsPercentage() async {
    QuerySnapshot snapshot = await _firestore.collection('ratings').get();
    if (snapshot.docs.isNotEmpty) {
      Map<int, int> ratingsCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      snapshot.docs.forEach((doc) {
        int rating = doc['rating'];
        if (ratingsCount.containsKey(rating)) {
          ratingsCount[rating] = ratingsCount[rating]! + 1;
        }
      });

      int totalRatings = snapshot.docs.length;
      setState(() {
        _ratingsPercentage = ratingsCount.map((key, value) => MapEntry(key, (value / totalRatings) * 100));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateRatingsPercentage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuestas'),
        backgroundColor: Colors.amber, // Ajusta el color según tu diseño
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Valora nuestra app:',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int rating = index + 1;
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: _selectedRating >= rating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _selectedRating = rating;
                  });
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: _submitRating,
            child: Text('Enviar valoración'),
          ),
          SizedBox(height: 30),
          Text(
            'Porcentaje de valoraciones:',
            style: TextStyle(fontSize: 20),
          ),
          ..._ratingsPercentage.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${entry.key} estrellas: ${entry.value.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
