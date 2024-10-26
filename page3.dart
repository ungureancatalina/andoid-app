import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mood_storage.dart';
import 'package:fl_chart/fl_chart.dart';

extension StringCapitalization on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool isWeeklyPressed = true;
  Color weeklyButtonColor = Color(0xFF006600);
  Color monthlyButtonColor = Color(0xFF003300);

  DateTime _selectedDay = DateTime.now();
  List<double> moodAverages = [0.0, 0.0, 0.0, 0.0, 0.0];
  List<List<int>> moodFlowData = [];
  List<MapEntry<String, int>> emotionCounts = [];
  List<double> hoursSleptData = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0];

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final moodData = await _calculateMoodAverages();
    moodAverages = moodData['averages'];
    moodFlowData = moodData['dailyMoodCounts'];
    emotionCounts = moodData['emotionCounts'];
    setState(() {});
  }

  Future<Map<String, dynamic>> _calculateMoodAverages() async {
    DateTime startDate, endDate;
    if (isWeeklyPressed) {
      startDate = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
      endDate = startDate.add(Duration(days: 6));
    } else {
      startDate = DateTime(_selectedDay.year, _selectedDay.month, 1);
      endDate = DateTime(_selectedDay.year, _selectedDay.month + 1, 0);
    }

    List<int> moodCounts = List<int>.filled(5, 0);
    List<List<int>> dailyMoodCounts = List.generate(7, (_) => List.filled(5, 0));
    int totalEntries = 0;

    Map<String, int> emotionCountMap = {
      'calm': 0,
      'happy': 0,
      'excited': 0,
      'cheerful': 0,
      'in_love': 0,
      'friendly': 0,
      'shocked': 0,
      'singing': 0,
      'speachless': 0,
      'confused': 0,
      'nervous': 0,
      'crying': 0,
      'stressed': 0,
      'lonely': 0,
      'sad': 0,
      'unbothered': 0,
      'anxious': 0,
      'annoyed': 0,
      'angry': 0,
      'sick': 0,
      'unfocussed': 0,
      'disoriented': 0,
      'sleepy': 0,
      'proud': 0,
    };

    for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      Map<String, dynamic> data = await DataStorage.loadData(formattedDate);

      if (data.isNotEmpty) {
        // Handle dayEmotion for moodCounts
        if (data['dayEmotion'] != null) {
          String dayEmotion = data['dayEmotion'];
          int moodIndex = int.tryParse(dayEmotion.replaceAll('em', '')) ?? 0;
          if (moodIndex > 0 && moodIndex <= 5) {
            moodCounts[moodIndex - 1]++;
            totalEntries++;
            if (isWeeklyPressed) {
              int dayOfWeek = date.weekday - 1;
              dailyMoodCounts[dayOfWeek][moodIndex - 1]++;
            }
          }
        }

        if (data['emotions'] is List) {
          for (String emotion in data['emotions']) {
            emotionCountMap[emotion] = emotionCountMap[emotion]! + 1;
          }
        }
      }
    }

    List<double> averages = List.generate(5, (index) => totalEntries > 0 ? (moodCounts[index] * 100 / totalEntries) : 0.0);
    List<MapEntry<String, int>> emotionCounts = emotionCountMap.entries.where((entry) => entry.value > 0).toList();

    return {
      'averages': averages,
      'dailyMoodCounts': dailyMoodCounts,
      'emotionCounts': emotionCounts,
    };
  }

  String getEmotionKey(int index) {
    switch (index) {
      case 1: return 'calm';
      case 2: return 'happy';
      case 3: return 'excited';
      case 4: return 'cheerful';
      case 5: return 'in_love';
    // Add more mappings as needed
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your report',
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imag2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildButtonRow(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    isWeeklyPressed
                        ? _getWeeklyReportText()
                        : _getMonthlyReportText(),
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              _buildMoodBarBox(),
              _buildMoodFlowBox(),
              _buildFrequentEmotionsBox(),
              _buildHoursSleptBox(),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeeklyReportText() {
    DateTime startOfWeek = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    return "${DateFormat('MMMM d').format(startOfWeek)} - ${DateFormat('d').format(endOfWeek)}";
  }

  String _getMonthlyReportText() {
    String monthName = DateFormat('MMMM').format(_selectedDay);
    return "$monthName";
  }

  Widget _buildButtonRow(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isWeeklyPressed) {
                  _selectedDay = _selectedDay.subtract(Duration(days: 7));
                } else {
                  _selectedDay = DateTime(_selectedDay.year, _selectedDay.month - 1);
                }
              });
              _loadMoodData();
              print('Previous button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: veryDarkGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              '<',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isWeeklyPressed = true;
                weeklyButtonColor = Color(0xFF006600);
                monthlyButtonColor = Color(0xFF003300);
              });
              _loadMoodData();
              print('Weekly report button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: weeklyButtonColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              'Weekly',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isWeeklyPressed = false;
                monthlyButtonColor = Color(0xFF006600);
                weeklyButtonColor = Color(0xFF003300);
              });
              _loadMoodData();
              print('Monthly report button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: monthlyButtonColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              'Monthly',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isWeeklyPressed) {
                  _selectedDay = _selectedDay.add(Duration(days: 7));
                } else {
                  _selectedDay = DateTime(_selectedDay.year, _selectedDay.month + 1);
                }
              });
              _loadMoodData();
              print('Next button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: veryDarkGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              '>',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBarBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Bar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          _buildMoodBar('assets/em1.jpg', moodAverages[0]),
          _buildMoodBar('assets/em2.jpg', moodAverages[1]),
          _buildMoodBar('assets/em3.jpg', moodAverages[2]),
          _buildMoodBar('assets/em4.jpg', moodAverages[3]),
          _buildMoodBar('assets/em5.jpg', moodAverages[4]),
        ],
      ),
    );
  }

  Widget _buildMoodBar(String imagePath, double percentage) {
    double circlePosition = percentage / 100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: 30,
          height: 30,
        ),
        SizedBox(width: 10),
        Stack(
          children: [
            Container(
              width: 300,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                widthFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 300 * circlePosition - 7.5,
              top: -5,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodFlowBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Flow',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getMoodColor(value.toInt()),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                maxY: 6,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateMoodFlowSpots(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequentEmotionsBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequent Emotions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: emotionCounts.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    _buildEmotionImage(entry.key),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${entry.key.capitalize()} usages:  ${entry.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursSleptBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hours Slept',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                maxY: 14,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateHoursSleptSpots(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateHoursSleptSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < hoursSleptData.length; i++) {
      spots.add(FlSpot(i.toDouble(), hoursSleptData[i]));
    }
    return spots;
  }


  Widget _buildEmotionImage(String emotion) {
    String imagePath = 'assets/$emotion.jpg';
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
    );
  }

  List<FlSpot> _generateMoodFlowSpots() {
    List<FlSpot> spots = [];
    if (isWeeklyPressed) {
      for (int i = 0; i < 7; i++) {
        if (i < moodAverages.length) {
          double moodValue = moodAverages[i];
          double normalizedMoodValue = _normalizeMoodValue(moodValue);
          spots.add(FlSpot(i.toDouble(), normalizedMoodValue));
        }
      }
    } else {
      for (int i = 0; i < 4; i++) {
        double weeklySum = 0;
        int count = 0;
        for (int j = 0; j < 7; j++) {
          int dayIndex = (i * 7) + j;
          if (dayIndex < moodAverages.length) {
            weeklySum += moodAverages[dayIndex];
            count++;
          }
        }
        double averageMood = count > 0 ? weeklySum / count : 0.0;
        double normalizedMoodValue = _normalizeMoodValue(averageMood);
        spots.add(FlSpot(i.toDouble(), normalizedMoodValue));
      }
    }
    return spots;
  }

  double _normalizeMoodValue(double moodValue) {
    if (moodValue <= 0) return 1.0;
    return 1 + (moodValue / 20).floorToDouble();
  }

  Color _getMoodColor(int value) {
    Color darkGreen = Color(0xFF006400);
    Color mediumgreen = Color(0xFF00B200);
    switch (value) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.green;
      case 4:
        return mediumgreen;
      case 5:
        return darkGreen;
      default:
        return Colors.transparent;
    }
  }
}

