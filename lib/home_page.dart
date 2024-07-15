import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MeasurementSystem extends StatefulWidget {
  const MeasurementSystem({super.key});

  @override
  State<MeasurementSystem> createState() => _MeasurementSystemState();
}

class _MeasurementSystemState extends State<MeasurementSystem> {
  final List<String> currentSeries = [];
  List<List<String>> savedSeries = [];

  @override
  void initState() {
    super.initState();
    loadSavedSeriesFromFile();
  }

  Future<void> loadSavedSeriesFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/saved_series.txt');

      if (await file.exists()) {
        final contents = await file.readAsString();
        final seriesList = contents.split('\n\n');

        setState(() {
          savedSeries = seriesList
              .where((series) => series.isNotEmpty)
              .map((series) => series.split(', '))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading saved series: $e');
      // You might want to show an error message to the user here
    }
  }

  Future<void> setTime() async {
    final now = DateTime.now();
    final dateTimeString = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      currentSeries.add(dateTimeString);

      if (currentSeries.length == 4) {
        savedSeries.add(List.from(currentSeries));
        currentSeries.clear();
        appendSeriesToFile(savedSeries.last);
      }
    });
  }

  void resetTime() {
    setState(() {
      currentSeries.clear();
    });
  }

  void deleteTime(int index) {
    setState(() {
      currentSeries.removeAt(index);
    });
  }

  Future<void> appendSeriesToFile(List<String> series) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/saved_series.txt');
      final seriesString = '${series.join(', ')}\n\n';

      await file.writeAsString(seriesString, mode: FileMode.append);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Series saved to file')),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save series to file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Measurement System')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: setTime,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Get Time'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: resetTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Reset'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/time-series'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Show Time Series'),
            ),
            const SizedBox(height: 24),
            const Text('Current Series:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: currentSeries.isEmpty
                  ? const Center(
                      child: Text('No timestamps yet.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: currentSeries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(currentSeries[index],
                                style: const TextStyle(fontSize: 16)),
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTime(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
