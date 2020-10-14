part of widgetable_calendar;

typedef void OnCalendarCreated(DateTime first, DateTime last);
//typedef void OnDaySelected(DateTime day, List events, List holidays);
typedef void OnDaySelected(DateTime day);

class WidgetableCalendar extends StatefulWidget {
  final CalendarController calendarController;

  final DateTime selectDate;

  final OnCalendarCreated onCalendarCreated;
  final OnDaySelected onDaySelected;

  final Color weekDayColor;
  final Color sundayColor;
  final Color saturdayColor;
  final Color backgroundColor;
  final Color lineColor;

  final Map<DateTime, List> holidays;
  final Map<DateTime, List> events;

  // final double height;
  // final double width;

  WidgetableCalendar(
      {Key key,
      @required this.calendarController,
      this.onCalendarCreated,
      this.onDaySelected,
      this.selectDate,
      this.weekDayColor = Colors.black,
      this.sundayColor = Colors.red,
      this.saturdayColor = Colors.blue,
      this.backgroundColor = Colors.white,
      this.lineColor = Colors.black,
      this.holidays = const {},
      this.events = const {}})
      : assert(holidays != null),
        assert(events != null),
        super(key: key);

//  final CalendarController calendarController;
//  final DateTime initialSelectedDay;

  _WidgetableCalendarState createState() => _WidgetableCalendarState();
}

class _WidgetableCalendarState extends State<WidgetableCalendar>
    with SingleTickerProviderStateMixin {
  DateTime selectDate = DateTime.now();
  DateTime focusDate = DateTime.now(); //달마다 selectDate 바뀌는 거 대신
  DateTime firstDay;
  DateTime lastDay;
  List weekList = [];

  double startDXPoint = 0;
  double endDXPoint = 0;

  @override
  void initState() {
    super.initState();

    widget.calendarController._init(
        events: widget.events,
        holidays: widget.holidays,
        onCalendarCreated: widget.onCalendarCreated,
        selectedDayCallback: widget.onDaySelected,
        initialDay: widget.selectDate);

    firstDay = DateTime(widget.calendarController.selectDate.year,
        widget.calendarController.selectDate.month, 1);
    lastDay = DateTime(widget.calendarController.selectDate.year,
            widget.calendarController.selectDate.month + 1, 1)
        .subtract(new Duration(days: 1));
    weekList = _makeWeekList(firstDay, lastDay);
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

  bool _isFocusAndSelectSameDate(int date) {
    if (focusDate.year == selectDate.year &&
        focusDate.month == selectDate.month &&
        date == selectDate.day) {
      return true;
    } else
      return false;
  }

  void _onHorizontalDragStartHandler(DragStartDetails details) {
    setState(() {
      startDXPoint = details.globalPosition.dx.floorToDouble();
    });
  }

  void _onDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      endDXPoint = details.globalPosition.dx.floorToDouble();
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      if (startDXPoint > endDXPoint) changeMonth(1);
      else if (startDXPoint < endDXPoint) changeMonth(-1);
    });
  }


  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
//        onHorizontalDragUpdate: (details) {
//          if (details.primaryDelta < -30) {
//            changeMonth(1);
//          }
//          if (details.primaryDelta > 30) {
//            changeMonth(-1);
//          }
//        },
        onHorizontalDragStart: _onHorizontalDragStartHandler,
        onHorizontalDragUpdate: _onDragUpdateHandler,
        onHorizontalDragEnd: _onDragEnd,
        child: Container(
          color: widget.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildHeader(),
              _buildCalendarContent(),
              _buildTodayButton(),
            ],
          ),
        ),
      ),
    );
  }

  // This is Header (  <   2020 october   >  )
  Widget _buildHeader() {
    List monthList = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    final children = [
      IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          changeMonth(-1);
        },
      ),
      Expanded(
        child: Container(
          child: Center(
              child: Text(focusDate.year.toString() +
                  " " +
                  monthList[focusDate.month - 1])),
        ),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          changeMonth(1);
        },
      ),
    ];

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  Widget _buildCalendarContent() {
    final children = <TableRow>[_buildDaysOfWeek()];

    for (int i = 0; i < weekList.length; i++) {
      children.add(_buildEachWeek(weekList[i]));
    }

    return Table(
      children: children,
    );
  }

  // SUN MON TUE WED THU FRI SAT
  TableRow _buildDaysOfWeek() {
    List dayList = [
      "SUN",
      "MON",
      "TUE",
      "WED",
      "THU",
      "FRI",
      "SAT",
    ];
    final children = <TableCell>[];

    for (int i = 0; i < dayList.length; i++) {
      children.add(TableCell(
          child: Container(
        width: double.infinity,
        height: 50,
        child: Center(
            child: i == 0
                ? Text(
                    dayList[i],
                    style: TextStyle(color: widget.sundayColor),
                  )
                : i == 6
                    ? Text(
                        dayList[i],
                        style: TextStyle(color: widget.saturdayColor),
                      )
                    : Text(
                        dayList[i],
                        style: TextStyle(color: widget.weekDayColor),
                      )),
      )));
    }

    return TableRow(children: children);
  }

  TableRow _buildEachWeek(List weekList) {
    final children = <TableCell>[];

    for (int i = 0; i < weekList.length; i++) {
      String date = weekList[i] != 0 ? weekList[i].toString() : "";
      int dateInt = int.tryParse(date) ?? 0;
//      print(date);
      children.add(
        TableCell(
          child: Container(
            width: double.infinity,
            height: 50,
            color: _isFocusAndSelectSameDate(dateInt) ? Colors.grey[300] : widget.backgroundColor,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectDate =
                      DateTime(focusDate.year, focusDate.month, dateInt);
                  widget.calendarController.setSelectDate(selectDate);
                });
                print("selectDate == "+ selectDate.toString());
              },
              child: Center(
//                    child: Text(date)
                  child: i == 0
                      ? Text(
                          date,
                          style: TextStyle(color: widget.sundayColor),
                        )
                      : i == 6
                          ? Text(
                              date,
                              style: TextStyle(color: widget.saturdayColor),
                            )
                          : Text(
                              date,
                              style: TextStyle(color: widget.weekDayColor),
                            )),
            ),
          ),
        ),
      );
    }

    return TableRow(children: children);
  }

  Widget _buildTodayButton() {
    final children = [
      Expanded(
        child: FlatButton(
          child: Text("Today"),
          onPressed: () {
            setState(() {
              focusDate = DateTime.now();
              selectDate = DateTime.now();
              firstDay = DateTime(focusDate.year, focusDate.month, 1);
              lastDay = DateTime(focusDate.year, focusDate.month + 1, 1)
                  .subtract(new Duration(days: 1));
              weekList = _makeWeekList(firstDay, lastDay);
            });
          },
        ),
      ),
    ];

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  void changeMonth(int i) {
//    print(i);
    setState(() {
      focusDate = DateTime(focusDate.year, focusDate.month + i, 1);
      firstDay = DateTime(focusDate.year, focusDate.month, 1);
      lastDay = DateTime(focusDate.year, focusDate.month + 1, 1)
          .subtract(new Duration(days: 1));
      weekList = _makeWeekList(firstDay, lastDay);
    });
//    print(focusDate.toString());
    print("controller's selectDate == "+ widget.calendarController.selectDate.toString());
  }

// sleep(Duration(seconds: 1));
}
