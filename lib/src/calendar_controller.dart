part of widgetable_calendar;

typedef void _SelectedDayCallback(DateTime day, List events, List holidays);

class CalendarController {
  /// init(), dispose(), isSelected() -> when click specific day, ......

  // 밖에서 읽기 위한.
  DateTime get selectDate => _selectDate;

  List get events => _events;

  List get holidays => _holidays;

  DateTime _selectDate;

  List _events;
  List _holidays;
  _SelectedDayCallback _selectedDayCallback;

  //------------------------------------------^ calendar 에서 받아온 값들

  DateTime _focusDate;
  DateTime _firstDay;
  DateTime _lastDay;
  List _weekList;

  DateTime get focusDate => _focusDate;

  DateTime get firstDay => _firstDay;

  DateTime get lastDay => _lastDay;

  List get weekList => _weekList;


  void _init({
    @required List events,
    @required List holidays,
    @required OnCalendarCreated onCalendarCreated,
    @required _SelectedDayCallback selectedDayCallback,
    @required DateTime initialDay,
  }) {
    _events = events??[];
    _holidays = holidays??[];
    _selectedDayCallback = selectedDayCallback;

    final now = DateTime.now();
    _selectDate = initialDay ?? _normalizeDate(now);
    _focusDate = _normalizeDate(now);

    _firstDay = DateTime(_focusDate.year, _focusDate.month, 1);
    _lastDay = DateTime(_focusDate.year, _focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    _weekList = _makeWeekList(_firstDay, _lastDay);

    if (onCalendarCreated != null) {
      onCalendarCreated(_firstDay, _lastDay);
    }
  }

  List _makeWeekList(DateTime firstDay, DateTime lastDay) {
    List<int> dateList = List<int>();

    int firstDayWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    int lastDayWeekday = lastDay.weekday == 7 ? 0 : lastDay.weekday;

    // make long date list ( ex. [0,0,0,0,1,2,3,...,31]
    for (int i = 0; firstDayWeekday != i; i++) dateList.add(0);
    for (int i = 0; lastDay.day != i; i++) dateList.add(i + 1);
    for (int i = lastDayWeekday; i != 6; i++) dateList.add(0);

    // split with 7 ( make it to week! )  ( ex. [ [0,0,0,0,1,2,3], [4,5,...], ... ] )
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
    _selectDate = day;
    if (_selectedDayCallback != null) {
      _selectedDayCallback(day, events, holidays);
    }
  }

  bool isSelectedDate(DateTime day) {
    return day == _selectDate;
  }

  void changeMonth(int i) {
    _focusDate = i == 0
        ? _normalizeDate(DateTime.now())
        : DateTime(_focusDate.year, _focusDate.month + i, 1);
    _firstDay = DateTime(_focusDate.year, _focusDate.month, 1);
    _lastDay = DateTime(_focusDate.year, _focusDate.month + 1, 1)
        .subtract(new Duration(days: 1));

    _weekList = _makeWeekList(_firstDay, _lastDay);
  }

  void addEvent(Map eventInfo){
    _events.add(eventInfo);
  }

}
