import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/sns_graph/sns_graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SnsGraphView extends StatelessWidget {
  const SnsGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(child: TemperatureGraph()),
          SizedBox(height: 16),
          Expanded(child: HumidityGraph()),
        ],
      ),
    );
  }
}

@visibleForTesting
class TemperatureGraph extends StatelessWidget {
  const TemperatureGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return ClimateGraph(
      title: 'Temperature 🌡️',
      labelFormat: '{value}°C',
      series: [
        SplineSeries(
          xValueMapper: (climate, _) => climate.timestamp,
          yValueMapper: (climate, _) => climate.temperature,
          dataSource: context.select((SnsGraphBloc bloc) => bloc.state.data),
          name: 'Temperature',
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
      xAxisTitle: 'Time',
      yAxisTitle: 'Temperature (°C)',
      yAxisInterval: 1,
    );
  }
}

@visibleForTesting
class HumidityGraph extends StatelessWidget {
  const HumidityGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return ClimateGraph(
      title: 'Humidity 💨',
      labelFormat: '{value}%',
      series: [
        SplineSeries(
          xValueMapper: (climate, _) => climate.timestamp,
          yValueMapper: (climate, _) => climate.humidity,
          dataSource: context.select((SnsGraphBloc bloc) => bloc.state.data),
          name: 'Humidity',
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
      xAxisTitle: 'Time',
      yAxisTitle: 'Humidity (%)',
      yMinValue: 0,
      yMaxValue: 100,
      yAxisInterval: 10,
    );
  }
}
