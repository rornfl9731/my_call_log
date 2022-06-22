import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PersonalBarChart extends StatefulWidget {
  const PersonalBarChart({Key? key, required this.data}) : super(key: key);

  final Map data;

  @override
  State<PersonalBarChart> createState() => _PersonalBarChartState();
}

class _PersonalBarChartState extends State<PersonalBarChart> {
  var max=0;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {

    widget.data.forEach((key, value) {
      value[0] > max ? max = value[0] : max = max;
    });
    return BarChart(BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Mon';
                  break;
                case 1:
                  weekDay = 'Tue';
                  break;
                case 2:
                  weekDay = 'Wed';
                  break;
                case 3:
                  weekDay = 'Thu';
                  break;
                case 4:
                  weekDay = 'Fri';
                  break;
                case 5:
                  weekDay = 'Sat';
                  break;
                case 6:
                  weekDay = 'Sun';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                "",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.data[weekDay][0].toString() ,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    ));
  }


  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('월', style: style);
        break;
      case 1:
        text = const Text('화', style: style);
        break;
      case 2:
        text = const Text('수', style: style);
        break;
      case 3:
        text = const Text('목', style: style);
        break;
      case 4:
        text = const Text('금', style: style);
        break;
      case 5:
        text = const Text('토', style: style);
        break;
      case 6:
        text = const Text('일', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 15,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: max.toDouble()+20,
            color: Color(0xff72d8bf)
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, widget.data['Mon'][0].toDouble(), isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, widget.data['Tue'][0].toDouble(), isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, widget.data['Wed'][0].toDouble(), isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, widget.data['Thu'][0].toDouble(), isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, widget.data['Fri'][0].toDouble(), isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, widget.data['Sat'][0].toDouble(), isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, widget.data['Sun'][0].toDouble(), isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });
}
