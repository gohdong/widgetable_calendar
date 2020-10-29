import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis/calendar/v3.dart' as Gcal;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgetable_calendar/widgetable_calendar.dart';
import 'package:widgetable_calendar/Bloc/calendar_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "private_key_id": "900c44485d21c9c3623fb364a46b2e14863538df",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCw0XEt40my5pKf\nVtzYNt3YdUuK63c2DPST/JaV73JfwRR2iuvSCYDvsKt8K8/3tvlE9l6HZUmXzC8K\nx+DB6vhagxOWqC74ku4qC+woGWZyWJftwwqFuKLGQgo+GyJ2e7eMpopHLMk9ud0N\nkfAW+PlU99vC5VFvQtuDm5b1Hhed7rkH3Vaqnxxk2IhN3MiILjBBMTirPTg4cwHI\nsI8WTRWtr4RzK2o9NyXZUnk9JLXreOfyfu6JufKXUzaZheTmfeNGoyYw7KBWNHUs\nRMq8wMe8FU6QJTKmblbW6yv19t30rZ3D1fkIUt2D/GQ1D5DrAEzFs/x3nw2xN7D1\nwuYMC6d7AgMBAAECggEAOFmnLi6fUCp3U9yE6UsjDFblSlKcXVdnorn+662xz55i\n/Rxs5zUsKDcvj5UO5C0l57p0icXX3E6wN0lX8bUGjSH03jCfN4zr5e6CxozBv3NI\nh/d+pPsgtPpa9UwEgaoP5v00WFaHk+pl7msyDsAuBcwv9z7J4yF1f83YICoE8MmY\nng6aeXdT8BmAvumLy2h67zLRbQ1DL7QQpTThYy+77eSuReAUIK/lBbEzy+Qny/vp\nPDIfi/817pV8cPgCbtgWM+0tJZJgrrTqmOs//nsnMOMOUMcofM1CQcn9tElME6Oh\ntRPE0y5gx/LHqzJptah6jWlp5EQ0cqFq/1KXm/92UQKBgQD1ssYGDpIXeMKNga/1\n99y/xaDs0zs7KJDBphP1lJOji2Ht4NZ/VOAjFMgRszO1vWwdk1x3VAlVIB0Pfzqn\nutkMXbfuEW4DwwThOA4PqVHXtqiCDQ8c9JLkpte3U5enC4tYxa2m+sx3OqLz9CJp\nNJCZNRwLlt4o5a8aPVV3d0LhvwKBgQC4O1YdAbaEOwcjaYbta19C12u2s7f0B2+F\nRhCXvawF4nYIxpEZeY+LMYC0AlrbKXgr6WCJ0HyY4lIJgjpU47zmQWXGtkL9igXD\n+p0joayYKZSFePGkMf7B/h0FtHN1aPQeGthn7qWnyLSDRtuXi3X/uzMGdEcZaptS\ncJT2L4DxRQKBgQDR3n7ftZp8ih5FGT3gcHQTKxCmuleh1KixgNcTsnHaBLkFpEQU\nR7+ct6ed1uCYoNC1Aqa9Fv9RwziPgDHuC+BSe8scg67hb7e/WU5Jemv6Qn/1doou\nRYsj3I/ufGzRtz6z+Ua3lwsH3QJMN4EdNFU/SOpHy/rAHFFRrIpQnYJ3qQKBgGXA\nP9tdatS1VUf1rJPMTZy5JcCOmfapdKqC+/8SvsOxQ8etA86yGNmjyZWiB1QsHzcB\nelQjVe2KcgzWZCkmbtotHG0XlQA7Dtwiuk9Hp++SZ3kgRzWMd0vlcVoJRAuAn/NQ\nmF0urUdxzmEC7Z1RZSaM2a2i4vHis05g56Tgr7KRAoGBAJDQlgrcRAAeX6kQzmi2\n4Iz6xgSynIKhsuZkDlKTuerE31PIY/ZwM5wXA6fAuxq6JnCXTozxIZNOR0iCYHVa\n1LnQ63p431q0iLqb7ABohCX3WkeTl35dhX9ujfYYBQU5wlWF0aIC3Fs0SHz7GzqQ\n0XD2UQ9+M0cWwz1txV3Zgk1Z\n-----END PRIVATE KEY-----\n",
  "client_email": "364414010667-compute@developer.gserviceaccount.com",
  "client_id": "106008583085949467634",
  "type": "service_account"
}
''');

void main() {
  print(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  runApp(MyApp());
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

  Map entireColorMap;

  @override
  void initState() {
    getLabelColorMap();
    super.initState();
  }

  Future<void> getLabelColorMap() async{
    Map temp = await calendarController.getLabelColorMap();
    setState(() {
      entireColorMap = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          calendarController.toggleCalendarFormat();

        },
      ),
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                calendarController.sinkWithGoogleCalendar(
                    "364414010667-vkomcbi60k5glgt7bo5ntig2f18ikhcm.apps.googleusercontent.com");
                setState(() {});
              })
        ],
      ),
      body: _buildCalendar(),
    );
  }

  Widget _buildCalendar() {
    Map holiday = {
      DateTime(2020, 10, 3).microsecondsSinceEpoch.toString(): {
        'summary': 'National Foundation Day',
        'start': DateTime(2020, 10, 3),
        'end': DateTime(2020, 10, 3).add(Duration(days: 1)),
        'recurrence': null,
        'labelColor': "holiday"
      },
      DateTime(2020, 10, 9).microsecondsSinceEpoch.toString(): {
        'summary': 'Hangul Day',
        'start': DateTime(2020, 10, 9),
        'end': DateTime(2020, 10, 9).add(Duration(days: 1)),
        'recurrence': null,
        'labelColor': "holiday"
      },
    };
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
      weekStartIndex: 0,
      weekList: ["일", "월", "화", "수", "목", "금", "토"],
      holiday: holiday,
      headerEnable: true,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Label Example',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          _buildLabels(),
        ],
      ),
    );
  }

  Widget _buildLabels() {
    var children = <Widget>[];

    if (entireColorMap == null){
      getLabelColorMap();
    }
    if (entireColorMap != null) {
      children = <Widget>[];
      entireColorMap.forEach((key, value) {
        if (key != "empty") {
          Color labelColor = calendarController.getLabelColor(key);
          bool toggle = calendarController.getLabelColorToggle(key);
          children.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 30,
                        width: 30,
                        color:
                            toggle ? labelColor : labelColor.withOpacity(0.3),
                      ),
                    ),
                    onPressed: () {
                      calendarController.toggleLabel(key);
                      setState(() {});
                    },
                  ),
                  Text(
                    value['name'].toString().toUpperCase(),
                    textScaleFactor: 1.1,
                    style: TextStyle(
                        color: toggle
                            ? Colors.black
                            : Colors.black.withOpacity(0.3)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  key != "holiday" ? deleteLabelWidget(key) : Container(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: changeLabelWidget(key),
                  ),
                ],
              ),
            ],
          ));
        }
      });
    }
    children.add(addLabelWidget());
    return Column(
      children: children,
    );
  }

  Widget addLabelWidget() {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pop();
        colorSlider(0);
      },
    );
  }

  Widget changeLabelWidget(String key) {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.of(context).pop();
          colorSlider(1, key: key);
        });
  }

  Widget deleteLabelWidget(String key){
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Really?"),
                content: Text("Really Delete?"),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      await calendarController.deleteLabel(key);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  void colorSlider(int type, {String key}) {
    Color origin;
    if (key != null) origin = calendarController.getLabelColor(key);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color resultColor = Colors.black;
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: SlidePicker(
              pickerColor: type == 0 ? Colors.black : origin,
              onColorChanged: (Color change) {
                resultColor = change;
              },
              paletteType: PaletteType.rgb,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: false,
              showIndicator: true,
              indicatorBorderRadius: const BorderRadius.vertical(
                top: const Radius.circular(25.0),
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (type == 0) {
                  // { colorKey(random value string) : { "name" : customName, "color" : customColor, "toggle" : true or false }  }
                  calendarController.addLabel({
                    DateTime.now().microsecondsSinceEpoch.toString(): {
                      "name": "testLabel",
                      "color": resultColor,
                      "toggle": true,
                    }
                  });
                } else if (type == 1) {
                  calendarController.changeEntireLabelColor(key, resultColor);
                }
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
