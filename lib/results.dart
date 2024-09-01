import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String result; // Receive the result

  const ResultsPage({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: const Text('Detection Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Disease Detected: ',
                style: TextStyle(
                  color: Colors.teal[900],
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: result, // Display the dynamic result
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SampleCard(cardName: result),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Disease Prevention Measures:',
                style: TextStyle(
                  color: Colors.teal[900],
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Follow appropriate crop management practices.',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SampleCard(cardName: 'Elevated Card'),
          ],
        ),
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(Icons.nature_people, color: Colors.green, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                cardName,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
     ),
);
}
}