import 'package:flutter/material.dart';
import 'package:widgetable_calendar/widgetable_calendar.dart';

class WidgetableCalendarData {
  // final CalendarController calendarController;
  DateTime selectDate;
  OnCalendarCreated onCalendarCreated;
  OnDaySelected onDaySelected;

//  DateTime focusDate;
  List holidays;
  Map<DateTime, List<String>> eventsByDate;
  Map<String, Map> eachEvent;
//  DateTime firstDay;
//  DateTime lastDay;
//  List weekList;
//  List prevWeekList;
//  List nextWeekList;
  Map<String, Map> labelColorMap;

  CalendarFormat calendarFormat;

//  double startDXPoint = 0;
//  double endDXPoint = 0;

  WidgetableCalendarData(
      {Key key,
      // @required this.calendarController,
      this.onCalendarCreated,
      this.onDaySelected,
      this.selectDate,
      this.holidays,
//      this.firstDay,
//      this.focusDate,
//      this.lastDay,
//      this.weekList,
//      this.prevWeekList,
//      this.nextWeekList,
      this.labelColorMap,
      this.calendarFormat});

  // WidgetableCalendarData.fromJson(Map json)
  //     :
  //       // calendarController = json['calendarController'],
  //       onCalendarCreated = json['onCalendarCreated'],
  //       onDaySelected = json['onDaySelected'],
  //       selectDate = json['selectDate'],
  //       holidays = json['holidays'],
  //       events = json['events'];
  DateTime get getSelectDate => selectDate;

  set setSelectDate(DateTime date) => selectDate = date;

  Map getData() {
    return {
      'onCalendarCreated': onCalendarCreated,
      "onDaySelected": onDaySelected,
      "selectDate": selectDate,
      "holidays": holidays,
//      "focusDate": focusDate,
//      "firstDay": firstDay,
//      "lastDay": lastDay,
//      "weekList": weekList,
      "eventsByDate": eventsByDate,
      "eachEvent": eachEvent,
//      "prevWeekList": prevWeekList,
//      "nextWeekList": nextWeekList,
      "labelColorMap" : labelColorMap,
      "calendarFormat": calendarFormat
    };
  }
}
