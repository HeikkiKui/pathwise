import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathwise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class StepItem {
  final String title;
  final String details;
  bool done;

  StepItem(this.title, {this.details = "", this.done = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<StepItem> _steps = [];
  bool _isLoading = false;

  Future<void> _generateSteps() async {
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

      print('🔍 BACKEND RESPONSE:\n${response.body}');

      final pattern = RegExp(
        r"Step\s*\d+:\s*(.*?)\s*Description:\s*(.*?)(?=Step\s*\d+:|\Z)",
        dotAll: true,
      );
      final matches = pattern.allMatches(response.body);

      if (matches.isEmpty) {
        setState(() {
          _steps.add(StepItem("⚠️ Could not parse AI response", details: response.body));
        });
      } else {
        setState(() {
          _steps.addAll(matches.map((match) => StepItem(
                match.group(1)!.trim(),
                details: match.group(2)!.trim(),
              )));
        });
      }
    } catch (e) {
      setState(() {
        _steps.add(StepItem('❌ Connection failed', details: e.toString()));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleDone(int index, bool? value) {
    setState(() {
      _steps[index].done = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌟 Pathwise'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: '✨ What do you want to learn?',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateSteps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A00FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('🚀 Generate Learning Path'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _steps.isEmpty
                  ? const Center(
                      child: Text('👆 Enter a goal and tap the button.'),
                    )
                  : ListView.separated(
                      itemCount: _steps.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.grey),
                      itemBuilder: (context, index) {
                        final step = _steps[index];
                        return CheckboxListTile(
                          value: step.done,
                          onChanged: (val) => _toggleDone(index, val),
                          title: Text(
                            '${index + 1}. ${step.title}',
                            style: TextStyle(
                              color: step.done ? Colors.greenAccent : Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: step.done ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: step.details.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    step.details,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                )
                              : null,
                          activeColor: Colors.purpleAccent,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
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

