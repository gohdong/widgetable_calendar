import 'dart:async';
import 'package:widgetable_calendar/Data/calendar_data.dart';

class CalendarBloc {
  // WidgetableCalendarData calendar = WidgetableCalendarData(calendarController: null);
  StreamController<Map> _controller = StreamController();
  WidgetableCalendarData data = WidgetableCalendarData();

  List test = List();
  CalendarBloc(){
    print("init");
    data.events = [];
    data.holidays = [];

    final now = DateTime.now();
    data.selectDate = _normalizeDate(now);
    data.focusDate = _normalizeDate(now);

    data.firstDay = DateTime(data.focusDate.year, data.focusDate.month, 1);
    data.lastDay = DateTime(data.focusDate.year, data.focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    data.weekList = _makeWeekList(data.firstDay, data.lastDay);
    streamSink();
  }
  void _init(){

  }


  Stream get streams {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  void addEvents() {
    print(test);
    test.add("asd");
  }

  List _makeWeekList(DateTime firstDay, DateTime lastDay) {
    List<int> dateList = List<int>();

    int firstDayWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    int lastDayWeekday = lastDay.weekday == 7 ? 0 : lastDay.weekday;

    // make long date list ( ex. [0,0,0,0,1,2,3,...,31]
    for (int i = 0; firstDayWeekday != i; i++) dateList.add(0);
    for (int i = 0; lastDay.day != i; i++) dateList.add(i + 1);
    for (int i = lastDayWeekday; i != 6; i++) dateList.add(0);

    // split with 7 ( make it to week! )  ( ex. [ [0,0,0,0,1,2,3], [4,5,...], ... ] )
    List weekList = [];
    for (var i = 0; i < dateList.length; i += 7) {
      weekList.add(dateList.sublist(
          i, i + 7 > dateList.length ? dateList.length : i + 7));
    }
    return weekList;
  }

  DateTime _normalizeDate(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day, 0);
  }

  void setSelectDate(DateTime day, List events, List holidays) {
    data.selectDate = day;
  }

  bool isSelectedDate(DateTime day) {
    return day == data.getSelectDate;
  }

  void changeMonth(int i) {
    data.focusDate = i == 0
        ? _normalizeDate(DateTime.now())
        : DateTime(data.focusDate.year, data.focusDate.month + i, 1);
    data.firstDay = DateTime(data.focusDate.year, data.focusDate.month, 1);
    data.lastDay = DateTime(data.focusDate.year, data.focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    data.weekList = _makeWeekList(data.firstDay, data.lastDay);
    streamSink();
  }

  void streamSink(){
    _controller.sink.add(data.getData());
  }
}
