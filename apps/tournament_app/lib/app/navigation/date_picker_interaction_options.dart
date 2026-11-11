final class DatePickerInteractionOptions {
  DatePickerInteractionOptions({
    required DateTime initialDate,
    required DateTime currentDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) : initialDate = DateTime(
         initialDate.year,
         initialDate.month,
         initialDate.day,
       ),
       currentDate = DateTime(
         currentDate.year,
         currentDate.month,
         currentDate.day,
       ),
       firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day),
       lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day) {
    if (this.lastDate.isBefore(this.firstDate) ||
        this.initialDate.isBefore(this.firstDate) ||
        this.initialDate.isAfter(this.lastDate)) {
      throw ArgumentError('Invalid date picker range');
    }
  }

  final DateTime initialDate;
  final DateTime currentDate;
  final DateTime firstDate;
  final DateTime lastDate;
}
