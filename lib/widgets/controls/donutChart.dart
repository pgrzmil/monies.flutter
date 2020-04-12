import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:monies/consts.dart';

class DonutPieChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    final textColor = Consts.textColor;
    final labelColor = Color(a: textColor.alpha, r: textColor.red, g: textColor.green, b: textColor.blue);
    return PieChart(
      seriesList,
      defaultInteractions: false,
      animate: animate,
      defaultRenderer: ArcRendererConfig(
        arcWidth: 65,
        arcRendererDecorators: [
          ArcLabelDecorator(
            labelPosition: ArcLabelPosition.outside,
            outsideLabelStyleSpec: TextStyleSpec(fontSize: 12, color: labelColor),
          ),
        ],
      ),
    );
  }
}
