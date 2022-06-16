import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/callLogs.dart';

class HomeScreen extends StatefulWidget {
  final DateTimeRange selectedDateRange2;

  const HomeScreen({Key? key, required this.selectedDateRange2})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  //final String TestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  //BannerAd? banner;

  DateTimeRange _selectedDateRange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 3));
  final TextStyle whiteText = TextStyle(color: Colors.white);
  CallLogs cl = CallLogs();

  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getToday(_selectedDateRange.start, _selectedDateRange.end);
    // banner = BannerAd(
    //     listener: BannerAdListener(
    //       // Called when an ad is successfully received.
    //       onAdLoaded: (Ad ad) => print('Ad loaded.'),
    //       // Called when an ad request failed.
    //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //         // Dispose the ad here to free resources.
    //         ad.dispose();
    //         print('Ad failed to load: $error');
    //       },
    //       // Called when an ad opens an overlay that covers the screen.
    //       onAdOpened: (Ad ad) => print('Ad opened.'),
    //       // Called when an ad removes an overlay that covers the screen.
    //       onAdClosed: (Ad ad) => print('Ad closed.'),
    //       // Called when an impression occurs on the ad.
    //       onAdImpression: (Ad ad) => print('Ad impression.')),
    //   size: AdSize.mediumRectangle,
    //   adUnitId: TestUnitId,
    //   request: AdRequest(),
    // )..load();
    // print(banner);
    print("============================");
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
        logs = cl.getToday(_selectedDateRange.start, _selectedDateRange.end);
        logs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "통화 기록",
          style: GoogleFonts.gaegu(
              textStyle: TextStyle(color: Colors.white, fontSize: 25)),
        ),
        toolbarHeight: 60,
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share("공유하기 테스트");
              },
              icon: Icon(Icons.share)),
          IconButton(
            onPressed: () {
              //함수넣어야지 퓨처
              _show();
            },
            icon: Icon(Icons.calendar_month),
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<Iterable<CallLogEntry>>(
              future: logs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Iterable<CallLogEntry>? entries = snapshot.data;
                  return Ranking(entries!);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      setState(() {
        _selectedDateRange = result;
        logs = cl.getToday(_selectedDateRange.start, _selectedDateRange.end);
      });
    }
  }

  Ranking(Iterable<CallLogEntry> entry) {
    if (entry.isNotEmpty) {
      Map my_map = {};
      var rs = entry.fold(0, (previousValue, element) {
        if (my_map.containsKey(element.number)) {
          my_map[element.number][0] += element.duration;
          my_map[element.number][3] += 1;
        } else {
          my_map[element.number] = [
            element.duration,
            element.name,
            element.formattedNumber,
            1
          ];
        }
        return element.duration! + (previousValue as num);
      });
      final sortedValuesDesc = SplayTreeMap<String, dynamic>.from(my_map,
              (keys1, keys2) => my_map[keys2][0]!.compareTo(my_map[keys1][0]!));

      final sortedValuesDesc2 = SplayTreeMap<String, dynamic>.from(my_map,
              (keys1, keys2) => my_map[keys2][3]!.compareTo(my_map[keys1][3]!));

      var todayBest;
      var todayBest2;
      if (entry.length > 0) {
        todayBest = sortedValuesDesc.values.toList()[0][1];
        if (todayBest == null) {
          todayBest = sortedValuesDesc.values.toList()[0][2];
        }
      } else {
        todayBest = "";
      }
      var toHour;
      var toMin;
      var toSec;
      bool toIsHour = false;
      bool toIsMin = false;
      var bestTime = sortedValuesDesc.values.toList()[0][0];
      if (bestTime >= 3600) {
        toIsHour = true;
        toHour = (bestTime / 3600).toInt();
        bestTime = bestTime - toHour * 3600;
        toMin = (bestTime / 60).toInt();
        bestTime = bestTime - toMin * 60;
        toSec = bestTime;
      } else if (bestTime < 3600 && bestTime >= 60) {
        toIsMin = true;
        toMin = (bestTime / 60).toInt();
        bestTime = bestTime - toMin * 60;
        toSec = bestTime;
      } else {
        toSec = bestTime;
      }

      var hour;
      var min;
      var sec;
      bool isHour = false;
      bool isMin = false;

      if (rs >= 3600) {
        isHour = true;
        hour = (rs / 3600).toInt();
        rs = rs - hour * 3600;
        min = (rs / 60).toInt();
        rs = rs - min * 60;
        sec = rs;
      } else if (rs < 3600 && rs >= 60) {
        isMin = true;
        min = (rs / 60).toInt();
        rs = rs - min * 60;
        sec = rs;
      } else {
        sec = rs;
      }

      //return //Container(
      // alignment: Alignment.center,
      // child: AdWidget(ad: banner!,),
      // width: banner!.size.width.toDouble(),
      // height: banner!.size.height.toDouble(),
      //);

      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cl.getDate(_selectedDateRange.start),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              )),
                          Text("~",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              )),
                          Text(cl.getDate(_selectedDateRange.end),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   child: AdWidget(ad: banner!,),
                      //   width: banner!.size.width.toDouble(),
                      //   height: banner!.size.height.toDouble(),
                      // ),

                      const SizedBox(height: 10.0),
                      Nemo(
                          entry,
                          "오늘의 통화시간",
                          entry.isNotEmpty
                              ? (isHour
                              ? Text(
                              "${hour.toString()}시간 ${min.toString()}분 ${sec}초",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ))
                              : isMin
                              ? Text("${min.toString()}분 ${sec}초",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ))
                              : Text("${sec}초",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              )))
                              : Text('없음'),
                          Colors.deepOrangeAccent),
                      const SizedBox(height: 10.0),
                      Nemo(
                          entry,
                          "오늘의 통화건수",
                          entry.isNotEmpty
                              ? Text("${entry.length.toString()} 건",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ))
                              : Text('없음'),
                          Colors.green),
                      const SizedBox(height: 10.0),
                      Nemo(
                          entry,
                          "누구랑 가장 오래 통화했어?",
                          entry.isNotEmpty
                              ? (toIsHour
                              ? Text(
                              "${toHour.toString()}시간 ${toMin.toString()}분 ${toSec}초 with ${todayBest}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ))
                              : toIsMin
                              ? Text(
                              "${toMin.toString()}분 ${toSec}초 with ${todayBest}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ))
                              : Text("${toSec}초 with ${todayBest}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              )))
                              : Text('없음'),
                          Colors.blue),
                      const SizedBox(height: 10.0),
                      Nemo(
                          entry,
                          '누구랑 가장 여러번 통화했어?',
                          entry.isNotEmpty
                              ? Text(
                              "${sortedValuesDesc2.values.toList()[0][3]}통 with ${sortedValuesDesc2.values.toList()[0][1]}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ))
                              : Text('없음'),
                          Colors.orange),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(_selectedDateRange.toString()),
                      Nemo(
                        entry,
                        "오늘의 통화시간",
                        Text('없음',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Colors.deepOrangeAccent,
                      ),
                      const SizedBox(height: 10.0),
                      Nemo(
                        entry,
                        "오늘의 통화건수",
                        Text('없음',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Colors.green,
                      ),
                      const SizedBox(height: 10.0),
                      Nemo(
                        entry,
                        "누구랑 가장 오래 통화했어?",
                        Text('없음',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Colors.blue,
                      ),
                      const SizedBox(height: 10.0),
                      Nemo(
                        entry,
                        '누구랑 가장 여러번 통화했어?',
                        Text('없음',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  Nemo(Iterable<CallLogEntry> entry, titleName, result, color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              "${titleName}",
              style: GoogleFonts.gaegu(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      decoration: TextDecoration.underline)),
            ),
            trailing: Icon(
              Icons.how_to_vote,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            // child: Text("${entry.length.toString()} 건",
            child: result,
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
