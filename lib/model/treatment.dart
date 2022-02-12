import 'dart:io' show Platform;

import '../model/entry.dart';

class Treatment {
  final String id;
  final String eventType;
  final double glucose;
  final String glucoseType;
  final double carbs;
  final double protein;
  final double fat;
  final double insulin;
  final String units;
  final String transmitterId;
  final String sensorCode;
  final String notes;
  final String enteredBy;

  Treatment({
    required this.id,
    required this.eventType,
    required this.glucose,
    required this.glucoseType,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.insulin,
    required this.units,
    required this.transmitterId,
    required this.sensorCode,
    required this.notes,
    required this.enteredBy,
  });

  Treatment.note({
    required Entry lastEntry,
    required String note,
    required DateTime treatmentTime,
    String unt = "mmol/L",
  })  : id = treatmentTime.toUtc().toIso8601String(),
        eventType = "note",
        glucose = (unt == "mmol/L" ? lastEntry.sgv / 18 : lastEntry.sgv * 1.0),
        glucoseType = "",
        carbs = 0.0,
        protein = 0.0,
        fat = 0.0,
        insulin = 0.0,
        // TODO:
        units = unt,
        transmitterId = "",
        sensorCode = "",
        notes = note,
        enteredBy = Platform.operatingSystem;

  Treatment.insulinInjection({
    required Entry lastEntry,
    required String insulinAmount,
    required DateTime treatmentTime,
    String unt = "mmol/L",
  })  : id = treatmentTime.toUtc().toIso8601String(),
        eventType = "insulin",
        glucose = (unt == "mmol/L" ? lastEntry.sgv / 18 : lastEntry.sgv * 1.0),
        glucoseType = "",
        carbs = 0.0,
        protein = 0.0,
        fat = 0.0,
        insulin = (double.tryParse(insulinAmount) ?? 0.0),
        // TODO:
        units = unt,
        transmitterId = "",
        sensorCode = "",
        notes = "",
        enteredBy = Platform.operatingSystem;

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'eventType': eventType,
      'glucose': glucose,
      'glucoseType': glucoseType,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'insulin': insulin,
      'units': units,
      'transmitterId': transmitterId,
      'sensorCode': sensorCode,
      'notes': notes,
      'enteredBy': Platform.operatingSystem,
    };
  }

  Treatment.fromMap(Map<String, dynamic> res)
      : id = res["_id"] ?? "",
        eventType = res["eventType"] ?? "",
        glucose = (res["glucose"] ?? 0.0) * 1.0,
        glucoseType = res["glucoseType"] ?? "",
        carbs = (res["carbs"] ?? 0.0) * 1.0,
        protein = (res["protein"] ?? 0.0) * 1.0,
        fat = (res["fat"] ?? 0.0) * 1.0,
        insulin = (res["insulin"] ?? 0.0) * 1.0,
        units = res["units"] ?? "mmol/L",
        transmitterId = res["transmitterId"] ?? "",
        sensorCode = res["sensorCode"] ?? "",
        notes = res["notes"] ?? "",
        enteredBy = res["enteredBy"] ?? "";
}
