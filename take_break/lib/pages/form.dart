import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class InputFormPage extends StatefulWidget {
  const InputFormPage({Key? key}) : super(key: key);

  @override
  _InputFormPageState createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime selectedStart = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedEnd = TimeOfDay.now();
  bool tset = false;
  @override
  void initState() {
    dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedStart,
      firstDate: selectedStart,
      lastDate: selectedStart.add(Duration(days: 7)),
    );
    if (selected != null) {
      setState(() {
        selectedStart = selected;
      });
    }
    return selectedStart;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.input);

    if (selected != null) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller:
                    dateController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime pickdate = await _selectDate(context);

                  if (pickdate != null) {
                    print(
                        pickdate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = pickdate
                        .toString(); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need
                    setState(() {
                      dateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller:
                    timeController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.access_time_outlined), //icon of text field
                    labelText: "Enter Start Time" //label text of field
                    ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  TimeOfDay pickTime = await _selectTime(context);

                  if (pickTime != null) {
                    print(
                        pickTime); //get the picked date in the format => 2022-07-04 00:00:00.000
                    print(pickTime
                        .toString()); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need
                    setState(() {
                      timeController.text = pickTime
                          .toString(); //set foratted date to TextField value.
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller:
                      endTimeController, //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon:
                          Icon(Icons.access_time_outlined), //icon of text field
                      labelText: "Enter End Time" //label text of field
                      ),
                  readOnly: true, // when true user cannot edit text
                  onTap: () async {
                    final picktime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime.replacing(
                                hour: selectedTime.hour + 1),
                            initialEntryMode: TimePickerEntryMode.input)
                        .then((value) =>
                            value!.hour > selectedTime.hour ? value : null);

                    if (picktime != null) {
                      print(
                          picktime); //get the picked date in the format => 2022-07-04 00:00:00.000
                      print(picktime
                          .toString()); //formatted date output using intl package =>  2022-07-04
                      //You can format date as per your need
                      setState(() {
                        endTimeController.text = picktime
                            .toString(); //set foratted date to TextField value.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  }),
            ),
          ],
        )));
  }
}
