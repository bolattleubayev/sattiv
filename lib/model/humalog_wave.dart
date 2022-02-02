import '../model/wave_data_point.dart';
import '../constants.dart';

class HumalogWave {
  final double magnitude;
  final DateTime injectionTime;
  static const double multiplier = 2.0;
  List<WaveDataPoint> get wave {
    List<WaveDataPoint> tmpWave = [];
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 0.0 + kMinimumPlotXAxis,
        timeInterval: injectionTime,
      ),
    );
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 1.0 + kMinimumPlotXAxis,
        timeInterval: injectionTime.add(
          const Duration(minutes: 60),
        ),
      ),
    );
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 0.25 + kMinimumPlotXAxis,
        timeInterval: injectionTime.add(
          const Duration(minutes: 120),
        ),
      ),
    );
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 0.0 + kMinimumPlotXAxis,
        timeInterval: injectionTime.add(
          const Duration(minutes: 180),
        ),
      ),
    );
    return tmpWave;
  }

  HumalogWave({
    required this.magnitude,
    required this.injectionTime,
  });
}
