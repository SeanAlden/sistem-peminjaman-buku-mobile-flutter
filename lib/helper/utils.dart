DateTime _toWib(DateTime date) {
  return date.toUtc().add(const Duration(hours: 7));
}

String formatTimeWib(String iso) {
  final dt = DateTime.parse(iso).toLocal().add( const Duration(hours: 7));
  return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
}

String formatDateWib(String iso) {
  final dt = DateTime.parse(iso).toLocal().add( const Duration(hours: 7));
  return "${dt.day.toString().padLeft(2, '0')} "
      "${_monthName(dt.month)} ${dt.year}";
}

String _monthName(int month) {
  const months = [
    "Januari", "Februari", "Maret", "April", "Mei", "Juni",
    "Juli", "Agustus", "September", "Oktober", "November", "Desember"
  ];
  return months[month - 1];
}
