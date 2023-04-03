import 'package:get/get_rx/src/rx_types/rx_types.dart';
import "package:intl/intl.dart";

class DateTimeUtils {
  String getCurrentDate() {
    DateTime now = DateTime.now();

// Convert the date and time to epoch time (milliseconds)
    int epochTime = now.millisecondsSinceEpoch;

    return DateFormat('yyyy-MM-dd').format(now).obs.value;
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('HH:mm:ss').format(now).obs.value;
  }
}
