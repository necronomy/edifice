import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatefulWidget {
  const BarChart({super.key, required this.map});
  final Map map;

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  late List<_ChartData> data;

  @override
  void initState() {
    data = [];
    for (var key in widget.map.keys) {
      data.add(_ChartData(key, widget.map[key]['totalforchart']));
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    data = [];
    for (var key in widget.map.keys) {
      data.add(_ChartData(key, widget.map[key]['totalforchart']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: data.length * 69 + 49,
      child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
          ),
          series: <ChartSeries<_ChartData, String>>[
            BarSeries<_ChartData, String>(
                dataSource: data,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(9)),
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                color: Colors.deepPurple)
          ]),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
