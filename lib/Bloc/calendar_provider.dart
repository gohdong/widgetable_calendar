import 'package:flutter/material.dart';
import 'package:widgetable_calendar/Bloc/calendar_bloc.dart';

class CalendarProvider extends InheritedWidget {
  final CalendarBloc calendarBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static CalendarBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType() as CalendarProvider)
          .calendarBloc;

  CalendarProvider({Key key, this.calendarBloc, Widget child})
      : super(child: child, key: key);
}
