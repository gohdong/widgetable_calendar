part of widgetable_calendar;

typedef void _SelectedDayCallback(DateTime day,List events,List holidays);

class CalendarController {
  /// init(), dispose(), isSelected() -> when click specific day, ......

//  DateTime get focusDate => _focusDate;

  DateTime get selectDate => _selectDate;

  Map<DateTime, List> get events => _events;

  Map<DateTime, List> get holidays => _holidays;

//  DateTime _focusDate;
  DateTime _selectDate;

  Map<DateTime, List> _events;
  Map<DateTime, List> _holidays;
  _SelectedDayCallback _selectedDayCallback;

  void _init({
    @required Map<DateTime, List> events,
    @required Map<DateTime, List> holidays,
    @required OnCalendarCreated onCalendarCreated,
    @required _SelectedDayCallback selectedDayCallback,
    @required DateTime initialDay,
  }) {
    _events = events;
    _holidays = holidays;
    _selectedDayCallback = selectedDayCallback;

    final now = DateTime.now();
    _selectDate = initialDay ?? _normalizeDate(now);
//    _selectDate = _focusDate;

//    if (onCalendarCreated != null) {
//      onCalendarCreated(DateTime(_focusDate.year, _focusDate.month, 1),
//          DateTime(_focusDate.year, _focusDate.month + 1, 1)
//              .subtract(new Duration(days: 1)));
//    }
  }

  DateTime _normalizeDate(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day, 0);
  }

  void setSelectDate(DateTime day,List events,List holidays){
    _selectDate = day;
    if(_selectedDayCallback != null){
      _selectedDayCallback(day,events,holidays);
    }
  }

  bool isSelectedDate(DateTime day){
    return day==_selectDate;
  }
//  onClickToday(){
//    _selectDate = DateTime.now();
//  }
}
