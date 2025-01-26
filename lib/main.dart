import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'student_list.dart';
import 'package:flutter/services.dart'; // Add this import
import 'hive_log_screen.dart'; // Add this import
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เพิ่มเพื่อให้ async ทำงานถูกต้อง
  await Hive.initFlutter();
  try {
    await Hive.openBox('attendanceBox');
    await Hive.openBox('summaryBox');
    await Hive.openBox('customAttendanceBox'); // Open customAttendanceBox
    await Hive.openBox('recordsBox'); // Open recordsBox
  } catch (e) {
    if (kDebugMode) {
      print('เปิด Hive Box ไม่สำเร็จ: $e');
    }
  }
  if (kDebugMode) {
    print('เปิด attendanceBox: ${Hive.isBoxOpen('attendanceBox')}');
  }
  if (kDebugMode) {
    print('เปิด summaryBox: ${Hive.isBoxOpen('summaryBox')}');
  }
  if (kDebugMode) {
    print('เปิด customAttendanceBox: ${Hive.isBoxOpen('customAttendanceBox')}');
  }
  if (kDebugMode) {
    print('เปิด recordsBox: ${Hive.isBoxOpen('recordsBox')}');
  }

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // แก้ builder ให้ถูกต้อง
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('th', 'TH'), // เพิ่มภาษาไทย
        Locale('en', 'US'), // ภาษาอังกฤษ (ตัวอย่าง)
      ],
      locale: Locale('th', 'TH'), // กำหนดค่าเริ่มต้นเป็นภาษาไทย
      home: HomeScreen(), // เปลี่ยนหน้าแรกเป็น HomeScreen
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูหลัก'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ระบบจัดการชั้นเรียน',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceScreen(
                        date: '2025-01-01', // ตัวอย่าง
                        summaryText: 'สรุปผลการเข้าชั้นเรียน',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('เช็คชื่อ', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AttendanceHistoryScreen(students: []),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('ประวัติการขาดเรียน',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceTableScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    const Text('ตารางเช็คชื่อ', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HiveLogScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Log ข้อมูล Hive',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('บันทึกการเช็คชื่อ',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen(
      {super.key, required String date, required String summaryText});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Box attendanceBox;
  late DateTime selectedDate;
  List<Student> students = studentList;
  bool isLocked = true; // Initial state is locked
  final TextEditingController _customKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    attendanceBox = Hive.box('attendanceBox');
    selectedDate = DateTime.now(); // ค่าเริ่มต้นคือวันที่ปัจจุบัน
    _initializeAttendance();
  }

  @override
  void dispose() {
    _customKeyController.dispose();
    super.dispose();
  }

  void _createCustomKey() {
    String customKey = _customKeyController.text.trim();
    if (customKey.isNotEmpty) {
      setState(() {
        selectedDate = DateTime.now(); // Reset to current date
        _initializeAttendance(customKey: customKey);
      });
    }
  }

  void _initializeAttendance({String? customKey}) {
    String dateKey = customKey ?? selectedDate.toIso8601String().split('T')[0];
    // ดึงข้อมูลจาก Hive และแปลงเป็น Map<String, dynamic>
    final rawAttendance = attendanceBox.get(dateKey);

    // ตรวจสอบประเภทข้อมูลและแปลงให้ตรงกับที่คาดหวัง
    Map<String, dynamic>? existingAttendance;
    if (rawAttendance is Map) {
      existingAttendance = Map<String, dynamic>.from(rawAttendance);
    } else {
      existingAttendance = null; // กรณีที่ข้อมูลไม่ใช่ Map
    }

    if (existingAttendance == null ||
        existingAttendance.keys.length != students.length) {
      // ดำเนินการในกรณีไม่มีข้อมูลหรือข้อมูลไม่สมบูรณ์
      if (kDebugMode) {
        print("Attendance data is missing or incomplete.");
      }
    }
  }

  void updateSummaryBox() {
    String dateKey = selectedDate.toIso8601String().split('T')[0];
    Box summaryBox = Hive.box('summaryBox');

    // แปลงข้อมูลจาก Hive
    Map<String, dynamic> attendance =
        Map<String, dynamic>.from(attendanceBox.get(dateKey, defaultValue: {}));

    int malePresentCount = 0;
    int femalePresentCount = 0;

    attendance.forEach((key, value) {
      if (value['status'] == 'มาเรียน') {
        if (value['gender'] == 'ชาย') {
          malePresentCount++;
        } else if (value['gender'] == 'หญิง') {
          femalePresentCount++;
        }
      }
    });

    summaryBox.put(
      dateKey,
      {
        'malePresent': malePresentCount.toString(), // แปลง int เป็น String
        'femalePresent': femalePresentCount.toString(), // แปลง int เป็น String
        'totalPresent': (malePresentCount + femalePresentCount)
            .toString(), // แปลง int เป็น String
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _initializeAttendance(); // อัปเดตข้อมูลตามวันที่ใหม่
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = selectedDate.toIso8601String().split('T')[0];

    return ValueListenableBuilder(
      valueListenable: attendanceBox.listenable(),
      builder: (context, Box box, _) {
        if (box.isEmpty) {
          // ตรวจสอบกล่องข้อมูลว่ามีข้อมูลหรือไม่
          return Scaffold(
            appBar: AppBar(title: const Text('เช็คชื่อ')),
            body: const Center(
                child: Text('ไม่มีข้อมูลเช็คชื่อ')), // เพิ่มข้อความแจ้งเตือน
          );
        }
        Map<String, dynamic> attendance = Map.from(
          box.get(dateKey, defaultValue: {
            for (var student in students)
              student.number.toString(): {
                'name': student.name,
                'gender': student.gender,
                'status': 'ขาดเรียน', // ค่าเริ่มต้น
              },
          }),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(dateKey),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'ดูประวัติการขาดเรียน',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AttendanceHistoryScreen(students: []),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.table_chart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceTableScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  Student student = students[index];
                  String studentStatus =
                      attendance[student.number.toString()]['status'];

                  return GestureDetector(
                    onTap: isLocked
                        ? null
                        : () {
                            attendance[student.number.toString()]['status'] =
                                studentStatus == 'มาเรียน'
                                    ? 'ขาดเรียน'
                                    : 'มาเรียน';
                            attendanceBox.put(dateKey, attendance);
                            updateSummaryBox(); // อัปเดตข้อมูลใน summaryBox
                          },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: studentStatus == 'มาเรียน'
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${student.number}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  heroTag: 'lockButton',
                  onPressed: () {
                    setState(() {
                      isLocked = !isLocked;
                    });
                  },
                  child: Icon(isLocked ? Icons.lock : Icons.lock_open),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 16,
                child: FloatingActionButton(
                  heroTag: 'addButton',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('สร้างคีย์ที่เป็นข้อความ'),
                          content: TextField(
                            controller: _customKeyController,
                            decoration:
                                const InputDecoration(hintText: 'ใส่คีย์ที่ต้องการ'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('ยกเลิก'),
                            ),
                            TextButton(
                              onPressed: () {
                                _createCustomKey();
                                Navigator.of(context).pop();
                              },
                              child: const Text('สร้าง'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Box>('attendanceBox', attendanceBox));
  }
}

class AttendanceHistoryScreen extends StatelessWidget {
  final List<Student> students;
  const AttendanceHistoryScreen({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');
    if (attendanceBox.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('ประวัติการขาดเรียน')),
        body: const Center(child: Text('ไม่มีข้อมูลประวัติการขาดเรียน')),
      );
    }
    for (var key in attendanceBox.keys) {
      if (kDebugMode) {
        print('Key: $key, Value: ${attendanceBox.get(key)}');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการขาดเรียน')),
      body: ListView(
        children: attendanceBox.keys.map((key) {
          Map<String, dynamic> attendance = Map<String, dynamic>.from(
              attendanceBox.get(key, defaultValue: {}));

          // แยกนักเรียนชายและหญิงที่ขาดเรียน
          int maleAbsentCount = 0;
          int femaleAbsentCount = 0;
          attendance.forEach((key, value) {
            if (value['status'] == 'ขาดเรียน') {
              if (value['gender'] == 'ชาย') {
                maleAbsentCount++;
              } else if (value['gender'] == 'หญิง') {
                femaleAbsentCount++;
              }
            }
          });

          // แปลงวันที่ให้อยู่ในรูปแบบ วัน d/MM/yyyy
          String formattedDate = '';
          try {
            formattedDate =
                DateFormat('EEEE d/MM/yyyy', 'th').format(DateTime.parse(key));
          } catch (e) {
            formattedDate = key; // ใช้ key เดิมถ้าเกิดปัญหา
          }

          return ListTile(
            title: Text(formattedDate), // ใช้วันที่ที่ฟอร์แมตแล้ว
            subtitle: Text(
              'ขาดเรียน: ${maleAbsentCount + femaleAbsentCount} คน (ชายขาด: $maleAbsentCount คน, หญิงขาด: $femaleAbsentCount คน)',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceSummaryScreen(
                    date: key,
                    summaryText: '',
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

// ignore: must_be_immutable
class AttendanceDetailScreen extends StatelessWidget {
  final String date;
  AttendanceDetailScreen(
      {super.key, required this.date, required List<Student> students});
  List<Student> students = studentList;
  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');

    // ดึงข้อมูลของวันที่และแปลงให้เป็น Map
    Map<String, dynamic> attendance =
        Map<String, dynamic>.from(attendanceBox.get(date, defaultValue: {}));

    // แยกนักเรียนชายที่ขาดเรียน
    List<Student> maleAbsentStudents = students
        .where((student) =>
            student.gender == 'ชาย' &&
            attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    // แยกนักเรียนหญิงที่ขาดเรียน
    List<Student> femaleAbsentStudents = students
        .where((student) =>
            student.gender == 'หญิง' &&
            attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return Scaffold(
      appBar: AppBar(title: Text('รายละเอียดวันที่ $date')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                Student student = students[index];
                String status =
                    attendance[student.number.toString()]?['status'] ?? 'ขาดเรียน';

                return ListTile(
                  title: Text('เลขที่ ${student.number}: ${student.name}'),
                  trailing: Icon(
                    status == 'มาเรียน' ? Icons.check_circle : Icons.cancel,
                    color: status == 'มาเรียน' ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'สรุปผลการเข้าชั้นเรียน',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),  // เพิ่มข้อความสรุปผลการเข้าชั้นเรียน 
                const SizedBox(height: 8),
                const Text(
                  'สรุปนักเรียนชายที่ขาดเรียน:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...maleAbsentStudents.map(
                  (student) => Text('เลขที่ ${student.number}: ${student.name}'),
                ), // Added toList() here
                const SizedBox(height: 8),
                const Text(
                  'สรุปนักเรียนหญิงที่ขาดเรียน:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...femaleAbsentStudents.map(
                  (student) => Text('เลขที่ ${student.number}: ${student.name}'),
                ), // Added toList() here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceTableScreen extends StatefulWidget {
  const AttendanceTableScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceTableScreenState createState() => _AttendanceTableScreenState();
}

class _AttendanceTableScreenState extends State<AttendanceTableScreen> {
  bool isLocked = true; // Initial state is locked

  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');
    if (attendanceBox.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('ตารางเช็คชื่อ')),
        body: const Center(child: Text('ไม่มีข้อมูลตารางเช็คชื่อ')),
      );
    }
    List<String> dates = attendanceBox.keys.cast<String>().toList();
    List<Student> students = studentList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตารางเช็คชื่อ'),
      ),
      body: Stack(
        children: [
          Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('ชื่อ/เลขที่')),
                    ...dates.map(
                        (date) => DataColumn(label: Text(_formatDate(date)))),
                  ],
                  rows: students.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${student.number}. ${student.name}')),
                        ...dates.map((date) {
                          Map<String, dynamic> attendance =
                              Map<String, dynamic>.from(
                                  attendanceBox.get(date, defaultValue: {}));
                          String status = attendance[student.number.toString()]
                                  ?['status'] ??
                              'ขาดเรียน';

                          return DataCell(
                            GestureDetector(
                              onTap: isLocked
                                  ? null
                                  : () {
                                      setState(() {
                                        String newStatus = (status == 'มาเรียน')
                                            ? 'ขาดเรียน'
                                            : 'มาเรียน';
                                        attendance[student.number.toString()]
                                            ?['status'] = newStatus;
                                        attendanceBox.put(date, attendance);
                                      });
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: (status == 'มาเรียน')
                                    ? Colors.green
                                    : Colors.red,
                                child: Center(
                                  child: Text(
                                    status == 'มาเรียน' ? '✔' : '✖',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'lockButton',
              onPressed: () {
                setState(() {
                  isLocked = !isLocked;
                });
              },
              child: Icon(isLocked ? Icons.lock : Icons.lock_open),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('d/MM').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}

class AttendanceSummaryScreen extends StatelessWidget {
  final String date;
  final String summaryText;

  const AttendanceSummaryScreen({
    super.key,
    required this.date,
    required this.summaryText,
  });

  @override
  Widget build(BuildContext context) {
    Box summaryBox = Hive.box('summaryBox');
    Box attendanceBox = Hive.box('attendanceBox');
    Map<String, dynamic> summary =
        Map<String, dynamic>.from(summaryBox.get(date, defaultValue: {}));
    Map<String, dynamic> attendance =
        Map<String, dynamic>.from(attendanceBox.get(date, defaultValue: {}));

    int totalStudents = studentList.length;
    int maleTotal =
        studentList.where((student) => student.gender == 'ชาย').length;
    int femaleTotal =
        studentList.where((student) => student.gender == 'หญิง').length;

    int malePresent = summary['malePresent'] is int
        ? summary['malePresent']
        : int.tryParse(summary['malePresent'] ?? '0') ?? 0;
    int femalePresent = summary['femalePresent'] is int
        ? summary['femalePresent']
        : int.tryParse(summary['femalePresent'] ?? '0') ?? 0;

    int totalPresent = malePresent + femalePresent;
    double attendancePercentage = (totalPresent / totalStudents) * 100;

    String summaryText = '''
ป.6/3 = $totalStudents คน
ช = $maleTotal มา $malePresent ขาด ${maleTotal - malePresent}
ญ = $femaleTotal มา $femalePresent ขาด ${femaleTotal - femalePresent}
รวมทั้งหมด $totalStudents
รวมมา $totalPresent
ร้อยละ ${attendancePercentage.toStringAsFixed(2)}
''';


    List<Student> femaleAbsentStudents = studentList
        .where((student) =>
            student.gender == 'หญิง' &&
            attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปผลการเข้าชั้นเรียนวันที่ $date'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: summaryText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('คัดลอกข้อความเรียบร้อย')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สรุปผลการเข้าชั้นเรียน',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('ป.6/3 = $totalStudents คน'),
            Text(
                'ช = $maleTotal มา $malePresent ขาด ${maleTotal - malePresent}'),
            Text(
                'ญ = $femaleTotal มา $femalePresent ขาด ${femaleTotal - femalePresent}'),
            Text('รวมทั้งหมด $totalStudents'),
            Text('รวมมา $totalPresent'),
            Text('ร้อยละ ${attendancePercentage.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('หญิง:'),
            ...femaleAbsentStudents
                .map((student) => Text('${student.number}. ${student.name}')),
          ],
        ),
      ),
    );
  }
}

class CustomListScreen extends StatefulWidget {
  const CustomListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomListScreenState createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  final TextEditingController _listNameController = TextEditingController();

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างรายการเช็คชื่อ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _listNameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อรายการ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_listNameController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomAttendanceScreen(
                        listName: _listNameController.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text('สร้างรายการ'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAttendanceScreen extends StatefulWidget {
  final String listName;

  const CustomAttendanceScreen({super.key, required this.listName});

  @override
  // ignore: library_private_types_in_public_api
  _CustomAttendanceScreenState createState() => _CustomAttendanceScreenState();
}

class _CustomAttendanceScreenState extends State<CustomAttendanceScreen> {
  late Box customAttendanceBox;
  late DateTime selectedDate;
  List<Student> students = studentList;
  bool isLocked = true; // Initial state is locked

  @override
  void initState() {
    super.initState();
    customAttendanceBox = Hive.box('customAttendanceBox');
    selectedDate = DateTime.now(); // Default to current date
    _initializeAttendance();
  }

  void _initializeAttendance() {
    String dateKey = selectedDate.toIso8601String().split('T')[0];
    final rawAttendance =
        customAttendanceBox.get('${widget.listName}_$dateKey');

    Map<String, dynamic>? existingAttendance;
    if (rawAttendance is Map) {
      existingAttendance = Map<String, dynamic>.from(rawAttendance);
    } else {
      existingAttendance = null;
    }

    if (existingAttendance == null ||
        existingAttendance.keys.length != students.length) {
      if (kDebugMode) {
        print("Attendance data is missing or incomplete.");
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _initializeAttendance(); // Update data for the new date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = selectedDate.toIso8601String().split('T')[0];

    return ValueListenableBuilder(
      valueListenable: customAttendanceBox.listenable(),
      // ignore: avoid_types_as_parameter_names
      builder: (context, Box box, _) {
        if (box.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.listName)),
            body: const Center(child: Text('ไม่มีข้อมูลเช็คชื่อ')),
          );
        }
        Map<String, dynamic> attendance = Map.from(
          box.get('${widget.listName}_$dateKey', defaultValue: {
            for (var student in students)
              student.number.toString(): {
                'name': student.name,
                'gender': student.gender,
                'status': 'ขาดเรียน',
              },
          }),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.listName} ($dateKey)'),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'ดูประวัติการขาดเรียน',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomAttendanceHistoryScreen(
                          listName: widget.listName),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.table_chart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomAttendanceTableScreen(
                          listName: widget.listName),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  Student student = students[index];
                  String studentStatus =
                      attendance[student.number.toString()]['status'];

                  return GestureDetector(
                    onTap: isLocked
                        ? null
                        : () {
                            attendance[student.number.toString()]['status'] =
                                studentStatus == 'มาเรียน'
                                    ? 'ขาดเรียน'
                                    : 'มาเรียน';
                            customAttendanceBox.put(
                                '${widget.listName}_$dateKey', attendance);
                          },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: studentStatus == 'มาเรียน'
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${student.number}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  heroTag: 'lockButton',
                  onPressed: () {
                    setState(() {
                      isLocked = !isLocked;
                    });
                  },
                  child: Icon(isLocked ? Icons.lock : Icons.lock_open),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomAttendanceHistoryScreen extends StatelessWidget {
  final String listName;

  const CustomAttendanceHistoryScreen({super.key, required this.listName});

  @override
  Widget build(BuildContext context) {
    Box customAttendanceBox = Hive.box('customAttendanceBox');
    if (customAttendanceBox.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('ประวัติการขาดเรียน')),
        body: const Center(child: Text('ไม่มีข้อมูลประวัติการขาดเรียน')),
      );
    }
    for (var key in customAttendanceBox.keys) {
      if (kDebugMode) {
        print('Key: $key, Value: ${customAttendanceBox.get(key)}');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการขาดเรียน')),
      body: ListView(
        children: customAttendanceBox.keys
            .where((key) => key.toString().startsWith(listName))
            .map((key) {
          Map<String, dynamic> attendance = Map<String, dynamic>.from(
              customAttendanceBox.get(key, defaultValue: {}));

          int maleAbsentCount = 0;
          int femaleAbsentCount = 0;
          attendance.forEach((key, value) {
            if (value['status'] == 'ขาดเรียน') {
              if (value['gender'] == 'ชาย') {
                maleAbsentCount++;
              } else if (value['gender'] == 'หญิง') {
                femaleAbsentCount++;
              }
            }
          });

          String formattedDate = '';
          try {
            formattedDate = DateFormat('EEEE d/MM/yyyy', 'th')
                .format(DateTime.parse(key.toString().split('_').last));
          } catch (e) {
            formattedDate = key.toString().split('_').last;
          }

          return ListTile(
            title: Text(formattedDate),
            subtitle: Text(
              'ขาดเรียน: ${maleAbsentCount + femaleAbsentCount} คน (ชายขาด: $maleAbsentCount คน, หญิงขาด: $femaleAbsentCount คน)',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomAttendanceSummaryScreen(
                    listName: listName,
                    date: key.toString().split('_').last,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class CustomAttendanceSummaryScreen extends StatelessWidget {
  final String listName;
  final String date;

  const CustomAttendanceSummaryScreen({
    super.key,
    required this.listName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Box customAttendanceBox = Hive.box('customAttendanceBox');
    Map<String, dynamic> attendance = Map<String, dynamic>.from(
        customAttendanceBox.get('${listName}_$date', defaultValue: {}));

    int totalStudents = studentList.length;
    int maleTotal =
        studentList.where((student) => student.gender == 'ชาย').length;
    int femaleTotal =
        studentList.where((student) => student.gender == 'หญิง').length;

    int malePresent = attendance.values
        .where(
            (value) => value['status'] == 'มาเรียน' && value['gender'] == 'ชาย')
        .length;
    int femalePresent = attendance.values
        .where((value) =>
            value['status'] == 'มาเรียน' && value['gender'] == 'หญิง')
        .length;

    int totalPresent = malePresent + femalePresent;
    double attendancePercentage = (totalPresent / totalStudents) * 100;

    String summaryText = '''
$listName = $totalStudents คน
ช = $maleTotal มา $malePresent ขาด ${maleTotal - malePresent}
ญ = $femaleTotal มา $femalePresent ขาด ${femaleTotal - femalePresent}
รวมทั้งหมด $totalStudents
รวมมา $totalPresent
ร้อยละ ${attendancePercentage.toStringAsFixed(2)}
''';

    List<Student> maleAbsentStudents = studentList
        .where((student) =>
            student.gender == 'ชาย' &&
            attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    List<Student> femaleAbsentStudents = studentList
        .where((student) =>
            student.gender == 'หญิง' &&
            attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปผลการเข้าชั้นเรียนวันที่ $date'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: summaryText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('คัดลอกข้อความเรียบร้อย')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สรุปผลการเข้าชั้นเรียน',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('$listName = $totalStudents คน'),
            Text(
                'ช = $maleTotal มา $malePresent ขาด ${maleTotal - malePresent}'),
            Text(
                'ญ = $femaleTotal มา $femalePresent ขาด ${femaleTotal - femalePresent}'),
            Text('รวมทั้งหมด $totalStudents'),
            Text('รวมมา $totalPresent'),
            Text('ร้อยละ ${attendancePercentage.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('รายชื่อนักเรียนที่ขาดเรียน:'),
            const SizedBox(height: 8),
            const Text('ชาย:'),
            ...maleAbsentStudents
                .map((student) => Text('${student.number}. ${student.name}')),
            const SizedBox(height: 8),
            const Text('หญิง:'),
            ...femaleAbsentStudents
                .map((student) => Text('${student.number}. ${student.name}')),
          ],
        ),
      ),
    );
  }
}

class CustomAttendanceTableScreen extends StatefulWidget {
  final String listName;

  const CustomAttendanceTableScreen({super.key, required this.listName});

  @override
  // ignore: library_private_types_in_public_api
  _CustomAttendanceTableScreenState createState() =>
      _CustomAttendanceTableScreenState();
}

class _CustomAttendanceTableScreenState
    extends State<CustomAttendanceTableScreen> {
  bool isLocked = true; // Initial state is locked

  @override
  Widget build(BuildContext context) {
    Box customAttendanceBox = Hive.box('customAttendanceBox');
    if (customAttendanceBox.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.listName)),
        body: const Center(child: Text('ไม่มีข้อมูลตารางเช็คชื่อ')),
      );
    }
    List<String> dates = customAttendanceBox.keys.cast<String>().toList();
    List<Student> students = studentList;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
      ),
      body: Stack(
        children: [
          Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('ชื่อ/เลขที่')),
                    ...dates.map(
                        (date) => DataColumn(label: Text(_formatDate(date)))),
                  ],
                  rows: students.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${student.number}. ${student.name}')),
                        ...dates.map((date) {
                          Map<String, dynamic> attendance =
                              Map<String, dynamic>.from(customAttendanceBox
                                  .get(date, defaultValue: {}));
                          String status = attendance[student.number.toString()]
                                  ?['status'] ??
                              'ขาดเรียน';

                          return DataCell(
                            GestureDetector(
                              onTap: isLocked
                                  ? null
                                  : () {
                                      setState(() {
                                        String newStatus = (status == 'มาเรียน')
                                            ? 'ขาดเรียน'
                                            : 'มาเรียน';
                                        attendance[student.number.toString()]
                                            ?['status'] = newStatus;
                                        customAttendanceBox.put(
                                            date, attendance);
                                      });
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: (status == 'มาเรียน')
                                    ? Colors.green
                                    : Colors.red,
                                child: Center(
                                  child: Text(
                                    status == 'มาเรียน' ? '✔' : '✖',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'lockButton',
              onPressed: () {
                setState(() {
                  isLocked = !isLocked;
                });
              },
              child: Icon(isLocked ? Icons.lock : Icons.lock_open),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('d/MM').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}
