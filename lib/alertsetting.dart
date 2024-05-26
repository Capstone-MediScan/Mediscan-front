import 'package:flutter/material.dart';
import 'package:mediscan/theme/colors.dart';

class AlertSetting extends StatefulWidget {
  final TimeOfDay initialTime;
  final List<bool> daysStatus;
  final int? alertIndex; // 알림의 인덱스를 전달하기 위한 필드

  const AlertSetting({
    Key? key,
    required this.initialTime,
    required this.daysStatus,
    this.alertIndex,
  }) : super(key: key);

  @override
  _AlertSettingState createState() => _AlertSettingState();
}

class _AlertSettingState extends State<AlertSetting> {
  late TimeOfDay selectedTime;
  late Map<String, bool> days;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
    days = {
      '월요일마다': widget.daysStatus[0],
      '화요일마다': widget.daysStatus[1],
      '수요일마다': widget.daysStatus[2],
      '목요일마다': widget.daysStatus[3],
      '금요일마다': widget.daysStatus[4],
      '토요일마다': widget.daysStatus[5],
      '일요일마다': widget.daysStatus[6],
    };
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DaySelectionModal(days: days);
      },
    );
  }

  void _deleteAlert() {
    Navigator.of(context).pop({'action': 'delete', 'index': widget.alertIndex}); // 알림 삭제 동작을 전달
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // const 추가
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'MediScan',
          style: TextStyle(color: mainColor, fontFamily: 'Inter900', fontSize: 24),
        ),
        backgroundColor: Colors.white, // 배경색을 흰색으로 설정
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red), // const 추가
            onPressed: _deleteAlert,
          ),
        ],
      ),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Container(
        padding: const EdgeInsets.all(20), // const 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _selectTime(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedTime.format(context),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold), // const 추가
                  ),
                  const SizedBox(width: 10), // const 추가
                  const Icon(Icons.keyboard_arrow_down, size: 32), // const 추가
                ],
              ),
            ),
            const SizedBox(height: 20), // const 추가
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(context),
              child: const Text('요일 선택'), // const 추가
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black12,
                padding: const EdgeInsets.symmetric(vertical: 15), // const 추가
                minimumSize: const Size(double.infinity, 50), // const 추가
              ),
            ),
            const SizedBox(height: 20), // const 추가
            TextField(
              controller: memoController,
              decoration: const InputDecoration( // const 추가
                labelText: '메모',
                border: OutlineInputBorder(),
              ),
              minLines: 9,
              maxLines: 11,
            ),
            const SizedBox(height: 20), // const 추가
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20), // const 추가
        child: ElevatedButton(
          onPressed: () {
            String formattedTime = "${selectedTime.hourOfPeriod}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}";
            Navigator.of(context).pop({'action': 'save', 'time': formattedTime}); // 시간 정보를 반환
          },
          child: const Text('저장하기', style: TextStyle(color: Colors.white)), // const 추가 및 텍스트 색상 흰색으로 설정
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF435D3D), // const 추가
            padding: const EdgeInsets.symmetric(vertical: 15), // const 추가
            minimumSize: const Size(double.infinity, 50), // const 추가
          ),
        ),
      ),
    );
  }
}

class DaySelectionModal extends StatefulWidget {
  final Map<String, bool> days;
  const DaySelectionModal({Key? key, required this.days}) : super(key: key); // const 추가

  @override
  _DaySelectionModalState createState() => _DaySelectionModalState();
}

class _DaySelectionModalState extends State<DaySelectionModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10), // const 추가
      color: Colors.white, // 배경색을 흰색으로 설정
      child: ListView(
        children: widget.days.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: widget.days[key],
            onChanged: (bool? value) {
              setState(() {
                widget.days[key] = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
