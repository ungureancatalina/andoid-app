import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'mood_storage.dart';
import 'package:intl/intl.dart';

class Page2 extends StatefulWidget {
  final String selectedDate;

  Page2({required this.selectedDate});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final ImagePicker _picker = ImagePicker();
  String dailyResume = '';
  int hoursSlept = 0;
  int exerciseTime = 0;
  String selectedDayEmotion = '';
  String selectedPerson = 'p1';
  String selectedWeather = 'sunny';
  List<String> selectedEmotions = [];
  File? selectedImage;

  Future<void> _saveData() async {
    String date = widget.selectedDate;

    Map<String, dynamic> data = {
      'dailyResume': dailyResume,
      'hoursSlept': hoursSlept,
      'exerciseTime': exerciseTime,
      'dayEmotion': selectedDayEmotion,
      'person': selectedPerson,
      'weather': selectedWeather,
      'emotions': selectedEmotions,
    };

    await DataStorage.saveData(date, data);
  }

  Future<void> _loadData() async {
    String date = widget.selectedDate;
    Map<String, dynamic> data = await DataStorage.loadData(date);

    if (data.isNotEmpty) {
      setState(() {
        dailyResume = data['dailyResume'] ?? '';
        hoursSlept = data['hoursSlept'] ?? 0;
        exerciseTime = data['exerciseTime'] ?? 0;
        selectedDayEmotion = data['dayEmotion'] ?? '';
        selectedPerson = data['person'] ?? 'p1';
        selectedWeather = data['weather'] ?? 'sunny';
        selectedEmotions = List<String>.from(data['emotions'] ?? []);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your thoughts',
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
              _buildDayEmotions(),
              _buildEmotions(),
              _buildPeopleSelection(),
              _buildWeatherSelection(),
              _buildDailyResume(),
              _buildPhotoUpload(),
              _buildHoursSlept(),
              _buildExerciseTime(),
              _buildDoneButton(veryDarkGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayEmotions() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            'How was your day?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dayEmotionButton('em1', 'assets/em1.jpg'),
              SizedBox(width: 8.0),
              dayEmotionButton('em2', 'assets/em2.jpg'),
              SizedBox(width: 8.0),
              dayEmotionButton('em3', 'assets/em3.jpg'),
              SizedBox(width: 8.0),
              dayEmotionButton('em4', 'assets/em4.jpg'),
              SizedBox(width: 8.0),
              dayEmotionButton('em5', 'assets/em5.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotions() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            'Emotions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Wrap(
              spacing: 15.0,
              runSpacing: 15.0,
              alignment: WrapAlignment.center,
              children: _emotionButtons(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _emotionButtons() {
    List<String> emotions = [
      'calm', 'happy', 'excited', 'cheerful', 'in_love',
      'friendly', 'shocked', 'singing', 'speachless', 'confused',
      'nervous', 'crying', 'stressed', 'lonely', 'sad',
      'unbothered', 'anxious', 'annoyed', 'angry', 'sick',
      'unfocussed', 'disoriented', 'sleepy', 'proud'
    ];

    return emotions.map((emotion) {
      return emotionButton(emotion, 'assets/$emotion.jpg');
    }).toList();
  }

  Widget _buildPeopleSelection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            'People',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              personButton('p1', 'assets/p1.jpg', 'Family'),
              SizedBox(width: 8.0),
              personButton('p2', 'assets/p2.jpg', 'Friends'),
              SizedBox(width: 8.0),
              personButton('p3', 'assets/p3.jpg', 'Partner'),
              SizedBox(width: 8.0),
              personButton('p4', 'assets/p4.jpg', 'Alone'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherSelection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            'Weather',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              weatherButton('w1', 'assets/w1.jpg', 'Sunny'),
              SizedBox(width: 8.0),
              weatherButton('w2', 'assets/w2.jpg', 'Cloudy'),
              SizedBox(width: 8.0),
              weatherButton('w3', 'assets/w3.jpg', 'Rainy'),
              SizedBox(width: 8.0),
              weatherButton('w4', 'assets/w4.jpg', 'Stormy'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyResume() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) {
          dailyResume = value;
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Write your daily resume here...',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
        maxLines: 3,
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () async {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        setState(() {
          if (pickedFile != null) {
            selectedImage = File(pickedFile.path);
          } else {
            print('No image selected.');
          }
        });
      },
      child: Container(
        height: 200.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: selectedImage != null
            ? Image.file(
          selectedImage!,
          fit: BoxFit.cover,
        )
            : Center(
          child: Text(
            'Tap to upload a photo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDoneButton(Color veryDarkGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: ElevatedButton(
        onPressed: () async {
          await _saveData(); // Save data before navigating back
          Navigator.pop(context);
        },
        child: Text(
          'All done',
          style: TextStyle(fontSize: 18.0),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: veryDarkGreen,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        ),
      ),
    );
  }


  Widget _buildHoursSlept() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hours Slept',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    if (hoursSlept > 0) hoursSlept--;
                  });
                },
              ),
              Text(
                '$hoursSlept hours',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    hoursSlept++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTime() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise Time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    if (exerciseTime >= 10) {
                      exerciseTime -= 10;
                    }
                  });
                },
              ),
              Text(
                '$exerciseTime min',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  setState(() {
                    exerciseTime += 10;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emotionButton(String label, String assetPath) {
    bool isSelected = selectedEmotions.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedEmotions.remove(label);
          } else {
            if (selectedEmotions.length < 3) {
              selectedEmotions.add(label);
            }
          }
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: selectedEmotions.contains(label) ? 80.0 : 100.0,
            height: selectedEmotions.contains(label) ? 80.0 : 100.0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.grey[800],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  height: selectedEmotions.contains(label) ? 80.0 : 100.0,
                  width: selectedEmotions.contains(label) ? 80.0 : 100.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget personButton(String label, String assetPath, String text) {
    bool isSelected = selectedPerson == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPerson = label;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isSelected ? 80.0 : 60.0,
            height: isSelected ? 80.0 : 60.0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[800],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  height: isSelected ? 80.0 : 60.0,
                  width: isSelected ? 80.0 : 60.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget dayEmotionButton(String label, String assetPath) {
    bool isSelected = selectedDayEmotion == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDayEmotion = label;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: isSelected ? 80.0 : 60.0,
        height: isSelected ? 80.0 : 60.0,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[800],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              height: isSelected ? 80.0 : 60.0,
              width: isSelected ? 80.0 : 60.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget weatherButton(String label, String assetPath, String text) {
    bool isSelected = selectedWeather == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWeather = label;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isSelected ? 80.0 : 60.0,
            height: isSelected ? 80.0 : 60.0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[800],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  height: isSelected ? 80.0 : 60.0,
                  width: isSelected ? 80.0 : 60.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}




