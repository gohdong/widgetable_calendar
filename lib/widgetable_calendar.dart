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
  final WidgetableCalendarController calendarController;
  final Color weekDayColor;
  final Color sundayColor;
  final Color saturdayColor;
  final Color backgroundColor;
  final Color lineColor;
  final List holidays;
  final Color todayBackgroundColor;
  final Color todayTextColor;
  final Color highlightBackgroundColor;
  final Color highlightTextColor;
  final double height;
  final double width;

  WidgetableCalendar(
      {this.weekDayColor = Colors.black,
      this.sundayColor = Colors.red,
      this.saturdayColor = Colors.blue,
      this.backgroundColor = Colors.white,
      this.lineColor = Colors.black,
      this.calendarController,
      this.height,
      this.width,
      this.holidays,
      this.todayBackgroundColor = Colors.black26,
      this.todayTextColor = Colors.white,
      this.highlightBackgroundColor = Colors.red,
      this.highlightTextColor = Colors.white});

  // : assert(holidays != null);

  @override
  _WidgetableCalendarState createState() => _WidgetableCalendarState();
}

class _WidgetableCalendarState extends State<WidgetableCalendar> {
  @override
  Widget build(BuildContext context) {
    return WidgetableCalendarProvider(
      child: WidgetableCalendarUI(
        calendarController: widget.calendarController,
        saturdayColor: widget.saturdayColor,
        weekDayColor: widget.weekDayColor,
        backgroundColor: widget.backgroundColor,
        lineColor: widget.lineColor,
        sundayColor: widget.sundayColor,
        todayBackgroundColor: widget.todayBackgroundColor,
        todayTextColor: widget.todayTextColor,
        highlightBackgroundColor: widget.highlightBackgroundColor,
        highlightTextColor: widget.highlightTextColor,
      ),
    );
  }
}
