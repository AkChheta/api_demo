// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class SecondPage extends StatefulWidget {
// //   const SecondPage({super.key});

// //   @override
// //   State<SecondPage> createState() => _SecondPageState();
// // }

// // class _SecondPageState extends State<SecondPage> {
// //   List data = ["1", "2", "3"];
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: ElevatedButton(
// //             onPressed: () {
// //               // Navigator.pop(context, data
// //               //     // {
// //               //     //   "key1": "abc",
// //               //     //   "key2": "xyz",
// //               //     // }
// //               //     );

// //               Get.back(
// //                 result: 'data',
// //               );
// //             },
// //             child: Text('BACK')),
// //       ),
// //     );
// //   }
// // }

// body: Center(
//   child: ElevatedButton(
//       onPressed: () async {
//         // data = await Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) => const SecondPage()));

//         data = await Get.to(SecondPage());

//         print("DATA::::${data}");
//       },
//       child: Text(data == null ? 'Data is null' : 'NEXT PAGE')),
// ),

// var dataa = {
//   "data": "1",
//   "data1": "2",
//   "data2": "3",
//   "data3": "4",
// };
// @override
// void initState() {
//   print("Dta::::::::::::${dataa.keys}");
//   print("Dta::::::::::::${dataa.values}");
//   super.initState();
// }

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  Map<DateTime, List<Event>> events = {
    DateTime(2023, 9, 15): [Event(DateTime(2023, 9, 15), 'Event 1')],
    DateTime(2023, 9, 20): [Event(DateTime(2023, 9, 20), 'Event 2')],
  };

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Event> _fetchEvents(DateTime day) {
    return events[day] ?? [];
  }

  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar Table'),
          centerTitle: true,
        ),
        body: TableCalendar(
          // eventLoader: fetchEvents,
          // headerStyle: const HeaderStyle(
          //     titleCentered: true, formatButtonVisible: false),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: _fetchEvents,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ));
  }
}

class Event {
  final DateTime date;
  final String description;

  Event(this.date, this.description);
}

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  final event = CalendarEventData(
    title: 'anshil',
    date: DateTime(2023, 9, 10),
    endDate: DateTime(2023, 9, 15),
    event: "Event 1",
  );

  @override
  void initState() {
    super.initState();
  }

  data() {
    CalendarControllerProvider.of(context).controller.add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MonthView(
        controller: EventController(),
        minMonth: DateTime(1990),
        maxMonth: DateTime(2050),
        initialMonth: DateTime(2023),
        cellAspectRatio: 1,
        onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
        onCellTap: (events, date) {
          // Implement callback when user taps on a cell.
          print(events);
        },
        startDay: WeekDays.sunday,
        onEventTap: (event, date) => print(event),
        onDateLongPress: (date) => print(date),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        data();
      }),
    );
  }
}
