import 'package:enquetec/src/themes/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class GraphEnquete extends StatefulWidget {
  final Map<String,int>? result;
  final String question;
  const GraphEnquete({super.key, required this.result, required this.question});

  @override
  State<GraphEnquete> createState() => _GraphEnqueteState();
}

class _GraphEnqueteState extends State<GraphEnquete> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildGraph()
    );
  }

  List<Widget> _buildGraph(){
    List<Widget> graph = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(widget.question, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MainColors.white2)))
        ],
      ),
      const SizedBox(height: 8)
    ];

    double maxY = widget.result!.values.map((e) => e).toList().reduce((value, element) => value > element ? value : element).toDouble();
    maxY += 10 - maxY%10;

    int i = 0;

    List<BarChartGroupData> bars = [];
    widget.result?.forEach((key, value) {
      bars.add(
          BarChartGroupData(
              x: i,
            showingTooltipIndicators: [],
            barRods: [
              BarChartRodData(
                  toY: value.toDouble(),
                color: MainColors.orangeLight,
                width: 25,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                backDrawRodData: BackgroundBarChartRodData(
                  color: MainColors.white2,
                  show: true,
                  toY: maxY
                )
              )
            ]
          )
      );
      i++;
    });

    TextStyle style = const TextStyle(
      fontSize: 12,
    );

    graph.add(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MainColors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: SizedBox(
            height: 200,
            child: BarChart(
                BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    maxY: maxY,
                    minY: 0,
                    barGroups: bars,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (a,b,c,d){
                          return BarTooltipItem(c.toY.toInt().toString(), TextStyle(color: MainColors.orange, fontSize: 12, fontWeight: FontWeight.bold));
                        },
                        tooltipBgColor: MainColors.black2,
                        direction: TooltipDirection.top,
                      )
                    ),
                    titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (a,b){
                              return Text(a.toInt().toString(), style: const TextStyle(fontSize: 12), textAlign: TextAlign.center,);
                            }
                          )
                        ),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta){
                                  Text text;
                                  switch(value.toInt()){
                                    case 0:
                                      text = Text('Péssimo', style: style);
                                      break;
                                    case 1:
                                      text = Text('Ruim', style: style);
                                      break;
                                    case 2:
                                      text = Text('Regular', style: style);
                                      break;
                                    case 3:
                                      text = Text('Bom', style: style);
                                      break;
                                    case 4:
                                      text = Text('Excelente', style: style);
                                      break;
                                    default:
                                      text = const Text('');
                                      break;
                                  }
                                  return text;
                                }
                            )
                        )
                    )
                )
            ),
          ),
        )
    );
    return graph;
  }
}
