library widgetable_calendar;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetable_calendar/Bloc/calendar_bloc.dart';
import 'package:widgetable_calendar/Bloc/calendar_controller.dart';
import 'package:widgetable_calendar/Bloc/calendar_provider.dart';
import 'dart:core';

import 'package:widgetable_calendar/Data/calendar_data.dart';

part 'UI/calendar_ui.dart';


/// A Calculator.
class WidgetableCalendar extends StatefulWidget {
  final Color weekDayColor;
  final Color sundayColor;
  final Color saturdayColor;
  final Color backgroundColor;
  final Color lineColor;
  final List holidays;
  final double height;
  final double width;

  WidgetableCalendar(
      {this.weekDayColor = Colors.black,
      this.sundayColor = Colors.red,
      this.saturdayColor = Colors.blue,
      this.backgroundColor = Colors.white,
      this.lineColor = Colors.black,
      this.height,
      this.width,
      this.holidays});
      // : assert(holidays != null);

  @override
  _WidgetableCalendarState createState() => _WidgetableCalendarState();
}

class _WidgetableCalendarState extends State<WidgetableCalendar> {
  @override
  Widget build(BuildContext context) {
    return WidgetableCalendarProvider(
      child: WidgetableCalendarUI(
        saturdayColor: widget.saturdayColor,
        weekDayColor: widget.weekDayColor,
        backgroundColor: widget.backgroundColor,
        lineColor: widget.lineColor,
        sundayColor: widget.sundayColor,
      ),
    );
  }
}
