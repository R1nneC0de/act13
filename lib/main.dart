import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingTutorial());
}

class MessagingTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Messaging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase Messaging'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? title;

  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? _token;
  List<String> notificationHistory = [];

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Get FCM token
    messaging.getToken().then((value) {
      setState(() {
        _token = value;
      });
      print("🟢 FCM Token: $_token");
    });

    // Subscribe to topic (optional)
    messaging.subscribeToTopic("messaging");

    // Handle messages in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      String message = event.notification?.body ?? 'No message';
      String type = event.data['type'] ?? 'normal';

      // Vibration for important
      if (type == 'important') {
        HapticFeedback.heavyImpact();
      }

      // Save history
      setState(() {
        notificationHistory.add('$type: $message');
      });

      // Show styled dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                type == 'important' ? Colors.red[50] : Colors.white,
            title: Text(
              type == 'important' ? '🚨 IMPORTANT' : '🔔 Notification',
              style: TextStyle(
                color: type == 'important' ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: type == 'important' ? Colors.red[900] : Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                    color: type == 'important' ? Colors.red : Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    });

    // Handle when notification is tapped
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('🔁 Notification clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Messaging Tutorial",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SelectableText(
              "FCM Token:\n${_token ?? 'Loading...'}",
              style: TextStyle(fontSize: 12),
            ),
            Divider(height: 30),
            Text("📋 Notification History",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: notificationHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(notificationHistory[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
