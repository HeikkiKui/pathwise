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
  final List<LearningStep> _steps = [];
  bool _isLoading = false;

  Future<void> _generateLearningPath() async {
    final goal = _controller.text.trim();
    if (goal.isEmpty) return;

    setState(() {
      _isLoading = true;
      _steps.clear();
    });

    try {
      final response = await http.post(
        // ⚠️ Vaihda osoite jos käytät emulaattoria tai fyysistä laitetta
        Uri.parse('http://10.0.2.2:5000/generate'),
        body: {'goal': goal},
      );

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');

        final parsedSteps = lines.where((line) {
          return RegExp(r'^\d+\.\s').hasMatch(line);
        }).map((line) {
          final clean = line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim();
          return LearningStep(clean);
        }).toList();

        setState(() {
          _steps.addAll(parsedSteps);
        });
      } else {
        setState(() {
          _steps.add(LearningStep('Virhe: ${response.statusCode}'));
        });
      }
    } catch (e) {
      setState(() {
        _steps.add(LearningStep('Yhteysvirhe: $e'));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleStep(int index, bool? value) {
    setState(() {
      _steps[index].done = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathwise')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            if (_steps.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    return CheckboxListTile(
                      title: Text(step.text),
                      value: step.done,
                      onChanged: (val) => _toggleStep(index, val),
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

class LearningStep {
  final String text;
  bool done;

  LearningStep(this.text, {this.done = false});
}

