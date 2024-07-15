import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ClimateGraph<T, D> extends StatelessWidget {
  const ClimateGraph({
    required this.title,
    required this.labelFormat,
    required this.series,
    required this.xAxisTitle,
    required this.yAxisTitle,
    this.yMinValue,
    this.yMaxValue,
    this.yAxisInterval,
    super.key,
  });

  final String title;
  final String labelFormat;
  final List<CartesianSeries<T, D>> series;
  final String xAxisTitle;
  final String yAxisTitle;
  final double? yMinValue;
  final double? yMaxValue;
  final double? yAxisInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(8),
      child: SfCartesianChart(
        enableAxisAnimation: true,
        zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
        title: ChartTitle(
          text: title,
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.Hms(),
          intervalType: DateTimeIntervalType.seconds,
          interval: 60,
          autoScrollingDelta: 180,
          autoScrollingDeltaType: DateTimeIntervalType.seconds,
          title: AxisTitle(text: xAxisTitle),
        ),
        primaryYAxis: NumericAxis(
          interval: yAxisInterval,
          majorTickLines: const MajorTickLines(size: 0),
          labelFormat: labelFormat,
          title: AxisTitle(text: yAxisTitle),
          autoScrollingMode: AutoScrollingMode.start,
          minimum: yMinValue,
          maximum: yMaxValue,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: series,
      ),
    );
  }
}
