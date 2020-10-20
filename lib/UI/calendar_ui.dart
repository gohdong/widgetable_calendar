part of widgetable_calendar;

typedef void OnCalendarCreated(DateTime first, DateTime last);
typedef void OnDaySelected(DateTime day, List events, List holidays);

class WidgetableCalendarUI extends StatefulWidget {
  final Color weekDayColor;
  final Color sundayColor;
  final Color saturdayColor;
  final Color backgroundColor;
  final Color lineColor;
  final Color todayBackgroundColor;
  final Color todayTextColor;
  final Color highlightBackgroundColor;
  final Color highlightTextColor;

  final List holidays;
  final List events;

  final WidgetableCalendarController calendarController;

  WidgetableCalendarUI(
      {Key key,
      @required this.calendarController,
      this.weekDayColor = Colors.black,
      this.sundayColor = Colors.red,
      this.saturdayColor = Colors.blue,
      this.backgroundColor = Colors.white,
      this.lineColor = Colors.black,
      this.holidays,
      this.events,
      this.todayBackgroundColor = Colors.black26,
      this.todayTextColor = Colors.white,
      this.highlightBackgroundColor = Colors.red,
      this.highlightTextColor = Colors.white})
      : super(key: key);

  _WidgetableCalendarUIState createState() => _WidgetableCalendarUIState();
}

class _WidgetableCalendarUIState extends State<WidgetableCalendarUI>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.calendarController.init();
    super.initState();
  }

  double startDXPoint = 0;
  double endDXPoint = 0;

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
    return StreamBuilder(
      stream: widget.calendarController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ClipRect(
          child: GestureDetector(
            onHorizontalDragStart: _onHorizontalDragStartHandler,
            onHorizontalDragUpdate: _onDragUpdateHandler,
            onHorizontalDragEnd: _onDragEnd,
            child: Container(
              child: Column(
                children: [
                  _buildHeader(snapshot.data),
                  _buildCalendarContent(snapshot.data),
                  FlatButton(
                      onPressed: () => widget.calendarController.addEvents({
                            "time": snapshot.data['selectDate'],
                            "title": "test"
                          }),
                      child: Text("ADD EVENTS")),
                  _buildEvents(snapshot.data)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Map snapshot) {
    // print(snapshot==null);
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
          widget.calendarController.changeMonth(-1);
        },
      ),
      Expanded(
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(snapshot['focusDate'].year.toString() +
                " " +
                monthList[snapshot['focusDate'].month - 1]),
            Icon(Icons.arrow_drop_down),
          ],
        )),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          widget.calendarController.changeMonth(1);
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

  Widget _buildCalendarContent(Map snapshot) {
    final children = <TableRow>[_buildDaysOfWeek()];

    for (int i = 0; i < snapshot['weekList'].length; i++) {
      children.add(_buildEachWeek(snapshot, snapshot['weekList'][i]));
    }
    return Table(
      children: children,
    );
  }

  TableRow _buildEachWeek(Map snapshot, List weekList) {
    final children = <TableCell>[];

    for (int i = 0; i < weekList.length; i++) {
      DateTime eachDate = DateTime(snapshot['focusDate'].year,
          snapshot['focusDate'].month, weekList[i]); // 정확한 날짜
      bool thisMonth = _isThisMonth(snapshot, weekList, eachDate);
      String date = eachDate.day.toString();

      children.add(
        TableCell(
          child: InkWell(
            onTap: () {
              if (widget.calendarController.isSelectedDate(DateTime(
                  snapshot['focusDate'].year,
                  snapshot['focusDate'].month,
                  weekList[i])))
                widget.calendarController.setSelectDate(null, [], []);
              else
                widget.calendarController.setSelectDate(
                    DateTime(snapshot['focusDate'].year,
                        snapshot['focusDate'].month, weekList[i]),
                    [],
                    []);

              if (!thisMonth && weekList[i] <= 0)
                widget.calendarController.changeMonth(-1);
              if (!thisMonth && weekList[i] > 0)
                widget.calendarController.changeMonth(1);
            },
            child: Container(
              width: double.infinity,
              color: _isToday(weekList[i], snapshot['focusDate'])
                  ? widget.todayBackgroundColor
                  : widget.calendarController.isSelectedDate(
                      DateTime(snapshot['focusDate'].year,
                          snapshot['focusDate'].month, weekList[i]),
                    )
                      ? widget.highlightBackgroundColor
                      : null,
              height: 50,
              child: Center(
                child: i == 0
                    ? Text(
                        date,
                        style: TextStyle(
                            color: thisMonth
                                ? _isToday(weekList[i], snapshot['focusDate'])
                                    ? widget.todayTextColor
                                    : widget.calendarController.isSelectedDate(
                                        DateTime(
                                            snapshot['focusDate'].year,
                                            snapshot['focusDate'].month,
                                            weekList[i]),
                                      )
                                        ? widget.highlightTextColor
                                        : widget.sundayColor
                                : Colors.grey),
                      )
                    : i == 6
                        ? Text(
                            date,
                            style: TextStyle(
                                color: thisMonth
                                    ? _isToday(
                                            weekList[i], snapshot['focusDate'])
                                        ? widget.todayTextColor
                                        : widget.calendarController
                                                .isSelectedDate(
                                            DateTime(
                                                snapshot['focusDate'].year,
                                                snapshot['focusDate'].month,
                                                weekList[i]),
                                          )
                                            ? widget.highlightTextColor
                                            : widget.saturdayColor
                                    : Colors.grey),
                          )
                        : Text(
                            date,
                            style: TextStyle(
                                color: thisMonth
                                    ? _isToday(
                                            weekList[i], snapshot['focusDate'])
                                        ? widget.todayTextColor
                                        : widget.calendarController
                                                .isSelectedDate(
                                            DateTime(
                                                snapshot['focusDate'].year,
                                                snapshot['focusDate'].month,
                                                weekList[i]),
                                          )
                                            ? widget.highlightTextColor
                                            : widget.weekDayColor
                                    : Colors.grey),
                          ),
              ),
            ),
          ),
        ),
      );
    }

    return TableRow(children: children);
  }

  Widget _buildEvents(Map snapshot) {
    final children = <Widget>[
//      Text(snapshot['events'].toString()),
      Divider(
        thickness: 5,
      ),
//      Text(widget.calendarController.findEvents().toString()),
      Expanded(child: _buildEventList(widget.calendarController.findEvents())),
    ];

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  Widget _buildEventList(List eventList) {
    return ListView(
      children: eventList != null
          ? eventList
              .map((event) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(event.toString()),
//          onTap: () => print('$event tapped!'),
                    ),
                  ))
              .toList()
          : Container(),
    );
  }

  bool _isToday(int date, DateTime focusDate) {
    DateTime today = DateTime.now();
    if (focusDate.year == today.year &&
        focusDate.month == today.month &&
        date == today.day) {
      return true;
    } else
      return false;
  }

  bool _isThisMonth(Map snapshot, List weekList, DateTime eachDate) {
    bool result = true;
    if (eachDate.month != snapshot['focusDate'].month) {
      result = false;
    }
    return result;
  }

//
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
      children.add(
        TableCell(
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
                        ),
            ),
          ),
        ),
      );
    }
    // return Calendar
    return TableRow(children: children);
  }
}
