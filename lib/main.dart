import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PathwiseApp());
}

class PathwiseApp extends StatelessWidget {
  const PathwiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathwise',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _generateLearningPath() async {
    final goal = _controller.text.trim();
    if (goal.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/generate'),
        body: {'goal': goal},
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = response.body;
        });
      } else {
        setState(() {
          _result = 'Virhe: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Yhteysvirhe: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathwise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Mitä haluat oppia?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateLearningPath,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Luo oppimispolku'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

