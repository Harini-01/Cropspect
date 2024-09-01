import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login/camera.dart';
import 'capture.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual weather data fetching logic
    String city = "San Francisco";
    String temperature = "22°C";
    String weatherDescription = "Sunny";
    String weatherIcon = "☀️"; // Replace with an actual icon or asset

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              temperature,
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              weatherDescription,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              weatherIcon,
              style: TextStyle(
                fontSize: 100.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
