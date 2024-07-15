import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:measurement_system/series_card.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class TimeSeriesPage extends StatefulWidget {
  const TimeSeriesPage({super.key});

  @override
  State<TimeSeriesPage> createState() => _TimeSeriesPageState();
}

class _TimeSeriesPageState extends State<TimeSeriesPage> {
  Future<void> shareFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/saved_series.txt');

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Time Series Data');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data to share')),
        );
      }
    } catch (e) {
      print('Error sharing file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sharing file')),
      );
    }
  }

  Future<String> loadSavedSeries() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/saved_series.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: shareFile,
        child: const Icon(Icons.share),
      ),
      appBar: AppBar(
        title: const Text('Time Series'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: loadSavedSeries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved series yet.'));
          } else {
            List<String> series = snapshot.data!.split('\n\n');
            series.removeLast();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: series.length,
              itemBuilder: (context, index) {
                return SeriesCard(
                  timestamps: series[index].split(', '),
                  seriesIndex: index,
                );
              },
            );
          }
        },
      ),
    );
  }
}
