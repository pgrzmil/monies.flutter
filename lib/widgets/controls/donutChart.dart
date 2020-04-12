import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      seriesList,
      defaultInteractions: false,
      animate: animate,
      defaultRenderer: ArcRendererConfig(
        arcWidth: 65,
        arcRendererDecorators: [
          ArcLabelDecorator(labelPosition: ArcLabelPosition.outside, insideLabelStyleSpec: TextStyleSpec(fontSize: 12, color: Color.white), outsideLabelStyleSpec: TextStyleSpec(fontSize: 12, color: Color.white)),
        ],
      ),
    );
  }
}
