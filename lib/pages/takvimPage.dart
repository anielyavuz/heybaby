import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TakvimPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const TakvimPage({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  _TakvimPageState createState() => _TakvimPageState();
}

class _TakvimPageState extends State<TakvimPage> {
  TextEditingController planController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<Map<String, dynamic>> planlar = [];

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Plan Ekleme Formu
            TextFormField(
              controller: planController,
              decoration: InputDecoration(
                labelText: 'Yeni Plan Ekle',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _selectDate();
                await _selectTime();

                if (selectedDate != null && selectedTime != null) {
                  setState(() {
                    final formattedDate =
                        DateFormat.yMd().format(selectedDate!);
                    final formattedTime = DateFormat.Hm().format(DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    ));

                    planlar.add({
                      'text': planController.text,
                      'date': selectedDate,
                      'time': selectedTime,
                    });

                    planController.clear();
                    selectedDate = null;
                    selectedTime = null;

                    // Gelecekteki planları tarih ve saat olarak sırala
                    planlar.sort((a, b) {
                      final dateA = DateTime(
                        a['date'].year,
                        a['date'].month,
                        a['date'].day,
                        a['time'].hour,
                        a['time'].minute,
                      );
                      final dateB = DateTime(
                        b['date'].year,
                        b['date'].month,
                        b['date'].day,
                        b['time'].hour,
                        b['time'].minute,
                      );
                      return dateA.compareTo(dateB);
                    });
                  });
                }
              },
              child: Text("Plan Ekle"),
            ),
            SizedBox(height: 24.0),
            // Plan Listesi
            Text(
              'Gelecekteki Planlar',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: planlar.length,
                itemBuilder: (context, index) {
                  final plan = planlar[index];
                  final formattedDate =
                      DateFormat.yMd().format(plan['date'] as DateTime);
                  final formattedTime = DateFormat.Hm().format(DateTime(
                    plan['date'].year,
                    plan['date'].month,
                    plan['date'].day,
                    (plan['time'] as TimeOfDay).hour,
                    (plan['time'] as TimeOfDay).minute,
                  ));

                  return ListTile(
                    title:
                        Text('${plan['text']} - $formattedDate $formattedTime'),
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
