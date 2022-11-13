import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class InputFormPage extends StatefulWidget {
  const InputFormPage({Key? key}) : super(key: key);

  @override
  _InputFormPageState createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController autoLoc = TextEditingController();
  DateTime selectedStart = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedEnd = TimeOfDay.now();
  bool tset = false;

  CollectionReference jobsRef = FirebaseFirestore.instance.collection("jobs");
  final Location _location = Location();
  String? _sessionToken = null;
  String _latlng = "37.353113,-121.942112";
  late GoogleMapController _gmcontroller;
  var _autoLoc = TextEditingController();
  List<dynamic> _placeList = [];
  @override
  void initState() {
    _autoLoc.addListener(() {
      _onChanged();
    });
    dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _gmcontroller = _cntlr;
    _location.onLocationChanged.listen((l) {
      print(l.latitude);
      print(l.longitude);
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = Uuid().v4();
      });
    }
    getSuggestion(_autoLoc.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyD5DqXn4kkLZAks-koDJEnR8FeMi1fnMvo";

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String req =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(req));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = jsonDecode(response.body)['predictions'];
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load suggestions');
    }
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    print(DateTime.now().toUtc());
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
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
          children: [
            TextField(
              style: TextStyle(color: Colors.black),
              controller: _autoLoc,
              decoration: InputDecoration(
                hintText: "Seek your location here",
                focusColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: Icon(Icons.map),
                suffixIcon: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {},
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeList[index]["description"].toString()),
                  onTap: () async {
                    String kPLACES_API_KEY =
                        "AIzaSyD5DqXn4kkLZAks-koDJEnR8FeMi1fnMvo";
                    String req =
                        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${_placeList[index]["place_id"]}&key=$kPLACES_API_KEY";
                    var response = await http.get(Uri.parse(req)).then(
                        (value) =>
                            "${jsonDecode(value.body)["result"]["geometry"]["location"]["lat"].toString()},${jsonDecode(value.body)["result"]["geometry"]["location"]["lng"].toString()}"
                        //["geometry"]["location"];
                        //var g = "${k["lat"].toString()},${k["lon"].toString()}";

                        );

                    print(response);

                    setState(() {
                      _latlng = response;
                    });
                  },
                );
              },
            ),
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
                      timeController.text =
                          "${pickTime.hour}:${pickTime.minute}"; //set foratted date to TextField value.
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
                        endTimeController.text =
                            "${picktime.hour}:${picktime.minute}";
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
