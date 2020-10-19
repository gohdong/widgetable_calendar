import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:widgetable_calendar/Data/calendar_data.dart';

class WidgetableCalendarBloc {
  // WidgetableCalendarData calendar = WidgetableCalendarData(calendarController: null);
  StreamController<Map> _controller = StreamController();
  final WidgetableCalendarData data = WidgetableCalendarData();

  WidgetableCalendarBloc();

  void _init() {}

  Stream get streams {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  void streamSink() {
    _controller.sink.add(data.getData());
  }
}
