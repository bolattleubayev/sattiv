import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:sattiv/model/calibration_plot_datapoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/entry.dart';
import '../model/treatment.dart';
import '../model/measured_blood_glucose.dart';

/// From the internet about calibrations
/// sgv=(unfiltered/1000-intercept)*slope
/// mbg contains actual measured values
/// cal has intercept and slope
/// https://api-address.herokuapp.com/api/v1/entries/cal.json?count=3
/// mbg and cal are on same timestamps
/// https://api-address.herokuapp.com/api/v1/entries/mbg.json?count=3

/// DB-bound service

Future<Entry> getLastEntry() async {
  final prefs = await SharedPreferences.getInstance();
  final _baseUrl = prefs.getString('baseUrl') ?? "";

  final url = Uri.parse("$_baseUrl/api/v1/entries/sgv.json?count=1");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }

  var responseData = json.decode(response.body);

  return Entry.fromMap(responseData.first);

  // TODO: handle this case if no response received
  return Entry.defaultValues();
}

Future<List<CalibrationPlotDatapoint>> getCalibrationData(
    {int count = 5}) async {
  List<MeasuredBloodGlucose> mbgs =
      await getLastMeasuredBloodGlucoseFromApi(count: count);
  List<CalibrationPlotDatapoint> datapoints = [];

  for (var mbg in mbgs) {
    int sensorValue =
        (await getAvgSugarValueWithin10MinRange(date: mbg.date)).sgv;
    CalibrationPlotDatapoint newPoint = CalibrationPlotDatapoint(
        dateString: mbg.dateString,
        date: mbg.date,
        measuredValue: mbg.mbg,
        sensorValue: sensorValue);

    datapoints.add(newPoint);
  }
  return datapoints;
}

/// Pre-DB services

Future<List<MeasuredBloodGlucose>> getLastMeasuredBloodGlucoseFromApi(
    {required int count}) async {
  final prefs = await SharedPreferences.getInstance();
  final _baseUrl = prefs.getString('baseUrl') ?? "";

  final url = Uri.parse("$_baseUrl/api/v1/entries/mbg.json?count=$count");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }

  var responseData = json.decode(response.body);
  //Creating a list to store input data;
  List<MeasuredBloodGlucose> measuredBloodGlucoseReadings = [];
  for (var singleMbg in responseData) {
    MeasuredBloodGlucose measuredBloodGlucose =
        MeasuredBloodGlucose.fromMap(singleMbg);

    //Adding entry to the list.
    measuredBloodGlucoseReadings.add(measuredBloodGlucose);
  }
  return measuredBloodGlucoseReadings;
}

Future<Entry> getAvgSugarValueWithin10MinRange({required int date}) async {
  final prefs = await SharedPreferences.getInstance();
  final _baseUrl = prefs.getString('baseUrl') ?? "";

  DateTime currentTime = DateTime.fromMillisecondsSinceEpoch(date).toLocal();
  String oneMinUp =
      currentTime.add(const Duration(minutes: 1)).toUtc().toIso8601String();
  String tenMinDown = currentTime
      .subtract(const Duration(minutes: 10))
      .toUtc()
      .toIso8601String();

  final url = Uri.parse(
      "$_baseUrl/api/v1/entries/sgv.json?count=1&find[dateString][\$gte]=$tenMinDown&find[dateString][\$lte]=$oneMinUp");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }

  var responseData = json.decode(response.body);

  Entry correspondingEntry = Entry.fromMap(responseData.first);

  return correspondingEntry;
}

Future<void> deleteTreatmentByCreationDate(
    String baseUrl, String sha1ApiSecret, String createdAt) async {
  final deleteUrl = Uri.parse(
      "$baseUrl/api/v1/treatments.json?find[created_at][\$eq]=$createdAt");

  final response = await http.delete(
    deleteUrl,
    headers: <String, String>{
      'API-SECRET': sha1ApiSecret,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }
}

Future<void> undoLastTreatment() async {
  // Get ID of the last treatment
  final prefs = await SharedPreferences.getInstance();
  final _baseUrl = prefs.getString('baseUrl') ?? "";
  final _sha1ApiSecret = prefs.getString('apiSecretSha1') ?? "";

  final url = Uri.parse("$_baseUrl/api/v1/treatments.json?count=1");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }

  var responseData = json.decode(response.body);
  //Creating a list to store input data;
  String createdAt = responseData.first["created_at"];

  await deleteTreatmentByCreationDate(_baseUrl, _sha1ApiSecret, createdAt);
}

Future<List<Treatment>> getTreatmentsFromApi(
    {required DateTime afterTime}) async {
  final prefs = await SharedPreferences.getInstance();
  final _baseUrl = prefs.getString('baseUrl') ?? "";

  String timeString = afterTime.toUtc().toIso8601String();
  final url = Uri.parse(
      "$_baseUrl/api/v1/treatments.json?find[created_at][\$gte]=$timeString");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }

  var responseData = json.decode(response.body);
  //Creating a list to store input data;
  List<Treatment> treatments = [];
  for (var singleEntry in responseData) {
    Treatment treatment = Treatment.fromMap(singleEntry);

    //Adding treatment to the list.
    treatments.add(treatment);
  }

  return treatments;
}

postTreatment(Treatment treatment) async {
  final prefs = await SharedPreferences.getInstance();
  final _baseUrl = prefs.getString('baseUrl') ?? "";
  final _sha1ApiSecret = prefs.getString('apiSecretSha1') ?? "";

  final url = Uri.parse("$_baseUrl/api/v1/treatments.json");

  final response = await http.post(
    url,
    headers: <String, String>{
      'API-SECRET': _sha1ApiSecret,
      'Content-Type': 'application/json',
    },
    body: jsonEncode(treatment.toMap()),
  );

  if (response.statusCode != 200) {
    throw Exception('status code ${response.statusCode}');
  }
}
