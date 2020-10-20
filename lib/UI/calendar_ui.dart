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

  // Complete Month Changer
  int selectYear = 0;
  int selectMonth = 0;

  final PageController pageController = PageController( initialPage: 1, );

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
    if (startDXPoint > endDXPoint) {
      widget.calendarController.changeMonth(1);
    }
    else if (startDXPoint < endDXPoint) {
      widget.calendarController.changeMonth(-1);
    }
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
//        return ClipRect(
//          child: GestureDetector(
//            onHorizontalDragStart: _onHorizontalDragStartHandler,
//            onHorizontalDragUpdate: _onDragUpdateHandler,
//            onHorizontalDragEnd: _onDragEnd,
//            child: Container(
//              child: Column(
//                children: [
//                  _buildHeader(snapshot.data),
//                  _buildCalendarContent(snapshot.data),
//                  FlatButton(
//                      onPressed: () => widget.calendarController.addEvents(),
//                      child: Text("ADD EVENTS")),
//                  _buildEvents(snapshot.data)
//                ],
//              ),
//            ),
//          ),
//        );

        return ClipRect(
          child: GestureDetector(
            onHorizontalDragStart: _onHorizontalDragStartHandler,
            onHorizontalDragUpdate: _onDragUpdateHandler,
            onHorizontalDragEnd: _onDragEnd,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: [
                      SizedBox.expand(
                        child: Container(
                          child: Column(
                            children: [
                              _buildHeader(snapshot.data, -1),
                              _buildCalendarContent(snapshot.data, -1),
                            ],
                          ),
                        ),
                      ),
                      SizedBox.expand(
                        child: Container(
                          child: Column(
                            children: [
                              _buildHeader(snapshot.data, 0),
                              _buildCalendarContent(snapshot.data, 0),
                            ],
                          ),
                        ),
                      ),
                      SizedBox.expand(
                        child: Container(
                          child: Column(
                            children: [
                              _buildHeader(snapshot.data, 1),
                              _buildCalendarContent(snapshot.data, 1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () => widget.calendarController.addEvents(),
                    child: Text("ADD EVENTS")),
                _buildEvents(snapshot.data),
              ],
            ),
          ),
        );
      },
    );
  }

  int findYear(int year){
    int returnValue = 0;
    for (int i=0 ; i<yearList.length ; i++){
      if (yearList[i] == year.toString()) return i;
    }
    return returnValue;
  }

  Widget _buildHeader(Map snapshot, int type) {
    final children = [
      IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
//          widget.calendarController.changeMonth(-1);
        },
      ),
      Expanded(
        child: Center(
          child: InkWell(
            onTap: () async{
              setState(() {
                selectYear = snapshot["focusDate"].year;
                selectMonth = snapshot["focusDate"].month;
              });
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
              widget.calendarController.changeMonthCompletely(selectYear, selectMonth);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeaderText(snapshot['focusDate'].year, snapshot['focusDate'].month, type),
//                Text(snapshot['focusDate'].year.toString() +
//                    " " +
//                    monthList[snapshot['focusDate'].month - 1 + type]),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () {
//          widget.calendarController.changeMonth(1);
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

  Widget HeaderText(int focusYear,int focusMonth,int type){
    int monthListIndex = focusMonth - 1 + type;
    if (monthListIndex > 11){
      monthListIndex  = monthListIndex - 12;
      focusYear++;
    } else if (monthListIndex < 0){
      monthListIndex  = monthListIndex + 12;
      focusYear--;
    }
    return Text(focusYear.toString() +
        " " +
        monthList[monthListIndex]);
  }


  Widget _buildCalendarContent(Map snapshot, int type) {
    final children = <TableRow>[_buildDaysOfWeek()];
    List weekList = [];

    if (type == -1) weekList = snapshot['prevWeekList'];
    else if (type == 0) weekList = snapshot['weekList'];
    else if (type == 1) weekList = snapshot['nextWeekList'];

    for (int i = 0; i < weekList.length; i++) {
      children.add(_buildEachWeek(snapshot, weekList[i],type));
    }
    return Table(
      children: children,
    );
  }

  TableRow _buildEachWeek(Map snapshot, List weekList, int type) {
    final children = <TableCell>[];

    for (int i = 0; i < weekList.length; i++) {
      DateTime eachDate = DateTime(snapshot['focusDate'].year,
          snapshot['focusDate'].month + type, weekList[i]); // 정확한 날짜
      bool thisMonth = _isThisMonth(snapshot, weekList, eachDate, type);
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
                    DateTime(snapshot['focusDate'].year,
                        snapshot['focusDate'].month, weekList[i]),
                    [],
                    []);

//              if (!thisMonth && weekList[i] <= 0)
//                widget.calendarController.changeMonth(-1);
//              if (!thisMonth && weekList[i] > 0)
//                widget.calendarController.changeMonth(1);
            },
            child: Container(
              width: double.infinity,
              color: _isToday(weekList[i], snapshot['focusDate'], type)
                  ? widget.todayBackgroundColor
                  : widget.calendarController.isSelectedDate(
                      DateTime(snapshot['focusDate'].year,
                          snapshot['focusDate'].month + type, weekList[i]),
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
                                ? _isToday(weekList[i], snapshot['focusDate'], type)
                                    ? widget.todayTextColor
                                    : widget.calendarController.isSelectedDate(
                                        DateTime(
                                            snapshot['focusDate'].year,
                                            snapshot['focusDate'].month + type,
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
                                            weekList[i], snapshot['focusDate'], type)
                                        ? widget.todayTextColor
                                        : widget.calendarController
                                                .isSelectedDate(
                                            DateTime(
                                                snapshot['focusDate'].year,
                                                snapshot['focusDate'].month + type,
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
                                            weekList[i], snapshot['focusDate'], type)
                                        ? widget.todayTextColor
                                        : widget.calendarController
                                                .isSelectedDate(
                                            DateTime(
                                                snapshot['focusDate'].year,
                                                snapshot['focusDate'].month + type,
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

  bool _isToday(int date, DateTime focusDate, int type) {
    DateTime today = DateTime.now();
    if (focusDate.year == today.year &&
        focusDate.month + type == today.month &&
        date == today.day) {
      return true;
    } else
      return false;
  }

  bool _isThisMonth(Map snapshot, List weekList, DateTime eachDate, int type) {
    bool result = true;
    if (eachDate.month != snapshot['focusDate'].month + type) {
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
    // return Calendar
    return TableRow(children: children);
  }
}
