import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:monies/widgets/controls/donutChart.dart';

class AnalyticsCard extends StatelessWidget {
  final List<Series> chartData;
  final bool chartAnimated;
  final GestureTapCallback onTap;

  const AnalyticsCard({Key key, this.chartData, this.chartAnimated, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      child: InkWell(
          child: Column(
            children: [
              Text("Analytics"),
              SizedBox(
                height: 300,
                width: 400,
                child: DonutPieChart(chartData, animate: chartAnimated),
              ),
            ],
          ),
          onTap: onTap),
    );
  }
}
