class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String workingHours;
  final String imageUrl;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.workingHours,
    required this.imageUrl,
    this.isAvailable = true,
  });
}

class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;
  final String status;
  final String doctorImageUrl;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
    required this.doctorImageUrl,
  });
}

class AppointmentCategory {
  final String id;
  final String name;
  final String iconName;
  final String color;

  AppointmentCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
  });
}
