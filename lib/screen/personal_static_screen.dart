import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:my_call_log/util/utils.dart';
import 'package:pie_chart/pie_chart.dart';
import '../components/callLogs.dart';

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
      body: Container(
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
                  "수신": 3.0,
                  "발신": 28.0,
                };

                return Center(
                  child: PieChart(
                    dataMap: dataMap,
                    legendOptions: LegendOptions(legendPosition: LegendPosition.bottom),
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
    );
  }

  String getName() {
    return '';
  }
}
