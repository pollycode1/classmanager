import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'screens/attendance_screen.dart';
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

class AttendanceSummaryScreen extends StatelessWidget {
  final String date;
  final String summaryText;

  const AttendanceSummaryScreen(
      {super.key, required this.date, required this.summaryText});

  @override
  Widget build(BuildContext context) {
    Hive.box('attendanceBox');
    Box summaryBox = Hive.box('summaryBox');

    if (summaryBox.isEmpty) {
      // ตรวจสอบว่ากล่องข้อมูลว่างหรือไม่
      return Scaffold(
        appBar: AppBar(title: const Text('สรุปการเช็คชื่อ')),
        body: const Center(
            child: Text('ไม่มีข้อมูลสรุปการเช็คชื่อ')), // เพิ่มข้อความแจ้งเตือน
      );
    }
    Map<String, dynamic> attendance = Map<String, dynamic>.from(
      summaryBox.get(date, defaultValue: {'malePresent': 0, 'femalePresent': 0, 'totalPresent': 0}), // ใช้ค่าเริ่มต้น
    );

    // แยกข้อมูลนักเรียนชายและหญิง
    int maleCount = 0, femaleCount = 0;
    int malePresent = 0, maleAbsent = 0;
    int femalePresent = 0, femaleAbsent = 0;

    // สร้างลิสต์สำหรับเก็บเลขที่และชื่อของนักเรียนที่ขาดเรียน
    List<Map<String, dynamic>> absentStudents = [];

    attendance.forEach((key, value) {
      if (value['gender'] == 'ชาย') {
        maleCount++;
        if (value['status'] == 'มาเรียน') {
          malePresent++;
        } else {
          maleAbsent++;
        }
      } else if (value['gender'] == 'หญิง') {
        femaleCount++;
        if (value['status'] == 'มาเรียน') {
          femalePresent++;
        } else {
          femaleAbsent++;
        }
      }

      // เพิ่มข้อมูลเลขที่และชื่อของผู้ขาดเรียนเข้าไปในลิสต์
      if (value['status'] == 'ขาดเรียน') {
        absentStudents.add({'number': key, 'name': value['name']});
      }
    });

    // คำนวณจำนวนรวมและเปอร์เซ็นต์
    int totalStudents = maleCount + femaleCount;
    int totalPresent = malePresent + femalePresent;
    double attendanceRate = totalPresent / totalStudents * 100;

    // แปลงวันที่
    String formattedDate =
        DateFormat('EEEE d/MM/yyyy', 'th').format(DateTime.parse(date));

    // สร้างข้อความสรุป
    String summary =
        'ป.6/3 = $totalStudents คน\nชาย = $maleCount คน มา $malePresent คน ขาด $maleAbsent คน \nหญิง = $femaleCount คน มา $femalePresent คน ขาด $femaleAbsent คน \nรวมทั้งหมด: $totalStudents คน \nรวมมา: $totalPresent คน\nร้อยละ: ${attendanceRate.toStringAsFixed(2)}%';

    return Scaffold(
      appBar: AppBar(
        title: Text(' $formattedDate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(summary, style: const TextStyle(fontSize: 16)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ข้อความสรุป:', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: summary)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('คัดลอกข้อความแล้ว')),
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceDetailScreen(
                        date: date, students: studentList),
                  ),
                );
              },
              child: const Text('ดูรายละเอียดการเข้าชั้นเรียน'),
            ),
            const SizedBox(height: 16),
            // แสดงรายชื่อนักเรียนที่ขาดเรียนพร้อมเลขที่
            const Text(
              'รายชื่อนักเรียนที่ขาดเรียน:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            absentStudents.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: absentStudents.length,
                      itemBuilder: (context, index) {
                        final student = absentStudents[index];
                        return ListTile(
                          leading:
                              const Icon(Icons.person_off, color: Colors.red),
                          title: Text(
                              'เลขที่ ${student['number']}: ${student['name']}'),
                        );
                      },
                    ),
                  )
                : const Text(
                    'ไม่มีนักเรียนขาดเรียน',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
          ],
        ),
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
    Map<String, dynamic> summary = Map<String, dynamic>.from(
        summaryBox.get(date, defaultValue: {}));

    return Scaffold(
      appBar: AppBar(title: Text('สรุปผลการเข้าชั้นเรียนวันที่ $date')),
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
            Text('มาเรียน (ชาย): ${summary['malePresent'] ?? '0'} คน'),
            Text('มาเรียน (หญิง): ${summary['femalePresent'] ?? '0'} คน'),
            Text('มาเรียนทั้งหมด: ${summary['totalPresent'] ?? '0'} คน'),
          ],
        ),
      ),
    );
  }
}
