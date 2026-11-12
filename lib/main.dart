import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ציוני סטודנטים',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 72, 138)),
      ),
      // כיווניות מימין לשמאל לעברית
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const StudentsPage(),
    );
  }
}

class Student {
  Student(this.name, this.grade);
  final String name;
  int grade;
}

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  static const int passingGrade = 55;

  final List<Student> _students = [
    Student('נועה', 92),
    Student('דנה', 71),
    Student('יוסף', 54),
    Student('עומר', 48),
  ];

  double get _average =>
      _students.fold<int>(0, (sum, s) => sum + s.grade) / _students.length;

  void _increase(Student s) {
    if (s.grade < 100) setState(() => s.grade++);
  }

  void _decrease(Student s) {
    if (s.grade > 0) setState(() => s.grade--);
  }

  void _sortByGrade() {
    setState(() => _students.sort((a, b) => b.grade.compareTo(a.grade)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ממוצע: ${_average.toStringAsFixed(1)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'מיין לפי ציון',
            onPressed: _sortByGrade,
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final s in _students)
            ListTile(
              leading: s.grade >= passingGrade
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.cancel, color: Colors.red),
              title: Text(s.name),
              subtitle: Text('ציון: ${s.grade}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: s.grade > 0 ? () => _decrease(s) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: s.grade < 100 ? () => _increase(s) : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
