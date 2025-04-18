import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/models/internal_order.dart';

class StatsVente extends StatelessWidget {
  final List<InternalOrder> internalOrders;

  const StatsVente({super.key, required this.internalOrders});

  @override
  Widget build(BuildContext context) {
    final data = _getMonthlySalesData();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 200, 221, 237),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SfCartesianChart(
        title: ChartTitle(text: 'Évolution des ventes par mois'),
        primaryXAxis: CategoryAxis(
          title: AxisTitle(text: 'Mois'),
          labelRotation: -45,
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Montant (MAD)'),
          numberFormat: NumberFormat.currency(locale: 'fr', symbol: ''),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y MAD',
        ),
        series: <CartesianSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
            dataSource: data,
            xValueMapper: (SalesData sales, _) => sales.month,
            yValueMapper: (SalesData sales, _) => sales.totalSales,
            name: 'Ventes',
            color: const Color.fromARGB(255, 239, 136, 39),
            width: 3,
            markerSettings: const MarkerSettings(
              isVisible: true,
              height: 5,
              width: 5,
              borderWidth: 2,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
            ),
          ),
        ],
      ),
    );
  }

  List<SalesData> _getMonthlySalesData() {
    final Map<int, double> monthlySales = {};

    for (final order in internalOrders) {
      final month = order.date.month;
      monthlySales[month] = (monthlySales[month] ?? 0) + (order.paidPrice);
    }

    return List.generate(12, (index) {
      final month = index + 1;
      return SalesData(
        month: _getMonthName(month),
        totalSales: monthlySales[month] ?? 0,
      );
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month - 1];
  }
}

class SalesData {
  final String month;
  final double totalSales;

  SalesData({required this.month, required this.totalSales});
}