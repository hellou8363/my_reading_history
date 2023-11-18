import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_reading_history/custom_bottom_navigation_bar.dart';
import 'package:my_reading_history/database_helper.dart';
import 'package:provider/provider.dart';

class ReadingStatisticsScreen extends StatefulWidget {
  const ReadingStatisticsScreen({super.key});

  @override
  State<ReadingStatisticsScreen> createState() =>
      _ReadingStatisticsScreenState();
}

class _ReadingStatisticsScreenState extends State<ReadingStatisticsScreen> {
  int year = DateTime.now().year;
  late Future<List<String>> yearsList;

  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    yearsList = databaseHelper.getYearsList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dateDropdownButton(),
              const SizedBox(height: 20),
              Container(
                height: 200,
                color: Colors.blueAccent[100],
                child: StatisticsChart(year: year),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }

  Widget dateDropdownButton() {
    return FutureBuilder<List<String>>(
      future: yearsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> options = snapshot.data!;
          return DropdownButton<String>(
            iconSize: 0,
            underline: const SizedBox(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            borderRadius: BorderRadius.circular(10),
            // value: options.isNotEmpty ? options.last : null,
            value: year.toString(),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                alignment: Alignment.center,
                child: Text(
                  option,
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              year = int.parse(value!);
              setState(() {});
            },
          );
        }
      },
    );
  }
}

class StatisticsChart extends StatefulWidget {
  final int year;

  const StatisticsChart({super.key, required this.year});

  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  List<BarChartGroupData> dataList = [];
  late Map<String, int> monthCountList;
  late int year;

  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    dataList = [];
    year = widget.year;

    return FutureBuilder(
      future: databaseHelper.getDateCountList(year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('독서록을 저장 후 통계 페이지를 이용할 수 있어요~(＠_＠;)'),
          );
        } else {
          monthCountList = snapshot.data as Map<String, int>;

          return BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: 50,
            ),
          );
        }
      },
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text('${value.toInt() + 1}월', style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  List<BarChartGroupData> get barGroups {
    for (int i = 0; i < 12; i++) {
      String index = i < 10 ? '0${i + 1}' : (i + 1).toString();
      dataList.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: monthCountList.containsKey(index)
                    ? monthCountList[index]!.toDouble()
                    : 0,
                borderRadius: BorderRadius.zero,
                color: Colors.deepPurple),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return dataList;
  }
}
