import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/api/api_service.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/models/workout.dart';
import 'package:unbroken/models/workout_slot.dart';
import 'package:unbroken/models/workout_type.dart';
import 'package:unbroken/services/storage_service.dart';
import 'package:unbroken/util/error_messages.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

// variable is widget param, when state is changed widget should be updated

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WorkoutTimesheetScreen(),
      theme: ThemeData.dark(),
    );
  }
}

class WorkoutTimesheetScreen extends StatefulWidget {
  const WorkoutTimesheetScreen({super.key});

  @override
  State<WorkoutTimesheetScreen> createState() => _WorkoutTimesheetScreenState();
}

class _WorkoutTimesheetScreenState extends State<WorkoutTimesheetScreen> {
  String selectedTab = 'Workout';

  // List<WorkoutType> _dropdownItems = [];
  late WorkoutType _selectedDropdownItem = WorkoutType.FUNCTIONAL_FITNESS;
  late int _userId;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<WorkoutType, String> _dateWorkouts = {};
  String? _workoutDescription;
  final List<DateTime> _userWorkoutDates = [];

  List<WorkoutSlot> _dateWorkoutSlots = [];

  final apiService = getIt<ApiService>();
  final _storageService = getIt<StorageService>();

  @override
  void initState() {
    super.initState();

    // fetchDropdownItems();
    _loadData();
  }

  Future<void> _loadData() async {
    _selectedDropdownItem = (await _storageService.getUserWorkoutType())!;
    _userId = (await _storageService.getUserId())!;

    _loadWorkouts(_focusedDay);
    _loadWorkoutSlots(_focusedDay);
    _loadAttendeeWorkoutDates(_focusedDay);
  }

  void _showMessage(final bool isSuccess, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.blue : Colors.red,
      ),
    );
  }

  Future<void> _loadWorkouts(DateTime date) async {
    try {
      String formattedDate = DateFormat("yyyy-MM-dd").format(date);
      final response =
          await apiService.get("${ApiEndpoints.workouts}$formattedDate");
      List<Workout> workouts =
          response.map<Workout>((s) => Workout.fromJson(s)).toList();
      _dateWorkouts = {
        for (var workout in workouts) workout.type: workout.text
      };
      setState(() {
        _workoutDescription = _dateWorkouts[_selectedDropdownItem];
      });
    } on ApiError catch (e) {
      if (mounted) {
        _showMessage(false, ErrorMessages.getMessage(e.code));
      }
    }
  }

  Future<void> _loadWorkoutSlots(DateTime date) async {
    try {
      String formattedDate = DateFormat("yyyy-MM-dd").format(date);
      final response =
          await apiService.get("${ApiEndpoints.workoutSlots}$formattedDate");
      List<WorkoutSlot> workoutSlots =
          response.map<WorkoutSlot>((s) => WorkoutSlot.fromJson(s)).toList();
      setState(() {
        _dateWorkoutSlots = workoutSlots;
      });
    } on ApiError catch (e) {
      if (mounted) {
        _showMessage(false, ErrorMessages.getMessage(e.code));
      }
    }
  }

  Future<void> _loadAttendeeWorkoutDates(DateTime date) async {
    bool monthExistsInList = _userWorkoutDates.any((existingDate) =>
        existingDate.year == date.year && existingDate.month == date.month);
    if (date.isAfter(DateTime.now()) || monthExistsInList) return;
    try {
      String formattedDate = DateFormat("yyyy-MM-dd").format(date);
      final response = await apiService
          .get("${ApiEndpoints.attendeeWorkoutDates}$formattedDate");
      List<DateTime> workoutDates = (response as List<dynamic>)
          .map((date) => DateTime.parse(date as String))
          .toList();
      setState(() {
        _userWorkoutDates.addAll(workoutDates);
      });
    } on ApiError catch (e) {
      if (mounted) {
        _showMessage(false, ErrorMessages.getMessage(e.code));
      }
    }
  }

  void _fetchTimesheetsAndWorkouts(DateTime selectedDay, DateTime focusedDay) {
    if (isSameDay(_selectedDay, selectedDay)) return;

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _loadWorkouts(selectedDay);
    _loadWorkoutSlots(selectedDay);
  }

  Future<void> _addOrRemoveAttendance(int workoutSlotId) async {
    try {
      await apiService.post(
          ApiEndpoints.workoutSlotAttendeeAddOrRemove
              .replaceFirst("{id}", workoutSlotId.toString()),
          body: null);
      _showMessage(true, "Success!");
      _loadWorkoutSlots(_focusedDay);
    } on ApiError catch (e) {
      _showMessage(false, ErrorMessages.getMessage(e.code));
    }
  }

  void selectTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          scrolledUnderElevation: 0,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            DropdownButton<WorkoutType>(
              underline: const SizedBox(),
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              value: _selectedDropdownItem,
              items: WorkoutType.values
                  .map((WorkoutType item) => DropdownMenuItem<WorkoutType>(
                      value: item, child: Text(item.value)))
                  .toList(),
              onChanged: (WorkoutType? newValue) {
                setState(() {
                  _selectedDropdownItem = newValue!;
                  if (_dateWorkouts.isNotEmpty) {
                    _workoutDescription = _dateWorkouts[_selectedDropdownItem];
                  }
                });
              },
            ),
            Image.asset('assets/images/logo.png', width: 150)
          ])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xff141414),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: TableCalendar(
                  firstDay: DateTime(2023),
                  lastDay: DateTime(2050),
                  focusedDay: _focusedDay,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  headerStyle: const HeaderStyle(titleCentered: true),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _fetchTimesheetsAndWorkouts,
                  holidayPredicate: (day) {
                    // using holidays for attendance
                    DateTime dateWithoutTime =
                        DateTime(day.year, day.month, day.day);
                    return _userWorkoutDates.contains(dateWithoutTime);
                    // return day.weekday < 2;
                  },
                  calendarStyle: const CalendarStyle(
                    // Copied from CalendarStyle.selectedDecoration
                  selectedDecoration: BoxDecoration(
                        color: GlobalConstants.appColor,
                        shape: BoxShape.circle),
                    selectedTextStyle: TextStyle(color: Color(0xFF515151)),
                    todayDecoration: BoxDecoration(
                        color: Color(0xFF009945), shape: BoxShape.circle),
                    holidayDecoration: BoxDecoration(
                      color: Color(0xFF005e28),
                      shape: BoxShape.circle,
                    ),
                    holidayTextStyle: TextStyle(color: Colors.white),
                  ),
                  onPageChanged: (day) {
                    // NOTE: setting this because setState in _loadAttendeeWorkoutDates will re-render calendar which has specified focusedDay param (_focusedDay) therefore will always display one original month page
                    _focusedDay = day;
                    _loadAttendeeWorkoutDates(day);
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              TabSelection(
                selectedTab: selectedTab,
                selectTab: selectTab,
              ),
              const SizedBox(height: 8.0),
              selectedTab == 'Workout'
                  ? WorkoutDescription(description: _workoutDescription)
                  : WorkoutTimes(
                      workoutSlots: _dateWorkoutSlots,
                      userId: _userId,
                      isButtonVisible:
                          DateUtils.isSameDay(_focusedDay, DateTime.now()) ||
                              _focusedDay.isAfter(DateTime.now()),
                      addOrRemoveAttendance: _addOrRemoveAttendance),
            ],
          ),
        ),
      ),
    );
  }
}

class TabSelection extends StatelessWidget {
  final String selectedTab;
  final Function(String) selectTab;

  const TabSelection({
    super.key,
    required this.selectedTab,
    required this.selectTab,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedTab == 'Timesheet'
                  ? GlobalConstants.appColor
                  : const Color(0xff141414),
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: GlobalConstants.appColor,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            onPressed: () => selectTab('Timesheet'),
            child: Text(
              'TIMESHEET',
              style: GoogleFonts.poppins(
                color: selectedTab == 'Timesheet' ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedTab == 'Workout'
                  ? GlobalConstants.appColor
                  : const Color(0xff141414),
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: GlobalConstants.appColor,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
            onPressed: () => selectTab('Workout'),
            child: Text(
              'WORKOUT',
              style: GoogleFonts.poppins(
                color: selectedTab == 'Workout' ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WorkoutDescription extends StatelessWidget {
  final String? description;

  const WorkoutDescription({
    super.key,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xff141414),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Builder(builder: (context) {
          if (description != null) {
            return Text(
              description!,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            );
          } else {
            return Center(
                child: Text("No data available for selected date.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    )));
          }
        }));
  }
}

class WorkoutTimes extends StatefulWidget {
  final List<WorkoutSlot> workoutSlots;
  final int userId;
  final bool isButtonVisible;
  final Function addOrRemoveAttendance;

  const WorkoutTimes(
      {super.key,
      required this.workoutSlots,
      required this.userId,
      required this.isButtonVisible,
      required this.addOrRemoveAttendance});

  @override
  State<WorkoutTimes> createState() => _WorkoutTimesState();
}

class _WorkoutTimesState extends State<WorkoutTimes> {
  late List<bool> _isExpandedList;

  void _initializeExpandedList() {
    _isExpandedList = List<bool>.filled(widget.workoutSlots.length, false);
  }

  @override
  void initState() {
    super.initState();
    _initializeExpandedList();
  }

  @override
  void didUpdateWidget(covariant WorkoutTimes oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeExpandedList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.workoutSlots.isEmpty) {
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color(0xff141414),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Center(
              child: Text("No time slots available for selected date.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ))));
    } else {
      return Column(
        children: widget.workoutSlots.asMap().entries.map((entry) {
          int index = entry.key;
          WorkoutSlot timeSlot = entry.value;
          String subtitle = "";
          bool isUserAttendee = timeSlot.isUserAttendee(widget.userId);
          if (widget.isButtonVisible && isUserAttendee) {
            subtitle = "Attending";
          } else if (widget.isButtonVisible && !isUserAttendee) {
            subtitle = "Sign up";
          } else if (!widget.isButtonVisible && isUserAttendee) {
            subtitle = "Attended";
          }

          return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionPanelList(
                expansionCallback: (expansionPanelIndex, isExpanded) {
                  setState(() {
                    _isExpandedList[index] = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    backgroundColor: const Color(0xff141414),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title:
                              Text("${timeSlot.timeFrom} - ${timeSlot.timeTo}"),
                          subtitle: Text(subtitle,
                              style: GoogleFonts.poppins(color: Colors.white)));
                    },
                    body: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...timeSlot.attendees.map<Widget>((attendee) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            ApiEndpoints.imagesUrl +
                                                attendee.image!),
                                      ),
                                      trailing: attendee.instagramUrl != null
                                          ? GestureDetector(
                                              onTap: () async {
                                                await launchUrl(Uri.parse(
                                                    GlobalConstants
                                                            .instagramUrl +
                                                        attendee
                                                            .instagramUrl!));
                                              },
                                              child: const CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xFF1d1b2c),
                                                  backgroundImage: AssetImage(
                                                      "assets/images/instagram.png")))
                                          : null,
                                      title: Text(attendee.fullName),
                                    );
                                  }),
                                  if (widget.isButtonVisible)
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16, right: 16),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    widget
                                                        .addOrRemoveAttendance(
                                                            timeSlot.id);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        isUserAttendee
                                                            ? const Color(
                                                                0xCC2C2C2C)
                                                            : GlobalConstants
                                                                .appColor,
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: Text(
                                                      isUserAttendee
                                                          ? 'Leave'
                                                          : 'Sign Up',
                                                      style: GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: timeSlot
                                                                  .isUserAttendee(
                                                                      widget
                                                                          .userId)
                                                              ? GlobalConstants
                                                                  .appColor
                                                              : const Color(
                                                                  0xCC2C2C2C))))),
                                        ]),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    // isExpanded: timeSlot['isExpanded'],
                    isExpanded: _isExpandedList[index],
                  ),
                ],
              ));
        }).toList(),
      );
    }
  }
}
