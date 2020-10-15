import 'package:flutter/material.dart';
import 'package:widgetable_calendar/widgetable_calendar.dart';

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

  CalendarController _calendarController;
  List<Map> _events;
  List _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    final _selectedDay = DateTime.now();

    DateTime today = DateTime.now();
    _events =  [{DateTime(today.year,today.month,today.day):"예시"}];
    _selectedEvents = _calendarController.findEvents(_events,DateTime(today.year,today.month,today.day));
  }

//  List findEvents(List events,DateTime selectDate){
//    List returnValue = [];
//    for (int i=0 ; i < events.length ; i++){
//      Map eachEvent = events[i];
//      if (eachEvent.containsKey(selectDate)) returnValue.add(eachEvent);
//    }
//    return returnValue;
//  }


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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildCalendar(),
          FlatButton(onPressed: () {
            setState(() {
              _events.add({_calendarController.selectDate:"앱의 일정추가 기능~"});
            });
          }, child: Text("앱의 일정추가 기능")),
          Expanded(child:_buildEventList()),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return WidgetableCalendar(
      calendarController: _calendarController,
      saturdayColor: Colors.green,
      weekDayColor: Colors.purple,
      backgroundColor: Colors.white.withOpacity(0),
      events: _events,
      onDaySelected: _onDaySelected,

//      calendarController: _calendarController,
//      initialSelectedDay: DateTime.now(),
    );
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
//    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = _calendarController.findEvents(_events,_calendarController.selectDate);
    });
  }


  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents != null ? _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList() : Container(),
    );
  }
}
