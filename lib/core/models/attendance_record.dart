class AttendanceRecord {
  final String date;
  final String time;
  final String location;
  final bool attended;

  AttendanceRecord({
    required this.date,
    required this.time,
    required this.location,
    required this.attended,
  });

  factory AttendanceRecord.fromFirestore(Map<String, dynamic> data) {
    return AttendanceRecord(
      date: data['date'],
      time: data['time'],
      location: data['location'],
      attended: data['attended'],
    );
  }
}
