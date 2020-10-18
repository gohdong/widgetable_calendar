// import 'package:widgetable_calendar/widgetable_calendar.dart';

import 'package:flutter/material.dart';
import 'package:widgetable_calendar/Bloc/calendar_bloc.dart';
import 'package:widgetable_calendar/Data/calendar_data.dart';

class WidgetableCalendarController extends WidgetableCalendarBloc{

  get stream{
    return super.streams;
  }

  WidgetableCalendarController() ;

  void init(){
    super.data.events = [];
    super.data.holidays = [];

    final now = DateTime.now();
    super.data.selectDate = _normalizeDate(now);
    super.data.focusDate = _normalizeDate(now);

    super.data.firstDay = DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
    super.data.lastDay = DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    super.data.weekList = _makeWeekList(super.data.firstDay, super.data.lastDay);
    super.streamSink();
  }

  void addEvents() {
    //TODO change testMap
    Map testMap = {data.selectDate : "test"};
    super.data.events.add(testMap);
    super.streamSink();
  }

  List findEvents(){
    List returnValue = [];
    for (int i=0 ; i < super.data.events.length ; i++){
      Map eachEvent = super.data.events[i];
      if (eachEvent.containsKey(super.data.selectDate)) returnValue.add(eachEvent);
    }
    return returnValue;
  }

  List _makeWeekList(DateTime firstDay, DateTime lastDay) {
    List<int> dateList = List<int>();

    int firstDayWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    int lastDayWeekday = lastDay.weekday == 7 ? 0 : lastDay.weekday;

    // make long date list ( ex. [-3,-2,-1,0,1,2,3,...,31]
    for (int i = firstDayWeekday; i!=0 ; i--) dateList.add(-i+1);
    for (int i = 0; lastDay.day != i; i++) dateList.add(i + 1);
    for (int i = 1; lastDayWeekday != 6; i++,lastDayWeekday++) dateList.add(i+lastDay.day);

    // split with 7 ( make it to week! )  ( ex. [ [-3,-2,-1,0,1,2,3], [4,5,...], ... ] )
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
    super.data.selectDate = day;
    super.streamSink();
  }

  bool isSelectedDate(DateTime day) {
    return day == super.data.getSelectDate;
  }

  void changeMonth(int i) {
    super.data.focusDate = i == 0
        ? _normalizeDate(DateTime.now())
        : DateTime(super.data.focusDate.year, super.data.focusDate.month + i, 1);
    super.data.firstDay = DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
    super.data.lastDay = DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    super.data.weekList = _makeWeekList(super.data.firstDay, super.data.lastDay);
    super.streamSink();
  }

  void changeMonthCompletely(int year,int month) {
    super.data.focusDate = DateTime(year, month, 1);
    super.data.firstDay = DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
    super.data.lastDay = DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    super.data.weekList = _makeWeekList(super.data.firstDay, super.data.lastDay);
    super.streamSink();
  }
}
