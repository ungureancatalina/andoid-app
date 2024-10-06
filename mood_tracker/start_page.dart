import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mood_tracker/page2.dart';
import 'package:mood_tracker/page3.dart';
import 'package:path_provider/path_provider.dart';

class StartPage extends StatefulWidget {
  final String userEmail;

  StartPage({required this.userEmail});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<String> _datesSaved = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final filePath = await _getUserFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsLines();
      setState(() {
        _datesSaved = contents;
      });
    }
  }

  Future<String> _getUserFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${widget.userEmail}.txt';
  }

  Future<void> _saveDateToFile() async {
    final filePath = await _getUserFilePath();
    final file = File(filePath);

    String dateToSave = _selectedDay.toLocal().toString().split(' ')[0];
    if (!_datesSaved.contains(dateToSave)) {
      await file.writeAsString('$dateToSave\n', mode: FileMode.append);
      setState(() {
        _datesSaved.add(dateToSave); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);
    Color lightGreen = Color(0xFF508E5B);
    Color white = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mood Tracker',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: veryDarkGreen,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imag2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    availableCalendarFormats: {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.week: 'Week',
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    rowHeight: 90,
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                      weekendTextStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                      selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                      todayTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                      outsideTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                      outsideDaysVisible: false,
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: veryDarkGreen,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightGreen,
                      ),
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightGreen,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black, fontSize: 22.0),
                      weekendStyle: TextStyle(color: Colors.black, fontSize: 22.0),
                    ),
                    daysOfWeekHeight: 60,
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        bool isSelected = isSameDay(_selectedDay, day);
                        bool isToday = isSameDay(DateTime.now(), day);
                        bool isOutside = !_focusedDay.isAtSameMomentAs(day);

                        BoxDecoration decoration = BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOutside ? veryDarkGreen : Colors.transparent,
                        );

                        TextStyle textStyle = TextStyle(
                          color: isOutside ? Colors.white : (isSelected ? Colors.white : Colors.black),
                        );

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedDay = day;
                              _focusedDay = focusedDay ?? day;
                            });
                          },
                          child: Container(
                            decoration: decoration,
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: textStyle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _saveDateToFile();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Page2(selectedDate: _selectedDay.toLocal().toString().split(' ')[0]),
                                  ),
                                );
                              },
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: veryDarkGreen,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    'assets/imag3.jpg',
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Insides of the Day',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Page3()),
                                );
                              },
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: veryDarkGreen,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    'assets/imag4.jpg',
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Report',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: _datesSaved.map((date) => Text(date)).toList(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
