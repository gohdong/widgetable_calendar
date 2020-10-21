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
    super.data.events = {};
    super.data.holidays = [];

    final now = DateTime.now();
    super.data.selectDate = _normalizeDate(now);
    super.data.focusDate = _normalizeDate(now);

    super.data.firstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
    super.data.lastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
            .subtract(new Duration(days: 1));

    DateTime prevFirstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month - 1, 1);
    DateTime prevLastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1)
            .subtract(new Duration(days: 1));

    DateTime nextFirstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1);
    DateTime nextLastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 2, 1)
            .subtract(new Duration(days: 1));

    super.data.weekList =
        _makeWeekList(super.data.firstDay, super.data.lastDay);
    super.data.prevWeekList = _makeWeekList(prevFirstDay, prevLastDay);
    super.data.nextWeekList = _makeWeekList(nextFirstDay, nextLastDay);
    super.streamSink();
  }

  void addEvents(Map eventData) {
    if (super.data.events[eventData.keys.first] == null) {
      super.data.events[eventData.keys.first] = [eventData.values.first];
    } else {
      super.data.events[eventData.keys.first].add(eventData.values.first);
    }
    super.streamSink();
  }

  List findEvents() {
    print(super.data.events);
    List returnValue = [];
    super.data.events.forEach((key, value) {
      if (key == super.data.selectDate) {
        returnValue.add(value);
      }
    });
    return returnValue;
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
        : DateTime(
            super.data.focusDate.year, super.data.focusDate.month + i, 1);
    super.data.firstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
    super.data.lastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
            .subtract(new Duration(days: 1));

    DateTime prevFirstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month - 1, 1);
    DateTime prevLastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1)
            .subtract(new Duration(days: 1));

    DateTime nextFirstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1);
    DateTime nextLastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 2, 1)
            .subtract(new Duration(days: 1));

    super.data.weekList =
        _makeWeekList(super.data.firstDay, super.data.lastDay);
    super.data.prevWeekList = _makeWeekList(prevFirstDay, prevLastDay);
    super.data.nextWeekList = _makeWeekList(nextFirstDay, nextLastDay);
    super.streamSink();
  }

  void changeMonthCompletely(int year, int month) {
    super.data.focusDate = DateTime(year, month, 1);
    super.data.firstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1);
    super.data.lastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1)
            .subtract(new Duration(days: 1));

    DateTime prevFirstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month - 1, 1);
    DateTime prevLastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month, 1)
            .subtract(new Duration(days: 1));

    DateTime nextFirstDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 1, 1);
    DateTime nextLastDay =
        DateTime(super.data.focusDate.year, super.data.focusDate.month + 2, 1)
            .subtract(new Duration(days: 1));

    super.data.weekList =
        _makeWeekList(super.data.firstDay, super.data.lastDay);
    super.data.prevWeekList = _makeWeekList(prevFirstDay, prevLastDay);
    super.data.nextWeekList = _makeWeekList(nextFirstDay, nextLastDay);
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
                        Map temp = Map.from(eachEvent.toJson());
                        this.addEvents(
                          {
                            temp['start'].containsKey('date')
                                ? DateTime.parse(temp['start']['date'])
                                : DateTime.parse(temp['start']['dateTime']): {
                              'summary': temp['summary'],
                              'start': temp['start'].containsKey('date')
                                  ? DateTime.parse(temp['start']['date'])
                                  : DateTime.parse(temp['start']['dateTime']),
                              'end': temp['start'].containsKey('date')
                                  ? DateTime.parse(temp['end']['date'])
                                  : DateTime.parse(temp['end']['dateTime']),
                              'recurrence': temp.containsKey('recurrence')
                                  ? temp['recurrence']
                                  : null
                            }
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
      },
    );
  }
}
