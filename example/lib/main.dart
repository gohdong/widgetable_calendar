import 'package:flutter/material.dart';
import 'package:widgetable_calendar/widgetable_calendar.dart';
import 'package:widgetable_calendar/Bloc/calendar_controller.dart';

void main() {
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
  WidgetableCalendarController calendarController = WidgetableCalendarController();

  List<Map> _events;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events =  [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
      todayBackgroundColor: Colors.greenAccent,
      todayTextColor: Colors.yellow,
      highlightBackgroundColor: Colors.pink,
      highlightTextColor: Colors.deepOrangeAccent,
    );
  }
}
