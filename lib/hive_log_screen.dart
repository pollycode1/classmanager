import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveLogScreen extends StatefulWidget {
  const HiveLogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HiveLogScreenState createState() => _HiveLogScreenState();
}

class _HiveLogScreenState extends State<HiveLogScreen> {
  late Box attendanceBox;
  late Box summaryBox;
  late Box customAttendanceBox;

  @override
  void initState() {
    super.initState();
    attendanceBox = Hive.box('attendanceBox');
    summaryBox = Hive.box('summaryBox');
    customAttendanceBox = Hive.box('customAttendanceBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log ข้อมูล Hive'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text('Attendance Box:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...attendanceBox.keys.map((key) {
                    return ListTile(
                      title: Text('Key: $key, Value: ${attendanceBox.get(key)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            attendanceBox.delete(key);
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text('Summary Box:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...summaryBox.keys.map((key) {
                    return ListTile(
                      title: Text('Key: $key, Value: ${summaryBox.get(key)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            summaryBox.delete(key);
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text('Custom Attendance Box:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...customAttendanceBox.keys.map((key) {
                    return ListTile(
                      title: Text('Key: $key, Value: ${customAttendanceBox.get(key)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            customAttendanceBox.delete(key);
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
