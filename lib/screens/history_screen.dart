import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../student_list.dart';
import 'package:flutter/foundation.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  final List<Student> students;
  const AttendanceHistoryScreen({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    Box attendanceBox = Hive.box('attendanceBox');
    for (var key in attendanceBox.keys) {
      if (kDebugMode) {
        print('Key: $key, Value: ${attendanceBox.get(key)}');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการขาดเรียน')),
      body: ListView(
        children: attendanceBox.keys.map((key) {
          Map<String, dynamic> attendance = Map<String, dynamic>.from(attendanceBox.get(key, defaultValue: {}));

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
            final parsedDate = DateTime.parse(key); // แปลง key เป็น DateTime
            formattedDate = DateFormat('EEEE d/MM/yyyy', 'th').format(parsedDate); // ปรับรูปแบบวันที่เป็นภาษาไทย
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
                    date: key, summaryText: '',
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
