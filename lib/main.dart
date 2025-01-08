import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'student_list.dart';
import 'package:flutter/services.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เพิ่มเพื่อให้ async ทำงานถูกต้อง
  await Hive.initFlutter();
  try {
    await Hive.openBox('attendanceBox');
    await Hive.openBox('summaryBox');
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
      home: AttendanceScreen(
        date: '2025-01-01', // ตัวอย่าง
        summaryText: 'สรุปผลการเข้าชั้นเรียน',
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

  @override
  void initState() {
    super.initState();
    attendanceBox = Hive.box('attendanceBox');
    selectedDate = DateTime.now(); // ค่าเริ่มต้นคือวันที่ปัจจุบัน
    _initializeAttendance();
  }

  void _initializeAttendance() {
    String dateKey = selectedDate.toIso8601String().split('T')[0];
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
            title: Text('เช็คชื่อ ($dateKey)'),
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
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
            itemCount: students.length,
            itemBuilder: (context, index) {
              Student student = students[index];
              String studentStatus =
                  attendance[student.number.toString()]['status'];

              return GestureDetector(
                onTap: () {
                  attendance[student.number.toString()]['status'] =
                      studentStatus == 'มาเรียน' ? 'ขาดเรียน' : 'มาเรียน';
                  attendanceBox.put(dateKey, attendance);
                  updateSummaryBox(); // อัปเดตข้อมูลใน summaryBox
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        studentStatus == 'มาเรียน' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${student.number}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              );
            },
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
            formattedDate = DateFormat('EEEE d/MM/yyyy', 'th').format(DateTime.parse(key));
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

    return Scaffold(
      appBar: AppBar(title: Text('รายละเอียดวันที่ $date')),
      body: ListView.builder(
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
  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');
    if (attendanceBox.isEmpty) {
      // ตรวจสอบว่ากล่องข้อมูลว่างหรือไม่
      return Scaffold(
        appBar: AppBar(title: const Text('ตารางเช็คชื่อ')),
        body: const Center(
            child: Text('ไม่มีข้อมูลตารางเช็คชื่อ')), // เพิ่มข้อความแจ้งเตือน
      );
    }
    List<String> dates = attendanceBox.keys.cast<String>().toList();
    List<Student> students = studentList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตารางเช็คชื่อ'),
      ),
      body: Scrollbar(
        thumbVisibility: true, // เพิ่ม scrollbar ให้มองเห็นได้
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('ชื่อ/เลขที่')),
                ...dates
                    .map((date) => DataColumn(label: Text(_formatDate(date)))),
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
                          onTap: () {
                            setState(() {
                              String newStatus = (status == 'มาเรียน')
                                  ? 'ขาดเรียน'
                                  : 'มาเรียน';
                              attendance[student.number.toString()]?['status'] =
                                  newStatus;
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
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('d/MM').format(parsedDate); // แสดงวันที่แบบย่อ
    } catch (e) {
      return date; // ใช้ key เดิมถ้าแปลงไม่ได้
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
    Map<String, dynamic> summary = Map<String, dynamic>.from(
        summaryBox.get(date, defaultValue: {}));
    Map<String, dynamic> attendance = Map<String, dynamic>.from(
        attendanceBox.get(date, defaultValue: {}));

    int totalStudents = studentList.length;
    int maleTotal = studentList.where((student) => student.gender == 'ชาย').length;
    int femaleTotal = studentList.where((student) => student.gender == 'หญิง').length;

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

    List<Student> maleAbsentStudents = studentList
        .where((student) => student.gender == 'ชาย' && attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    List<Student> femaleAbsentStudents = studentList
        .where((student) => student.gender == 'หญิง' && attendance[student.number.toString()]?['status'] == 'ขาดเรียน')
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
            Text('ช = $maleTotal มา $malePresent ขาด ${maleTotal - malePresent}'),
            Text('ญ = $femaleTotal มา $femalePresent ขาด ${femaleTotal - femalePresent}'),
            Text('รวมทั้งหมด $totalStudents'),
            Text('รวมมา $totalPresent'),
            Text('ร้อยละ ${attendancePercentage.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('รายชื่อนักเรียนที่ขาดเรียน:'),
            const SizedBox(height: 8),
            const Text('ชาย:'),
            ...maleAbsentStudents.map((student) => Text('${student.number}. ${student.name}')),
            const SizedBox(height: 8),
            const Text('หญิง:'),
            ...femaleAbsentStudents.map((student) => Text('${student.number}. ${student.name}')),
          ],
        ),
      ),
    );
  }
}
