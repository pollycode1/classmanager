import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../student_list.dart';
import 'history_screen.dart';

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
      print("Attendance data is missing or incomplete.");
    }
  }

  void updateSummaryBox() {
    String dateKey = selectedDate.toIso8601String().split('T')[0];
    Box summaryBox = Hive.box('summaryBox');
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
        'malePresent': malePresentCount,
        'femalePresent': femalePresentCount,
        'totalPresent': malePresentCount + femalePresentCount,
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
