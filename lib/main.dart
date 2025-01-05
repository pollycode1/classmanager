import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'screens/attendance_screen.dart';
import 'student_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เพิ่มเพื่อให้ async ทำงานถูกต้อง
  await Hive.initFlutter();
  await Hive.openBox('attendanceBox');
  await Hive.openBox('summaryBox');

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



// ignore: must_be_immutable
class AttendanceDetailScreen extends StatelessWidget {
  final String date;
  AttendanceDetailScreen({super.key, required this.date, required List<Student> students});
  List<Student> students = studentList;
  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');

    // ดึงข้อมูลของวันที่และแปลงให้เป็น Map
    Map<String, dynamic> attendance = Map<String, dynamic>.from(attendanceBox.get(date, defaultValue: {}));

    return Scaffold(
      appBar: AppBar(title: Text('รายละเอียดวันที่ $date')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          Student student = students[index];
          String status = attendance[student.number.toString()]?['status'] ?? 'ขาดเรียน';

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
class AttendanceSummaryScreen extends StatelessWidget {
  final String date;
  final String summaryText;

  const AttendanceSummaryScreen({super.key, required this.date, required this.summaryText});

  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');
    Map<String, dynamic> attendance = Map<String, dynamic>.from(
      attendanceBox.get(date, defaultValue: {}),
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
    String formattedDate = DateFormat('EEEE d/MM/yyyy', 'th').format(DateTime.parse(date));

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
                    builder: (context) => AttendanceDetailScreen(date: date, students: studentList),
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
                          leading: const Icon(Icons.person_off, color: Colors.red),
                          title: Text('เลขที่ ${student['number']}: ${student['name']}'),
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
  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');
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
                ...dates.map((date) => DataColumn(label: Text(_formatDate(date)))),
              ],
              rows: students.map((student) {
                return DataRow(
                  cells: [
                    DataCell(Text('${student.number}. ${student.name}')),
                    ...dates.map((date) {
                      Map<String, dynamic> attendance =
                          Map<String, dynamic>.from(attendanceBox.get(date, defaultValue: {}));
                      String status = attendance[student.number.toString()]?['status'] ?? 'ขาดเรียน';

                      return DataCell(
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              String newStatus = (status == 'มาเรียน') ? 'ขาดเรียน' : 'มาเรียน';
                              attendance[student.number.toString()]?['status'] = newStatus;
                              attendanceBox.put(date, attendance);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: (status == 'มาเรียน') ? Colors.green : Colors.red,
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