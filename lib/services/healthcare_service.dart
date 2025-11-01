import '../models/healthcare_models.dart';

class HealthcareService {
  static final HealthcareService _instance = HealthcareService._internal();
  factory HealthcareService() => _instance;
  HealthcareService._internal();

  // Sample doctors data
  List<Doctor> getAllDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Ronald Richards',
        specialty: 'Neuro Medicine',
        rating: 4.8,
        workingHours: '5:00 pm to 8:00 pm',
        imageUrl:
            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=100&h=100&fit=crop&crop=face',
      ),
      Doctor(
        id: '2',
        name: 'Dr. Sarah Johnson',
        specialty: 'Cardiology & Medicine',
        rating: 4.9,
        workingHours: '4:00 pm to 7:00 pm',
        imageUrl:
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=100&h=100&fit=crop&crop=face',
      ),
      Doctor(
        id: '3',
        name: 'Dr. Michael Chen',
        specialty: 'Dental Surgery',
        rating: 4.7,
        workingHours: '9:00 am to 5:00 pm',
        imageUrl:
            'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=100&h=100&fit=crop&crop=face',
      ),
      Doctor(
        id: '4',
        name: 'Dr. Emily Davis',
        specialty: 'General Medicine',
        rating: 4.8,
        workingHours: '10:00 am to 6:00 pm',
        imageUrl:
            'https://images.unsplash.com/photo-1594824475317-87096b0a6b83?w=100&h=100&fit=crop&crop=face',
      ),
    ];
  }

  List<Doctor> getDoctorsByCategory(String category) {
    final allDoctors = getAllDoctors();
    if (category == 'All') {
      return allDoctors;
    }
    return allDoctors
        .where(
          (doctor) =>
              doctor.specialty.toLowerCase().contains(category.toLowerCase()),
        )
        .toList();
  }

  // Sample appointments data
  List<Appointment> getUpcomingAppointments() {
    return [
      Appointment(
        id: '1',
        doctorId: '1',
        doctorName: 'Dr. Ronald Richards',
        specialty: 'Neuro Medicine',
        date: DateTime.now().add(const Duration(days: 3)),
        time: '5:00 PM to 5:15 PM',
        status: 'confirmed',
        doctorImageUrl:
            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=100&h=100&fit=crop&crop=face',
      ),
      Appointment(
        id: '2',
        doctorId: '2',
        doctorName: 'Dr. Sarah Johnson',
        specialty: 'Cardiology',
        date: DateTime.now().add(const Duration(days: 7)),
        time: '2:00 PM to 2:30 PM',
        status: 'pending',
        doctorImageUrl:
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=100&h=100&fit=crop&crop=face',
      ),
    ];
  }

  List<Appointment> getPastAppointments() {
    return [
      Appointment(
        id: '3',
        doctorId: '3',
        doctorName: 'Dr. Michael Chen',
        specialty: 'Dental Surgery',
        date: DateTime.now().subtract(const Duration(days: 10)),
        time: '10:00 AM to 10:30 AM',
        status: 'completed',
        doctorImageUrl:
            'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=100&h=100&fit=crop&crop=face',
      ),
      Appointment(
        id: '4',
        doctorId: '4',
        doctorName: 'Dr. Emily Davis',
        specialty: 'General Medicine',
        date: DateTime.now().subtract(const Duration(days: 30)),
        time: '3:00 PM to 3:30 PM',
        status: 'completed',
        doctorImageUrl:
            'https://images.unsplash.com/photo-1594824475317-87096b0a6b83?w=100&h=100&fit=crop&crop=face',
      ),
    ];
  }

  List<AppointmentCategory> getCategories() {
    return [
      AppointmentCategory(
        id: '1',
        name: 'All',
        iconName: 'apps',
        color: '0xFF00E676',
      ),
      AppointmentCategory(
        id: '2',
        name: 'Cardiology',
        iconName: 'favorite',
        color: '0xFFFF5722',
      ),
      AppointmentCategory(
        id: '3',
        name: 'Medicine',
        iconName: 'medication',
        color: '0xFF7B68EE',
      ),
      AppointmentCategory(
        id: '4',
        name: 'Dental',
        iconName: 'medical_services',
        color: '0xFF2196F3',
      ),
    ];
  }

  // Booking appointment
  Future<bool> bookAppointment({
    required String doctorId,
    required DateTime date,
    required String time,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  // Cancel appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // Get doctor details
  Doctor? getDoctorById(String doctorId) {
    final doctors = getAllDoctors();
    try {
      return doctors.firstWhere((doctor) => doctor.id == doctorId);
    } catch (e) {
      return null;
    }
  }
}
