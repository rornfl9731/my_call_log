import 'dart:io';
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart' hide PieChart;
import 'package:my_call_log/components/personal_bar_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:my_call_log/util/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:screenshot/screenshot.dart';
import '../components/callLogs.dart';
import '../components/personal_pie_chart.dart';

int touchedIndex = -1;

class StaticScreen extends StatefulWidget {
  final String? test;

  const StaticScreen({Key? key, required this.test}) : super(key: key);

  @override
  State<StaticScreen> createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen>
    with WidgetsBindingObserver {
  CallLogs cl = CallLogs();

  late Future<Iterable<CallLogEntry>> logs;
  final controller = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getPersonal(widget.test);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = cl.getPersonal(widget.test);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(logs);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('통계',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                final image = await controller.capture();
                saveAndShare(image!);
              },
              icon: Icon(
                Icons.share,
                color: Colors.black,
              )),
          // IconButton(
          //   onPressed: () {
          //     //함수넣어야지 퓨처
          //     //_show();
          //   },
          //   icon: Icon(
          //     Icons.calendar_month,
          //     color: Colors.black,
          //   ),
          // )
        ],
      ),
      body: Screenshot(
        controller: controller,
        child: Container(
          color: Colors.white,
          child: FutureBuilder<Iterable<CallLogEntry>>(
            future: logs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  Iterable<CallLogEntry>? entries = snapshot.data;
                  List kk = PersonalLogs(entries!);
                  // kk[3]
                  //print((kk[3]['수신'][0] as double));
                  Map<String, double> dataMap = {
                    "수신": kk[3]['수신'][0].toDouble(),
                    "발신": kk[3]['발신'][0].toDouble(),
                  };

                  Map<String, double> dataMap2 = {
                    "수신": kk[3]['수신'][2].toDouble(),
                    "발신": kk[3]['발신'][2].toDouble(),
                  };

                  Map<String, double> dayOfWeek = {
                    "월": kk[2]['Mon'][0].toDouble(),
                    "화": kk[2]['Tue'][0].toDouble(),
                    "수": kk[2]['Wed'][0].toDouble(),
                    "목": kk[2]['Thu'][0].toDouble(),
                    "금": kk[2]['Fri'][0].toDouble(),
                    "토": kk[2]['Sat'][0].toDouble(),
                    "일": kk[2]['Sun'][0].toDouble(),
                  };

                  Map<String, double> dayOfWeek2 = {
                    "월": kk[2]['Mon'][2].toDouble(),
                    "화": kk[2]['Tue'][2].toDouble(),
                    "수": kk[2]['Wed'][2].toDouble(),
                    "목": kk[2]['Thu'][2].toDouble(),
                    "금": kk[2]['Fri'][2].toDouble(),
                    "토": kk[2]['Sat'][2].toDouble(),
                    "일": kk[2]['Sun'][2].toDouble(),
                  };

                  Map<String, double> byTime = {
                    "새벽": kk[4]["새벽"][0].toDouble(),
                    "오전": kk[4]["오전"][0].toDouble(),
                    "오후": kk[4]["오후"][0].toDouble(),
                    "저녁": kk[4]["저녁"][0].toDouble(),
                    "밤": kk[4]["밤"][0].toDouble(),
                  };

                  Map<String, double> byTime2 = {
                    "새벽": kk[4]["새벽"][2].toDouble(),
                    "오전": kk[4]["오전"][2].toDouble(),
                    "오후": kk[4]["오후"][2].toDouble(),
                    "저녁": kk[4]["저녁"][2].toDouble(),
                    "밤": kk[4]["밤"][2].toDouble(),
                  };

                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "${cl.getNames(entries.first)} 통화 기록\n",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              "통화 시간 : ${kk[1]}",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "통화 수 : ${kk[0]}\n",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "요일별",
                              style: TextStyle(fontSize: 24),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PersonalPieChart(
                                    height: 500,
                                    data: dayOfWeek,
                                    kk: kk[2],
                                    centerText: "건수",
                                    legendLabel: {
                                      "월": "월 ${kk[2]['Mon'][0]}",
                                      "화": "화 ${kk[2]['Tue'][0]}",
                                      "수": "수 ${kk[2]['Wed'][0]}",
                                      "목": "목 ${kk[2]['Thu'][0]}",
                                      "금": "금 ${kk[2]['Fri'][0]}",
                                      "토": "토 ${kk[2]['Sat'][0]}",
                                      "일": "일 ${kk[2]['Sun'][0]}",
                                    }),
                                PersonalPieChart(
                                    height: 500,
                                    data: dayOfWeek2,
                                    kk: kk[2],
                                    centerText: "통화시간",
                                    legendLabel: {
                                      "월": "월 ${kk[2]['Mon'][1]}",
                                      "화": "화 ${kk[2]['Tue'][1]}",
                                      "수": "수 ${kk[2]['Wed'][1]}",
                                      "목": "목 ${kk[2]['Thu'][1]}",
                                      "금": "금 ${kk[2]['Fri'][1]}",
                                      "토": "토 ${kk[2]['Sat'][1]}",
                                      "일": "일 ${kk[2]['Sun'][1]}",
                                    }),
                              ],
                            ),
                            Text(
                              "수신 / 발신",
                              style: TextStyle(fontSize: 24),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PersonalPieChart(
                                    data: dataMap,
                                    height: 300,
                                    kk: kk[3],
                                    centerText: "건수",
                                    legendLabel: {
                                      "수신": "수신 : ${kk[3]['수신'][0]}",
                                      "발신": "발신 : ${kk[3]['발신'][0]}"
                                    }),
                                PersonalPieChart(
                                    data: dataMap2,
                                    height: 300,
                                    kk: kk[3],
                                    centerText: "통화시간",
                                    legendLabel: {
                                      "수신": "수신 : ${kk[3]['수신'][1]}",
                                      "발신": "발신 : ${kk[3]['발신'][1]}"
                                    }),
                              ],
                            ),
                            Text(
                              "시간대별",
                              style: TextStyle(fontSize: 24),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PersonalPieChart(
                                    data: byTime,
                                    height: 450,

                                    kk: kk[4],
                                    centerText: "건수",
                                    legendLabel: {
                                      "새벽": "새벽 : ${kk[4]['새벽'][0]}",
                                      "오전": "오전 : ${kk[4]['오전'][0]}",
                                      "오후": "오후 : ${kk[4]['오후'][0]}",
                                      "저녁": "저녁 : ${kk[4]['저녁'][0]}",
                                      "밤": "밤 : ${kk[4]['밤'][0]}",
                                    }),
                                PersonalPieChart(
                                    data: byTime2,
                                    height: 450,
                                    kk: kk[4],
                                    centerText: "통화시간",
                                    legendLabel: {
                                      "새벽": "새벽 : ${kk[4]['새벽'][1]}",
                                      "오전": "오전 : ${kk[4]['오전'][1]}",
                                      "오후": "오후 : ${kk[4]['오후'][1]}",
                                      "저녁": "저녁 : ${kk[4]['저녁'][1]}",
                                      "밤": "밤 : ${kk[4]['밤'][1]}",
                                    }),
                              ],
                            ),

                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Card(
                            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            //         color: const Color(0xff81e5cd),
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: Row(
                            //             children: [
                            //               Expanded(
                            //                 child: Column(
                            //                   children: [
                            //                     Text("요일별 통화 건수"),
                            //                     Container(
                            //                       height: 300,
                            //                       child: PersonalBarChart(data: kk[2],),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Card(
                            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            //         color: const Color(0xff81e5cd),
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: Row(
                            //             children: [
                            //               Expanded(
                            //                 child: Column(
                            //                   children: [
                            //                     Text("요일별 통화 건수"),
                            //                     Container(
                            //                       height: 300,
                            //                       child: PersonalBarChart(data: kk[2],),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text('asd');
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  String getName() {
    return '';
  }

  Future saveAndShare(Uint8List image) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final file = File('${directory}/image.png');
    await file.writeAsBytes(image);
    await Share.shareFiles([file.path]);
  }
}


