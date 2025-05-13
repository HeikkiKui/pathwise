import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      debugShowCheckedModeBanner: false,
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

  @override
  void initState() {
    super.initState();
    _loadSavedSteps();
  }

  Future<void> _loadSavedSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('learning_steps');
    if (saved != null) {
      final List decoded = jsonDecode(saved);
      setState(() {
        _steps.addAll(decoded.map((e) => LearningStep.fromJson(e)));
      });
    }
  }

  Future<void> _saveSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_steps.map((e) => e.toJson()).toList());
    await prefs.setString('learning_steps', encoded);
  }

  Future<void> _generateLearningPath() async {
    final goal = _controller.text.trim();
    if (goal.isEmpty) return;

    setState(() {
      _isLoading = true;
      _steps.clear();
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5050/generate'),
        body: {'goal': goal},
      );

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');

        final parsedSteps = lines
            .where((line) =>
                line.trim().toLowerCase().startsWith("step ") ||
                RegExp(r'^\d+[.\)]').hasMatch(line) ||
                line.startsWith("**Step"))
            .map((line) => LearningStep(line.trim()))
            .where((step) => step.text.isNotEmpty)
            .toList();

        setState(() {
          _steps.addAll(parsedSteps);
        });

        await _saveSteps();
      } else {
        setState(() {
          _steps.add(LearningStep('Error: ${response.statusCode}'));
        });
      }
    } catch (e, stacktrace) {
      print('❌ ERROR: $e');
      print('🪵 STACKTRACE:\n$stacktrace');
      setState(() {
        _steps.add(LearningStep('Connection error: $e'));
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
    _saveSteps();
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
                labelText: 'What do you want to learn?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateLearningPath,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Learning Path'),
            ),
            const SizedBox(height: 20),
            if (_steps.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: CheckboxListTile(
                        title: Text(step.text),
                        value: step.done,
                        onChanged: (val) => _toggleStep(index, val),
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

class LearningStep {
  final String text;
  bool done;

  LearningStep(this.text, {this.done = false});

  Map<String, dynamic> toJson() => {
        'text': text,
        'done': done,
      };

  factory LearningStep.fromJson(Map<String, dynamic> json) {
    return LearningStep(
      json['text'],
      done: json['done'] ?? false,
    );
  }
}

