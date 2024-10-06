
class MoodData {
  String day;
  String selectedEmotion;
  int hoursSlept;
  int exerciseTime;
  String selectedPerson;
  String selectedWeather;

  MoodData({
    required this.day,
    required this.selectedEmotion,
    required this.hoursSlept,
    required this.exerciseTime,
    required this.selectedPerson,
    required this.selectedWeather,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'selectedEmotion': selectedEmotion,
      'hoursSlept': hoursSlept,
      'exerciseTime': exerciseTime,
      'selectedPerson': selectedPerson,
      'selectedWeather': selectedWeather,
    };
  }

  factory MoodData.fromMap(Map<String, dynamic> map) {
    return MoodData(
      day: map['day'],
      selectedEmotion: map['selectedEmotion'],
      hoursSlept: map['hoursSlept'],
      exerciseTime: map['exerciseTime'],
      selectedPerson: map['selectedPerson'],
      selectedWeather: map['selectedWeather'],
    );
  }
}
