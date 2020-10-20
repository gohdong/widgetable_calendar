import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis/calendar/v3.dart' as Gcal;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgetable_calendar/widgetable_calendar.dart';
import 'package:widgetable_calendar/Bloc/calendar_controller.dart';

final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "private_key_id": "900c44485d21c9c3623fb364a46b2e14863538df",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCw0XEt40my5pKf\nVtzYNt3YdUuK63c2DPST/JaV73JfwRR2iuvSCYDvsKt8K8/3tvlE9l6HZUmXzC8K\nx+DB6vhagxOWqC74ku4qC+woGWZyWJftwwqFuKLGQgo+GyJ2e7eMpopHLMk9ud0N\nkfAW+PlU99vC5VFvQtuDm5b1Hhed7rkH3Vaqnxxk2IhN3MiILjBBMTirPTg4cwHI\nsI8WTRWtr4RzK2o9NyXZUnk9JLXreOfyfu6JufKXUzaZheTmfeNGoyYw7KBWNHUs\nRMq8wMe8FU6QJTKmblbW6yv19t30rZ3D1fkIUt2D/GQ1D5DrAEzFs/x3nw2xN7D1\nwuYMC6d7AgMBAAECggEAOFmnLi6fUCp3U9yE6UsjDFblSlKcXVdnorn+662xz55i\n/Rxs5zUsKDcvj5UO5C0l57p0icXX3E6wN0lX8bUGjSH03jCfN4zr5e6CxozBv3NI\nh/d+pPsgtPpa9UwEgaoP5v00WFaHk+pl7msyDsAuBcwv9z7J4yF1f83YICoE8MmY\nng6aeXdT8BmAvumLy2h67zLRbQ1DL7QQpTThYy+77eSuReAUIK/lBbEzy+Qny/vp\nPDIfi/817pV8cPgCbtgWM+0tJZJgrrTqmOs//nsnMOMOUMcofM1CQcn9tElME6Oh\ntRPE0y5gx/LHqzJptah6jWlp5EQ0cqFq/1KXm/92UQKBgQD1ssYGDpIXeMKNga/1\n99y/xaDs0zs7KJDBphP1lJOji2Ht4NZ/VOAjFMgRszO1vWwdk1x3VAlVIB0Pfzqn\nutkMXbfuEW4DwwThOA4PqVHXtqiCDQ8c9JLkpte3U5enC4tYxa2m+sx3OqLz9CJp\nNJCZNRwLlt4o5a8aPVV3d0LhvwKBgQC4O1YdAbaEOwcjaYbta19C12u2s7f0B2+F\nRhCXvawF4nYIxpEZeY+LMYC0AlrbKXgr6WCJ0HyY4lIJgjpU47zmQWXGtkL9igXD\n+p0joayYKZSFePGkMf7B/h0FtHN1aPQeGthn7qWnyLSDRtuXi3X/uzMGdEcZaptS\ncJT2L4DxRQKBgQDR3n7ftZp8ih5FGT3gcHQTKxCmuleh1KixgNcTsnHaBLkFpEQU\nR7+ct6ed1uCYoNC1Aqa9Fv9RwziPgDHuC+BSe8scg67hb7e/WU5Jemv6Qn/1doou\nRYsj3I/ufGzRtz6z+Ua3lwsH3QJMN4EdNFU/SOpHy/rAHFFRrIpQnYJ3qQKBgGXA\nP9tdatS1VUf1rJPMTZy5JcCOmfapdKqC+/8SvsOxQ8etA86yGNmjyZWiB1QsHzcB\nelQjVe2KcgzWZCkmbtotHG0XlQA7Dtwiuk9Hp++SZ3kgRzWMd0vlcVoJRAuAn/NQ\nmF0urUdxzmEC7Z1RZSaM2a2i4vHis05g56Tgr7KRAoGBAJDQlgrcRAAeX6kQzmi2\n4Iz6xgSynIKhsuZkDlKTuerE31PIY/ZwM5wXA6fAuxq6JnCXTozxIZNOR0iCYHVa\n1LnQ63p431q0iLqb7ABohCX3WkeTl35dhX9ujfYYBQU5wlWF0aIC3Fs0SHz7GzqQ\n0XD2UQ9+M0cWwz1txV3Zgk1Z\n-----END PRIVATE KEY-----\n",
  "client_email": "364414010667-compute@developer.gserviceaccount.com",
  "client_id": "106008583085949467634",
  "type": "service_account"
}
''');

final _SCOPES = const [Gcal.CalendarApi.CalendarScope];

void main() {

  runApp(MyApp());
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgetable Calendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Widgetable Calendar Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  WidgetableCalendarController calendarController =
      WidgetableCalendarController();

  List<Map> _events;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            clientViaUserConsent(
                ClientId(
                    "364414010667-vkomcbi60k5glgt7bo5ntig2f18ikhcm.apps.googleusercontent.com",
                    ""),
                _SCOPES,
                prompt)
                .then((AuthClient client) {
              var calendar = Gcal.CalendarApi(client);
              calendar.calendarList.list().then((value) {
                value.items.forEach((element) {
                  calendar.events.list(element.id).then((value1) {
                    value1.items.forEach((element1) {
                      // print(element1.toJson());
                      calendarController.addEvents({
                        "time" : element1.toJson()['start'],
                        "title" : element1.toJson()['summary']
                      });
                    });
                  });
                });
              });
            });
          })
        ],
      ),
// <<<<<<< HEAD
//       body: Center(
//         child: WidgetableCalendar(
//           holidays: [],
//           backgroundColor: Colors.greenAccent,
//           height: MediaQuery.of(context).size.height * 0.5,
//           width: MediaQuery.of(context).size.width,
//         ),
// =======
      body: _buildCalendar(),
    );
  }

  Widget _buildCalendar() {
    return WidgetableCalendar(
      // calendarController: _calendarController,
      calendarController: calendarController,
      sundayColor: Colors.teal,
      saturdayColor: Colors.red,
      weekDayColor: Colors.black,
      backgroundColor: Colors.white.withOpacity(0),
      todayBackgroundColor: Colors.yellow,
      todayTextColor: Colors.greenAccent,
      highlightBackgroundColor: Colors.pink,
      highlightTextColor: Colors.deepOrangeAccent,
    );
  }
}
