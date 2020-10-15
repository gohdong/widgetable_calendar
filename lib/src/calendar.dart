part of widgetable_calendar;

typedef void OnCalendarCreated(DateTime first, DateTime last);
typedef void OnDaySelected(DateTime day, List events, List holidays);

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

  final List holidays;
  final List events;

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
      this.holidays,
      this.events})
      : super(key: key);

  _WidgetableCalendarState createState() => _WidgetableCalendarState();
}

class _WidgetableCalendarState extends State<WidgetableCalendar>
    with SingleTickerProviderStateMixin {
  double startDXPoint = 0;
  double endDXPoint = 0;

  List yearList = ["2019", "2020", "2021"];
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
  int selectYear;
  int selectMonth;

  @override
  void initState() {
    super.initState();

    widget.calendarController._init(
        events: widget.events,
        holidays: widget.holidays,
        onCalendarCreated: widget.onCalendarCreated,
        selectedDayCallback: widget.onDaySelected,
        initialDay: widget.selectDate);

//    selectYear = "2020";
//    selectMonth = "Feb";

    selectYear = widget.calendarController.selectDate.year;
    selectMonth =widget.calendarController.selectDate.month;
  }

  @override
  void didUpdateWidget(WidgetableCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.events != widget.events) {
      widget.calendarController._events = widget.events;
    }

    if (oldWidget.holidays != widget.holidays) {
      widget.calendarController._holidays = widget.holidays;
    }
  }

  bool _isToday(int date) {
    DateTime today = DateTime.now();
    if (widget.calendarController.focusDate.year == today.year &&
        widget.calendarController.focusDate.month == today.month &&
        date == today.day) {
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
      if (startDXPoint > endDXPoint)
        widget.calendarController.changeMonth(1);
      else if (startDXPoint < endDXPoint)
        widget.calendarController.changeMonth(-1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
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
              _buildAddEventButton(),
              Container(
                child: Text("모든 events\n" +
                    widget.calendarController.events.toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  int findYear(int year){
    int returnValue = 0;
    for (int i=0 ; i<yearList.length ; i++){
      if (yearList[i] == year.toString()) return i;
    }
    return returnValue;
  }

  // This is Header (  <   2020 october   >  )
  Widget _buildHeader() {
    final children = [
      IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          setState(() {
            widget.calendarController.changeMonth(-1);
          });
        },
      ),
      Expanded(
        child: Center(
          child: InkWell(
            onTap: () async{
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  int selectedYearIndex = findYear(selectYear);
                  int selectedMonthIndex = selectMonth-1;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 160.0, // Change as per your requirement
                                width: 100,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: yearList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                        selected: index == selectedYearIndex,
                                        onTap: () {
                                          selectedYearIndex = index;
                                          setState(() {
                                            selectYear = int.tryParse(yearList[index]) ?? 2020;
                                          });
                                          print(selectYear);
                                        },
                                        title: Text(yearList[index].toString()));
                                  },
                                )),
                            Container(
                                height: 160.0, // Change as per your requirement
                                width: 100,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: monthList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                        selected: index == selectedMonthIndex,
                                        onTap: () {
                                          selectedMonthIndex = index;
                                          setState(() {
                                            selectMonth = index+1;
                                            print(selectMonth);
                                          });
                                        },
                                        title: Text(monthList[index].toString()));
                                  },
                                )),
                          ],
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Done"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
              setState(() {
                widget.calendarController.changeMonthCompletely(selectYear, selectMonth);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.calendarController.focusDate.year.toString() +
                    " " +
                    monthList[widget.calendarController.focusDate.month - 1]),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          setState(() {
            widget.calendarController.changeMonth(1);
          });
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



//  Widget _buildAboutDialog(BuildContext context) {
//    return
//  }

  Widget _buildCalendarContent() {
    final children = <TableRow>[_buildDaysOfWeek()];

    for (int i = 0; i < widget.calendarController.weekList.length; i++) {
      children.add(_buildEachWeek(widget.calendarController.weekList[i]));
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
      children.add(
        TableCell(
          child: InkWell(
            onTap: () {
              setState(() {
                if (widget.calendarController.isSelectedDate(DateTime(
                    widget.calendarController.focusDate.year,
                    widget.calendarController.focusDate.month,
                    weekList[i])))
                  widget.calendarController.setSelectDate(null, [], []);
                else
//                  widget.calendarController.setSelectDate(
//                      DateTime(
//                          widget.calendarController.focusDate.year,
//                          widget.calendarController.focusDate.month,
//                          weekList[i]),
//                      widget.calendarController
//                          .events[widget.calendarController.selectDate],
//                      widget.calendarController
//                          .holidays[widget.calendarController.selectDate]);
                  widget.calendarController.setSelectDate(
                      DateTime(
                          widget.calendarController.focusDate.year,
                          widget.calendarController.focusDate.month,
                          weekList[i]),
                      [],
                      []);
              });
            },
            child: Container(
              width: double.infinity,
              color: _isToday(weekList[i])
                  ? Colors.grey[300]
                  : widget.calendarController.isSelectedDate(
                      DateTime(
                          widget.calendarController.focusDate.year,
                          widget.calendarController.focusDate.month,
                          weekList[i]),
                    )
                      ? Colors.red
                      : null,
              height: 50,
              child: Center(
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
              widget.calendarController.changeMonth(0);
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

  Widget _buildAddEventButton() {
    final children = [
      Expanded(
        child: FlatButton(
          child: Text("라이브러리의 일정추가 기능"),
          onPressed: () {
            setState(() {
              widget.calendarController.addEvent(
                  {widget.calendarController.selectDate: "라이브러리 기능 ~"});
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
}
