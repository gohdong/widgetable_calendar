part of widgetable_calendar;

typedef void OnCalendarCreated(DateTime first, DateTime last);
typedef void OnDaySelected(DateTime day, List events, List holidays);

enum CalendarFormat { Month, Week }

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

  final CalendarFormat calendarFormat;

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
      this.highlightTextColor = Colors.white,
      this.calendarFormat})
      : super(key: key);

  _WidgetableCalendarUIState createState() => _WidgetableCalendarUIState();
}

class _WidgetableCalendarUIState extends State<WidgetableCalendarUI>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // _buildEachWeek2(DateTime.now().add(Duration(days: 3)));
    widget.calendarController.init(calendarFormat: widget.calendarFormat);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double startDXPoint = 0;
  double endDXPoint = 0;

  static List monthList = [
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
  int selectMonthDate = 0;

  // Page Controller - animation
  final PageController pageController = PageController(
    initialPage: 1,
  );

  // gesture detector
//  void _onHorizontalDragStartHandler(DragStartDetails details) {
//    setState(() {
//      startDXPoint = details.globalPosition.dx.floorToDouble();
//    });
//  }
//
//  void _onDragUpdateHandler(DragUpdateDetails details) {
//    setState(() {
//      endDXPoint = details.globalPosition.dx.floorToDouble();
//    });
//  }
//
//  void _onDragEnd(DragEndDetails details) {
//    if (startDXPoint > endDXPoint) {
//      widget.calendarController.changeMonth(1);
//    } else if (startDXPoint < endDXPoint) {
//      widget.calendarController.changeMonth(-1);
//    }
//  }
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
        final children = <Widget>[];

        for (int i = -1; i < 2; i++) {
          children.add(
            Container(
              child: Column(
                children: [
                  Expanded(child: _buildCalendarContent(snapshot.data, i)),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            _buildHeader(snapshot.data),
            Table(
              children: [
                _buildDaysOfWeek(),
              ],
            ),
            Container(
              height: snapshot.data['calendarFormat'] == CalendarFormat.Week
                  ? 50
                  : 300,
              child: PageView(
                controller: pageController,
                onPageChanged: (pageId) async {
                  if (pageId == 2) {
                    await pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.ease,
                    );
                    if (snapshot.data['calendarFormat'] == CalendarFormat.Month)
                      widget.calendarController.changeMonth(1);
                    else
                      widget.calendarController.changeWeek(1);
                    pageController.jumpToPage(1);
                  }
                  if (pageId == 0) {
                    await pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.ease,
                    );
                    if (snapshot.data['calendarFormat'] == CalendarFormat.Month)
                      widget.calendarController.changeMonth(-1);
                    else
                      widget.calendarController.changeWeek(-1);
                    pageController.jumpToPage(1);
                  }
                },
                children: children,
              ),
            ),

            // FlatButtons - For Test
            FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
//                        Map entireColorMap =
//                            widget.calendarController.getLabelColorMap();
                        Map entireColorMap = snapshot.data['labelColorMap'];
                        final children = <Widget>[];

                        entireColorMap.forEach((key, value) {
                          if (key != "empty") {
                            children.add(
                              _buildColorFlatButton(snapshot.data, key, 0),
                            );
                          }
                        });
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: children,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text("ADD EVENTS - Color")),
            FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
//                        Map entireColorMap =
//                            widget.calendarController.getLabelColorMap();
                        Map entireColorMap = snapshot.data['labelColorMap'];
                        final children = <Widget>[];

                        entireColorMap.forEach((key, value) {
                          if (key != "empty") {
                            children.add(
                              _buildColorFlatButton(snapshot.data, key, 2),
                            );
                          }
                        });
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: children,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
//                => widget.calendarController.changeEntireLabelColor("0", Colors.black),
                child: Text("Label Color Change")),
            FlatButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Color resultColor = Colors.black;
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: SingleChildScrollView(
                          child: SlidePicker(
                            pickerColor: Colors.black,
                            onColorChanged: (Color change) {
                              resultColor = change;
                            },
                            paletteType: PaletteType.rgb,
                            enableAlpha: false,
                            displayThumbColor: true,
                            showLabel: false,
                            showIndicator: true,
                            indicatorBorderRadius: const BorderRadius.vertical(
                              top: const Radius.circular(25.0),
                            ),
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              // { colorKey(random value string) : { "name" : customName, "color" : customColor, "toggle" : true or false }  }
                              widget.calendarController.addLabel({
                                DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(): {
                                  "name": "testLabel",
                                  "color": resultColor,
                                  "toggle": true,
                                }
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("ADD Label")),
            FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        Map entireColorMap = snapshot.data['labelColorMap'];
                        final children = <Widget>[];

                        entireColorMap.forEach((key, value) {
                          if (key != "empty") {
                            children.add(
                              _buildColorFlatButton(snapshot.data, key, 3),
                            );
                          }
                        });
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: children,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
//                => widget.calendarController.changeEntireLabelColor("0", Colors.black),
                child: Text("Delete Label")),
            FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        Map entireColorMap = snapshot.data['labelColorMap'];
                        final children = <Widget>[];

                        entireColorMap.forEach((key, value) {
                          if (key != "empty") {
                            children.add(
                              _buildColorFlatButton(snapshot.data, key, 4),
                            );
                          }
                        });
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: children,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
//                => widget.calendarController.changeEntireLabelColor("0", Colors.black),
                child: Text("Toggle Label")),
            _buildEvents(snapshot.data),
          ],
        );
      },
    );
  }

  Widget _buildColorFlatButton(Map snapshot, String colorKey, int type,
      {String eventKey}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(snapshot['labelColorMap'][colorKey]['name'].toString()),
        FlatButton(
          onPressed: () async {
            if (type == 0) {
              widget.calendarController.addEvents(
                {
                  DateTime.now().microsecondsSinceEpoch.toString(): {
                    'summary': 'TEST',
                    'start': snapshot['selectDate'],
                    'end': snapshot['selectDate'].add(Duration(days: 2)),
                    'recurrence': null,
                    'labelColor': colorKey
                  }
                },
              );
              Navigator.of(context).pop();
            } else if (type == 1) {
              widget.calendarController
                  .changeEventsLabelColor(colorKey, eventKey);
              Navigator.of(context).pop();
            } else if (type == 2) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Color resultColor;
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: SlidePicker(
                        pickerColor:
                            widget.calendarController.getLabelColor(colorKey),
                        onColorChanged: (Color change) {
                          resultColor = change;
                        },
                        paletteType: PaletteType.rgb,
                        enableAlpha: false,
                        displayThumbColor: true,
                        showLabel: false,
                        showIndicator: true,
                        indicatorBorderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(25.0),
                        ),
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          widget.calendarController
                              .changeEntireLabelColor(colorKey, resultColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (type == 3) {
              await widget.calendarController.deleteLabel(colorKey);
              Navigator.of(context).pop();
            } else if (type == 4) {
              widget.calendarController.toggleLabel(colorKey);
              Navigator.of(context).pop();
            }
          },
          child: Container(
            height: 25,
            width: 25,
//        color: widget.calendarController.getLabelColor(colorKey) ?? Colors.grey
            color: widget.calendarController.getLabelColorToggle(colorKey)
                ? widget.calendarController.getLabelColor(colorKey)
                : widget.calendarController
                    .getLabelColor(colorKey)
                    .withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Map snapshot) {
    final children = [
      IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          widget.calendarController.changeMonth(-1);
        },
      ),
      Expanded(
        child: Center(
          child: InkWell(
            onTap: () {
              setState(() {
                selectYear = snapshot["selectDate"].year;
                selectMonth = snapshot["selectDate"].month;
                selectMonthDate = snapshot["selectDate"].day;
              });
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                                IconButton(
                                  onPressed: () {
                                    widget.calendarController
                                        .changeMonthCompletely(selectYear,
                                            selectMonth, selectMonthDate);
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: CupertinoDatePicker(
                              initialDateTime: snapshot["selectDate"],
                              onDateTimeChanged: (DateTime time) {
                                setState(() {
                                  selectYear = time.year;
                                  selectMonth = time.month;
                                  selectMonthDate = time.day;
                                });
                              },
                              mode: CupertinoDatePickerMode.date,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                headerText(
                    snapshot['selectDate'].year, snapshot['selectDate'].month),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.weekend),
        onPressed: () {
          widget.calendarController.toggleCalendarFormat();
        },
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () {
//          print(snapshot['calendarFormat']);
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

  Widget headerText(int focusYear, int focusMonth) {
    int monthListIndex = focusMonth - 1;
    if (monthListIndex > 11) {
      monthListIndex = monthListIndex - 12;
      focusYear++;
    } else if (monthListIndex < 0) {
      monthListIndex = monthListIndex + 12;
      focusYear--;
    }
    return Text(focusYear.toString() + " " + monthList[monthListIndex]);
  }

  Widget _buildCalendarContent(Map snapshot, int type) {
    final children = <TableRow>[];

    switch (snapshot['calendarFormat']) {
      case CalendarFormat.Week:
        if (type == -1)
          children.add(_buildEachWeek(
              snapshot, snapshot['selectDate'].subtract(Duration(days: 7)), 0));
        if (type == 0)
          children.add(_buildEachWeek(snapshot, snapshot['selectDate'], 0));
        if (type == 1)
          children.add(_buildEachWeek(
              snapshot, snapshot['selectDate'].add(Duration(days: 7)), 0));
        break;
      default:
        DateTime thisMonthFirstDate = DateTime(
            snapshot['selectDate'].year, snapshot['selectDate'].month + type);

        for (int i = 0; i < 6; i++) {
          children.add(_buildEachWeek(
              snapshot, thisMonthFirstDate.add(Duration(days: i * 7)), type));
        }
    }

    return Table(
      children: children,
    );
  }

  TableRow _buildEachWeek(Map snapshot, DateTime baseDate, int type) {
//    print(snapshot['selectDate'].toString());
    final children = <TableCell>[];
    int baseDay = (baseDate.weekday) % 7;
    DateTime tempDate = baseDate.subtract(Duration(days: baseDay));
    for (int i = 0; i < 7; i++) {
      DateTime eachDate = tempDate.add(Duration(days: i));
      List events = widget.calendarController.findEvents(eachDate);
      children.add(
        TableCell(
          child: InkWell(
            onTap: () {
              widget.calendarController.setSelectDate(eachDate);
              //nextMonth 일때 작아지는 경우는 12->1 뿐.
//              if (snapshot['selectDate'].year * 100 +
//                      snapshot['selectDate'].month >
//                  eachDate.year * 100 + eachDate.month) {
//                widget.calendarController.changeMonth(-1);
//              }
//              if (snapshot['selectDate'].year * 100 +
//                      snapshot['selectDate'].month <
//                  eachDate.year * 100 + eachDate.month) {
//                widget.calendarController.changeMonth(1);
//              }
            },
            child: Container(
              width: double.infinity,
              color: snapshot['selectDate'] == eachDate
                  ? widget.highlightBackgroundColor
                  : eachDate ==
                          DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day)
                      ? widget.todayBackgroundColor
                      : null,
              height: 50,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${eachDate.month}/${eachDate.day}",
                    style:
                        TextStyle(color: dateColor(snapshot, eachDate, type)),
                  ),
                  _buildEventDot(events),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return TableRow(children: children);
  }

  Widget _buildEventDot(List events) {
    final children = <Widget>[];
    for (int i = 0; i < events.length && i < 3; i++) {
      Map eventMap = events[i]["content"];
      Color labelColor =
          widget.calendarController.getLabelColor(eventMap["labelColor"]);
      bool toggle = widget.calendarController
              .getLabelColorToggle(eventMap["labelColor"]) ??
          false;
      if (toggle) {
        children.add(Icon(
          Icons.lens,
          size: 7,
          color: labelColor ?? Colors.grey,
        ));
      }
    }
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
      ],
    );
  }

  Widget _buildEvents(Map snapshot) {
    final children = <Widget>[
      Divider(
        thickness: 5,
      ),
      Expanded(child: _buildEventList(snapshot)),
    ];

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  Widget _buildEventList(Map snapshot) {
    List selectDateEvent =
        widget.calendarController.findEvents(snapshot['selectDate']);
    Map entireColorMap = snapshot['labelColorMap'];

    return ListView.builder(
      itemCount: selectDateEvent != null ? selectDateEvent.length : 0,
      itemBuilder: (context, index) {
        Map eventInfo = selectDateEvent[index]["content"];
        String eventKeyValue = selectDateEvent[index]["id"];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text("$eventInfo"),
            onTap: () {
              print('${eventInfo['summary']} tapped! Label Color Change!');
              final children = <Widget>[];

              entireColorMap.forEach((key, value) {
                if (key != "empty") {
                  children.add(
                    _buildColorFlatButton(snapshot, key, 1,
                        eventKey: eventKeyValue),
                  );
                }
              });
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
//              widget.calendarController
//                  .changeEventsLabelColor("2", keyValue);
            },
          ),
        );
      },
    );
  }

//  bool _isToday(int date, DateTime focusDate, int type) {
//    DateTime today = DateTime.now();
//    if (focusDate.year == today.year &&
//        focusDate.month + type == today.month &&
//        date == today.day) {
//      return true;
//    } else
//      return false;
//  }

//  bool _isThisMonth(Map snapshot, DateTime eachDate, int type) {
//    bool result = true;
//    int focusMonth = snapshot['focusDate'].month + type;
//    if (focusMonth > 12) focusMonth -= 12;
//    if (focusMonth < 1) focusMonth += 12;
//    if (eachDate.month != focusMonth) {
//      result = false;
//    }
//    return result;
//  }

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

  Color dateColor(Map snapshot, DateTime eachDate, int type) {
    if (snapshot['selectDate'].month + type != eachDate.month &&
        snapshot['calendarFormat'] == CalendarFormat.Month) {
      return Colors.grey;
    } else if (eachDate == snapshot['selectDate']) {
      return widget.highlightTextColor;
    } else if (eachDate ==
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
      return widget.todayTextColor;
    } else if (eachDate.weekday == 7) {
      return widget.sundayColor;
    } else if (eachDate.weekday == 6) {
      return widget.saturdayColor;
    }

    return widget.weekDayColor;
  }
}
