// import 'package:widgetable_calendar/widgetable_calendar.dart';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleCalendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgetable_calendar/Bloc/calendar_bloc.dart';
import 'package:widgetable_calendar/Data/calendar_data.dart';

class WidgetableCalendarController extends WidgetableCalendarBloc {
  List googleCalendarList = [];

  get stream {
    return super.streams;
  }

  WidgetableCalendarController();

  void init() {
    super.data.holidays = [];
    super.data.eventsByDate = {};
    super.data.eachEvent = {};

    final now = DateTime.now();
    super.data.selectDate = _normalizeDate(now);
//    super.data.focusDate = _normalizeDate(now);

//    super.data.firstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
//    super.data.lastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
//            .subtract(new Duration(days: 1));
//
//    DateTime prevFirstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month - 1, 1);
//    DateTime prevLastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1)
//            .subtract(new Duration(days: 1));
//
//    DateTime nextFirstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1);
//    DateTime nextLastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 2, 1)
//            .subtract(new Duration(days: 1));
//
//    super.data.weekList =
//        _makeWeekList(super.data.firstDay, super.data.lastDay);
//    super.data.prevWeekList = _makeWeekList(prevFirstDay, prevLastDay);
//    super.data.nextWeekList = _makeWeekList(nextFirstDay, nextLastDay);


    super.data.labelColorMap = {
      "0" : Colors.red,
      "1" : Colors.green,
      "2" : Colors.yellowAccent,
      "empty" : Colors.grey,
      "google" : Colors.blue
    };

    //TODO Change labelColorMap ( key values )

    super.streamSink();
  }

  void addEvents(Map eventData) {
    DateTime roundDown(DateTime date) =>
        DateTime(date.year, date.month, date.day);
//    print(eventData);

    super.data.eachEvent.addAll(Map.from(eventData));
    String eid = eventData.keys.first;
    DateTime start = super.data.eachEvent[eid]['start'];
    DateTime end = super.data.eachEvent[eid]['end'];
    DateTime temp = roundDown(start);
    while (true) {
      if (super.data.eventsByDate[temp] == null) {
        super.data.eventsByDate[temp] = [eid];
      } else {
        super.data.eventsByDate[temp].add(eid);
      }

      temp = temp.add(Duration(days: 1));
      if (temp.isAfter(roundDown(end.subtract(Duration(microseconds: 1))))) {
        break;
      }
    }

    super.streamSink();
  }

  List findEvents(DateTime date) {
    List returnValue = [];

    if (super.data.eventsByDate.containsKey(date)) {
      List temp = super.data.eventsByDate[date];
      temp.forEach((element) {
//        returnValue.add(element);
        returnValue.add({"id":element,"content":super.data.eachEvent[element]});
      });
    }
    return returnValue;
  }

  Map getLabelColorMap(){
    return super.data.labelColorMap;
  }

  Color getLabelColor(String colorKey){
    if (colorKey != null) return super.data.labelColorMap[colorKey];
    else return super.data.labelColorMap["empty"];
  }

  void changeEventsLabelColor(String colorKey, String key) {
    if (super.data.eachEvent.containsKey(key)) {
      super.data.eachEvent[key]["labelColor"] = colorKey;
    }
    super.streamSink();
  }

  void changeEntireLabelColor(String colorKey, Color color){
    if (super.data.labelColorMap.containsKey(colorKey)){
      super.data.labelColorMap[colorKey] = color;
    }
    super.streamSink();
  }

  List _makeWeekList(DateTime firstDay, DateTime lastDay) {
    List<int> dateList = List<int>();

    int firstDayWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    int lastDayWeekday = lastDay.weekday == 7 ? 0 : lastDay.weekday;

    // make long date list ( ex. [-3,-2,-1,0,1,2,3,...,31]
    for (int i = firstDayWeekday; i != 0; i--) dateList.add(-i + 1);
    for (int i = 0; lastDay.day != i; i++) dateList.add(i + 1);
    int lastIndex = 1;
    for (lastIndex = 1; lastDayWeekday != 6; lastIndex++, lastDayWeekday++)
      dateList.add(lastIndex + lastDay.day);
    // make it to 7 * 6 ( 6 weeks )
    if (dateList.length == 35) {
      for (int j = 0; j < 7; j++) dateList.add(lastIndex + lastDay.day + j);
    }

    // split with 7 ( make it to week! )  ( ex. [ [-3,-2,-1,0,1,2,3], [4,5,...], ... ] )
    List weekList = [];
    for (var i = 0; i < dateList.length; i += 7) {
      weekList.add(dateList.sublist(
          i, i + 7 > dateList.length ? dateList.length : i + 7));
    }
    return weekList;
  }

  DateTime _normalizeDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  void setSelectDate(DateTime day, List events, List holidays) {
    super.data.selectDate = day;
    super.streamSink();
  }

  bool isSelectedDate(DateTime day) {
    return day == super.data.getSelectDate;
  }

  void changeWeek(int i) {
    super.data.selectDate = i == 0
        ? _normalizeDate(DateTime.now())
        : super.data.selectDate.add(Duration(days: 7*i));
    super.streamSink();
  }

  void changeMonth(int i) {
    super.data.selectDate = i == 0
        ? _normalizeDate(DateTime.now())
        : DateTime(
            super.data.selectDate.year, super.data.selectDate.month + i, 1);
//    super.data.firstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
//    super.data.lastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
//            .subtract(new Duration(days: 1));
//
//    DateTime prevFirstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month - 1, 1);
//    DateTime prevLastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1)
//            .subtract(new Duration(days: 1));
//
//    DateTime nextFirstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1);
//    DateTime nextLastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 2, 1)
//            .subtract(new Duration(days: 1));
//
//    super.data.weekList =
//        _makeWeekList(super.data.firstDay, super.data.lastDay);
//    super.data.prevWeekList = _makeWeekList(prevFirstDay, prevLastDay);
//    super.data.nextWeekList = _makeWeekList(nextFirstDay, nextLastDay);
    super.streamSink();
  }

  void changeMonthCompletely(int year, int month) {
    super.data.selectDate = DateTime(year, month, 1);
//    super.data.firstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
//    super.data.lastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
//            .subtract(new Duration(days: 1));
//
//    DateTime prevFirstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month - 1, 1);
//    DateTime prevLastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1)
//            .subtract(new Duration(days: 1));
//
//    DateTime nextFirstDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1);
//    DateTime nextLastDay =
//        DateTime(super.data.focusDate.year, super.data.focusDate.month + 2, 1)
//            .subtract(new Duration(days: 1));
//
//    super.data.weekList =
//        _makeWeekList(super.data.firstDay, super.data.lastDay);
//    super.data.prevWeekList = _makeWeekList(prevFirstDay, prevLastDay);
//    super.data.nextWeekList = _makeWeekList(nextFirstDay, nextLastDay);
    super.streamSink();
  }

  void sinkWithGoogleCalendar(String clientID) {
    void prompt(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    final _scopes = const [GoogleCalendar.CalendarApi.CalendarScope];
    clientViaUserConsent(ClientId(clientID, ""), _scopes, prompt).then(
      (AuthClient client) {
        var calendar = GoogleCalendar.CalendarApi(client);
        calendar.calendarList.list().then(
          (calendars) {
            calendars.items.forEach(
              (eachCalendar) {
                calendar.events.list(eachCalendar.id).then(
                  (getEvents) {
                    getEvents.items.forEach(
                      (eachEvent) {
                        Map eachEventToMap = Map.from(eachEvent.toJson());
                        Map temp = {
                          eachEvent.id: {
                            'summary': eachEventToMap['summary'],
                            'start': eachEventToMap['start'].containsKey('date')
                                ? DateTime.parse(
                                    eachEventToMap['start']['date'])
                                : DateTime.parse(
                                    eachEventToMap['start']['dateTime']),
                            'end': eachEventToMap['start'].containsKey('date')
                                ? DateTime.parse(eachEventToMap['end']['date'])
                                : DateTime.parse(
                                    eachEventToMap['end']['dateTime']),
                            'recurrence':
                                eachEventToMap.containsKey('recurrence')
                                    ? eachEventToMap['recurrence']
                                    : null,
                            'labelColor' : "google"
                          }
                        };

                        this.addEvents(temp);
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
