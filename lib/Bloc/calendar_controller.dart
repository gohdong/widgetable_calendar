// import 'package:widgetable_calendar/widgetable_calendar.dart';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleCalendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgetable_calendar/Bloc/calendar_bloc.dart';
import 'package:widgetable_calendar/Data/calendar_data.dart';
import 'package:widgetable_calendar/widgetable_calendar.dart';

class WidgetableCalendarController extends WidgetableCalendarBloc {
  List googleCalendarList = [];

  get stream {
    return super.streams;
  }

  WidgetableCalendarController();

  void init({CalendarFormat calendarFormat, Map holidayData, bool headerEnable}) {
//    super.data.holidays = [];
    super.data.holidaysByDate = {};
    super.data.eachHoliday = {};

    super.data.eventsByDate = {};
    super.data.eachEvent = {};
    this.addHolidays(holidayData);

    final now = DateTime.now();
    super.data.selectDate = _normalizeDate(now);


    super.data.calendarFormat = calendarFormat ?? CalendarFormat.Month;
    super.data.headerEnable = headerEnable ?? true;
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

    // Format -- { colorKey(random value) : { "name" : customName, "color" : customColor, "toggle" : show or not }  }
    super.data.labelColorMap = {
      "default": {"name": "first", "color": Colors.green, "toggle": true},
      "empty": {"name": "", "color": Colors.grey, "toggle": true},
      "holiday" : {"name": "holiday", "color": Colors.red, "toggle": true}
//      "google" : {"name" : "google", "color": Colors.blue, "toggle" : true},
    };

    super.streamSink();
  }

  void addEvents(Map eventData) {
    DateTime roundDown(DateTime date) =>
        DateTime(date.year, date.month, date.day);
//    print(eventData);

    super.data.eachEvent.addAll(Map.from(eventData));
    eventData.forEach((eid, value) {
//      String eid = key;
      DateTime start = value['start'];
      DateTime end = value['end'];
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
    });
//    String eid = eventData.keys.first;
//    DateTime start = super.data.eachEvent[eid]['start'];
//    DateTime end = super.data.eachEvent[eid]['end'];
//    DateTime temp = roundDown(start);
//    while (true) {
//      if (super.data.eventsByDate[temp] == null) {
//        super.data.eventsByDate[temp] = [eid];
//      } else {
//        super.data.eventsByDate[temp].add(eid);
//      }
//
//      temp = temp.add(Duration(days: 1));
//      if (temp.isAfter(roundDown(end.subtract(Duration(microseconds: 1))))) {
//        break;
//      }
//    }

    super.streamSink();
  }

  List findEvents(DateTime date) {
    List returnValue = [];

    if (super.data.eventsByDate.containsKey(date)) {
      List temp = super.data.eventsByDate[date].toList();
      temp.forEach((element) {
//        returnValue.add(element);
        returnValue
            .add({"id": element, "content": super.data.eachEvent[element]});
        if (super.data.eachEvent.containsKey(element)) {
          String colorKey = super.data.eachEvent[element]["labelColor"];
          if (this.getLabelColorToggle(colorKey))
            returnValue
                .add({"id": element, "content": super.data.eachEvent[element]});
        }
      });
    }
    return returnValue;
  }

  void addHolidays(Map eventData) {
    DateTime roundDown(DateTime date) =>
        DateTime(date.year, date.month, date.day);
//    print(eventData);

    super.data.eachHoliday.addAll(Map.from(eventData));
    eventData.forEach((eid, value) {
//      String eid = key;
      DateTime start = value['start'];
      DateTime end = value['end'];
      DateTime temp = roundDown(start);
      while (true) {
        if (super.data.holidaysByDate[temp] == null) {
          super.data.holidaysByDate[temp] = [eid];
        } else {
          super.data.holidaysByDate[temp].add(eid);
        }

        temp = temp.add(Duration(days: 1));
        if (temp.isAfter(roundDown(end.subtract(Duration(microseconds: 1))))) {
          break;
        }
      }
    });
//    String eid = eventData.keys.first;
//    DateTime start = super.data.eachHoliday[eid]['start'];
//    DateTime end = super.data.eachHoliday[eid]['end'];
//    DateTime temp = roundDown(start);
//    while (true) {
//      if (super.data.holidaysByDate[temp] == null) {
//        super.data.holidaysByDate[temp] = [eid];
//      } else {
//        super.data.holidaysByDate[temp].add(eid);
//      }
//
//      temp = temp.add(Duration(days: 1));
//      if (temp.isAfter(roundDown(end.subtract(Duration(microseconds: 1))))) {
//        break;
//      }
//    }
    super.streamSink();
  }

  List findHolidays(DateTime date) {
    List returnValue = [];

    if (super.data.holidaysByDate.containsKey(date)) {
      List temp = super.data.holidaysByDate[date];
      temp.forEach((element) {
//        returnValue.add(element);
        if (super.data.eachHoliday.containsKey(element)) {
          String colorKey = super.data.eachHoliday[element]["labelColor"];
          if (this.getLabelColorToggle(colorKey))
            returnValue
                .add({"id": element, "content": super.data.eachHoliday[element]});
        }
      });
    }
    return returnValue;
  }

  List findAllEvents(DateTime date){
    List returnValue = [];

    if (super.data.holidaysByDate.containsKey(date)) {
      List temp = super.data.holidaysByDate[date];
      temp.forEach((element) {
//        returnValue.add(element);
        if (super.data.eachHoliday.containsKey(element)) {
          String colorKey = super.data.eachHoliday[element]["labelColor"];
          if (this.getLabelColorToggle(colorKey))
            returnValue
                .add({"id": element, "content": super.data.eachHoliday[element]});
        }
      });
    }
    if (super.data.eventsByDate.containsKey(date)) {
      List temp = super.data.eventsByDate[date];
      temp.forEach((element) {
//        returnValue.add(element);
        if (super.data.eachEvent.containsKey(element)) {
          String colorKey = super.data.eachEvent[element]["labelColor"];
          if (this.getLabelColorToggle(colorKey))
            returnValue
                .add({"id": element, "content": super.data.eachEvent[element]});
        }
      });
    }

    return returnValue;
  }

  bool findHolidaysBool(DateTime date){
    if (super.data.holidaysByDate.containsKey(date)) return true;
    else return false;
  }

//  Map getLabelColorMap() {
//    return super.data.labelColorMap;
//  }

  Map associatedEventsByDate(DateTime date) {
    Map tempMap = {};
    super.data.eachHoliday.forEach((key, value) {
      Map tempValue = {};
      tempValue.addAll(value);
      DateTime start = value['start'];
      DateTime end = value['end'].subtract(Duration(microseconds: 1));
      if (start.hour != 0 || start.minute != 0){
        start = start.subtract(Duration(hours: start.hour, minutes: start.minute));
        tempValue['start'] = start;
      }
      if (value['end'].hour != 0 || value['end'].minute != 0){
        end = value['end'].subtract(Duration(hours: value['end'].hour, minutes: value['end'].minute)).add(Duration(days: 1));
        tempValue['end'] = end;
      }
      if ((start.isBefore(date) && end.isAfter(date))||start.compareTo(date)==0) {
        tempMap.addAll({key: tempValue});
      }
    });
    super.data.eachEvent.forEach((key, value) {
      Map tempValue = {};
      tempValue.addAll(value);
      DateTime start = value['start'];
      DateTime end = value['end'].subtract(Duration(microseconds: 1));
      if (start.hour != 0 || start.minute != 0){
        start = start.subtract(Duration(hours: start.hour, minutes: start.minute));
        tempValue['start'] = start;
      }
      if (value['end'].hour != 0 || value['end'].minute != 0){
        end = value['end'].subtract(Duration(hours: value['end'].hour, minutes: value['end'].minute)).add(Duration(days: 1));
        tempValue['end'] = end;
      }
      if ((start.isBefore(date) && end.isAfter(date))||start.compareTo(date)==0) {
        tempMap.addAll({key: tempValue});
      }
    });
    return tempMap;
  }

  Color getLabelColor(String colorKey) {
    if (colorKey != null && super.data.labelColorMap.containsKey(colorKey))
      return super.data.labelColorMap[colorKey]["color"];
    else
      return super.data.labelColorMap["empty"]["color"];
  }

  bool getLabelColorToggle(String colorKey) {
    if (colorKey != null && super.data.labelColorMap.containsKey(colorKey))
      return super.data.labelColorMap[colorKey]["toggle"];
    else
      return false;
  }

//  String getLabelColorName(String colorKey) {
//    if (colorKey != null && super.data.labelColorMap.containsKey(colorKey))
//      return super.data.labelColorMap[colorKey]["name"];
//    else
//      return "empty";
//  }

  void changeEventsLabelColor(String colorKey, String eventKey) {
    if (super.data.eachEvent.containsKey(eventKey)) {
      super.data.eachEvent[eventKey]["labelColor"] = colorKey;
    }
    super.streamSink();
  }

  void changeEntireLabelColor(String colorKey, Color color) {
    if (super.data.labelColorMap.containsKey(colorKey)) {
      super.data.labelColorMap[colorKey]["color"] = color;
    }
    super.streamSink();
  }

  void addLabel(Map labelMap) {
//    if (super.data.labelColorMap.length < 5)
      super.data.labelColorMap.addAll(Map.from(labelMap));
    super.streamSink();
  }

  void deleteLabel(String colorKey) {
//    print(super.data.eventsByDate.toString());
    // delete Label
    if (super.data.labelColorMap.containsKey(colorKey))
      super.data.labelColorMap.remove(colorKey);
    // delete Label

    // delete events in eachEvent MAP
    List keyList = [];
    List dateList = [];
    DateTime roundDown(DateTime date) =>
        DateTime(date.year, date.month, date.day);

    super.data.eachEvent.forEach((key, value) {
      if (value["labelColor"] == colorKey) {
        keyList.add(key);

        // make dateList <- key of eventsByDate's MAP
        DateTime start = value["start"];
        DateTime end = value["end"];
        DateTime temp = roundDown(start);

        while (true) {
          dateList.add(temp);
          temp = temp.add(Duration(days: 1));
          if (temp
              .isAfter(roundDown(end.subtract(Duration(microseconds: 1))))) {
            break;
          }
        }
        // make dateList <- key of eventsByDate's MAP
      }
    });

    keyList.forEach((element) {
      super.data.eachEvent.remove(element);
    });
    // delete events in eachEvent MAP

    // remove duplicates in dateList !!  <---- bug.......
//    dateList = dateList.toSet().toList();
//    print(dateList.toString());

    // delete events Key in eventsByDate MAP
    dateList.forEach((element) {
      if (super.data.eventsByDate.containsKey(element)) {
        for (int i = 0; i < super.data.eventsByDate[element].length; i++) {
//<<<<<<< HEAD
//          String key = super.data.eventsByDate[element][i];
//          if (keyList.contains(key))
//            super.data.eventsByDate[element].remove(key);
//=======
          String key = super.data.eventsByDate[element].toList()[i];
          if (keyList.contains(key)) super.data.eventsByDate[element].remove(
              key);
        }
      } else {
        print("error in here : " + element.toString());
      }
    });

//    print("\n"+super.data.eventsByDate.toString()+"\n");
    // delete events Key in eventsByDate MAP

    super.streamSink();
  }

  void toggleLabel(String colorKey) {
    if (super.data.labelColorMap.containsKey(colorKey))
      super.data.labelColorMap[colorKey]["toggle"] =
          !super.data.labelColorMap[colorKey]["toggle"];
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

  void setSelectDate(DateTime day) {
    super.data.selectDate = day;
    super.streamSink();
  }

  void toggleCalendarFormat() {
    if (super.data.calendarFormat == CalendarFormat.Month)
      super.data.calendarFormat = CalendarFormat.Week;
    else
      super.data.calendarFormat = CalendarFormat.Month;

    super.streamSink();
  }

  bool isSelectedDate(DateTime day) {
    return day == super.data.getSelectDate;
  }

  void changeWeek(int i) {
    super.data.selectDate = i == 0
        ? _normalizeDate(DateTime.now())
        : super.data.selectDate.add(Duration(days: 7 * i));
    super.streamSink();
  }

  void changeMonth(int i) {
//    print(super.data.selectDate.month);
    super.data.selectDate = i == 0
        ? _normalizeDate(DateTime.now())
        : DateTime(
            super.data.selectDate.year, super.data.selectDate.month + i, 1);
    super.streamSink();
  }

  void changeMonthCompletely(int year, int month, int date) {
    super.data.selectDate = DateTime(year, month, date);
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

    if (!super.data.labelColorMap.containsKey("google"))
      this.addLabel({
        "google": {"name": "google", "color": Colors.blue, "toggle": true},
      });

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
                                    .toLocal()
                                : DateTime.parse(
                                        eachEventToMap['start']['dateTime'])
                                    .toLocal(),
                            'end': eachEventToMap['start'].containsKey('date')
                                ? DateTime.parse(eachEventToMap['end']['date'])
                                    .toLocal()
                                : DateTime.parse(
                                        eachEventToMap['end']['dateTime'])
                                    .toLocal(),
                            'recurrence':
                                eachEventToMap.containsKey('recurrence')
                                    ? eachEventToMap['recurrence']
                                    : null,
                            'labelColor': "google"
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
