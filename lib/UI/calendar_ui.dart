part of widgetable_calendar;

typedef void OnCalendarCreated(DateTime first, DateTime last);
typedef void OnDaySelected(DateTime day, List events, List holidays);

class WidgetableCalendarUI extends StatefulWidget {
  final Color weekDayColor;
  final Color sundayColor;
  final Color saturdayColor;
  final Color backgroundColor;
  final Color lineColor;

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
      this.events})
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
        return Column(
          children: [
            _buildHeader(snapshot.data),
            _buildCalendarContent(snapshot.data),
            FlatButton(
                onPressed: () => widget.calendarController.addEvents(),
                child: Text("ADD EVENTS"))
          ],
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
        child: Container(
          child: Center(
              child: Text(snapshot['focusDate'].year.toString() +
                  " " +
                  monthList[snapshot['focusDate'].month - 1])),
        ),
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

    DateTime lastDay =
        DateTime(snapshot['focusDate'].year, snapshot['focusDate'].month + 1, 1)
            .subtract(new Duration(days: 1));

    for (int i = 0; i < weekList.length; i++) {
      //    DateTime someDate = DateTime(snapshot['focusDate'].year, snapshot['focusDate'].month, weekList[i]);   // 정확한 날짜
      String date = weekList[i] > 0 && weekList[i] <= lastDay.day
          ? weekList[i].toString()
          : "";
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
            },
            child: Container(
              width: double.infinity,
              color: _isToday(weekList[i], snapshot['focusDate'])
                  ? Colors.grey[300]
                  : widget.calendarController.isSelectedDate(
                      DateTime(snapshot['focusDate'].year,
                          snapshot['focusDate'].month, weekList[i]),
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

//
  bool _isToday(int date, DateTime focusDate) {
    DateTime today = DateTime.now();
    if (focusDate.year == today.year &&
        focusDate.month == today.month &&
        date == today.day) {
      return true;
    } else
      return false;
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

    return TableRow(children: children);
  }
}
