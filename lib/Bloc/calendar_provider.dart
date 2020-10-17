import 'package:flutter/material.dart';
import 'package:widgetable_calendar/Bloc/calendar_bloc.dart';

class WidgetableCalendarProvider extends InheritedWidget {
  final WidgetableCalendarBloc calendarBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static WidgetableCalendarBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType() as WidgetableCalendarProvider)
          .calendarBloc;

  WidgetableCalendarProvider({Key key, this.calendarBloc, Widget child})
      : super(child: child, key: key);
}
