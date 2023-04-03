import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationController{


  @override
  Future<void> init() async {
    await Firebase.initializeApp();
  }


  Future<void> setupMembershipExpireNotification(DateTime expiryDate,int notificationID) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled',
        title: 'Scheduled Notification',
        body: 'This notification was scheduled for the future',
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: false,
        payload: {
          'uuid': 'uuid-test',
          'notificationType': 'Scheduled',
          'schedulerID': 'calendarEvent.schedulerID'
      },
      ),
      schedule: NotificationCalendar.fromDate(
        // schedule the notification to be displayed in 5 seconds
        date: expiryDate.toLocal(),
        repeats: true,
      ),
    );
  }


}