import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularChart extends StatefulWidget {
  const CircularChart({super.key});

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  List<_PieData> pieData = [
    _PieData('Metal', 12, "12"),
    _PieData('Sement', 32, "32"),
    _PieData('oisrbg iubspgiu', 18, "18"),
    _PieData('oisrbg', 28, "28"),
    _PieData('Metal', 12, "12"),
    _PieData('Sement', 32, "32"),
    _PieData('oisrbg iubspgiu', 18, "18"),
    _PieData('oisrbg', 28, "28"),
    _PieData('Metal', 12, "12"),
    _PieData('Sement', 32, "32"),
    _PieData('oisrbg iubspgiu', 18, "18"),
    _PieData('oisrbg', 28, "28"),
    _PieData('Metal', 12, "12"),
    _PieData('Sement', 32, "32"),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SfCircularChart(
            legend: Legend(overflowMode: LegendItemOverflowMode.wrap, isVisible: true, position: LegendPosition.top),
            series: <PieSeries<_PieData, String>>[
          PieSeries<_PieData, String>(
              explode: true,
              explodeIndex: 0,
              dataSource: pieData,
              xValueMapper: (_PieData data, _) => data.xData,
              yValueMapper: (_PieData data, _) => data.yData,
              dataLabelMapper: (_PieData data, _) => data.text,
              dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside)),
        ]));
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String? text;
}
