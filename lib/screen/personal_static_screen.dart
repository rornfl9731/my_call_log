import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:my_call_log/util/utils.dart';

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
              if (snapshot.connectionState == ConnectionState.done){

                if(snapshot.hasData){
                  Iterable<CallLogEntry>? entries = snapshot.data;
                  PersonalLogs(entries!);

                  return Center(
                    child: Text(snapshot.data!.length.toString()),
                  );
                }else{
                  return Text("없음");
                }

              }else{
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
