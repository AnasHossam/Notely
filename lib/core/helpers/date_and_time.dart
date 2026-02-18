import 'package:intl/intl.dart';

String dateAndTime({DateTime? time}) {
  return DateFormat('MMMM d, yyyy . h:mm a').format(time ?? DateTime.now());
}
