import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

import '../components/callLogs.dart';

class PhonelogsScreen extends StatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen>
    with WidgetsBindingObserver {
  //Iterable<CallLogEntry> entries;
  CallLogs cl = CallLogs();
  late Future<Iterable<CallLogEntry>> logs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getCallLogs();
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
        logs = cl.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '전화 기록',
          style:
              TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold)),

        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          //TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number", contentPadding: EdgeInsets.all(10), suffixIcon: IconButton(icon: Icon(Icons.phone), onPressed: (){print("pressed");})),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),
          FutureBuilder<Iterable<CallLogEntry>>(
              future: logs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Iterable<CallLogEntry>? entries = snapshot.data;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        controller: _scrollController,
                        thickness: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                          child: ListView.builder(

                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              //print(cl.getDate(new DateTime.fromMillisecondsSinceEpoch(entries!.elementAt(index).timestamp!)));
                              final aa = cl.getDate(
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      entries!.elementAt(index).timestamp!));

                              if (index == 0) {
                                return Column(
                                  children: [
                                    Text(
                                      aa.toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                    GestureDetector(
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.black, width: 3),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: ListTile(
                                          leading: cl.getAvator(
                                              entries.elementAt(index).callType!),
                                          title: cl
                                              .getTitle(entries.elementAt(index)),
                                          subtitle: Text(
                                            cl.formatDate(new DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                    entries
                                                        .elementAt(index)
                                                        .timestamp!)) +
                                                "\n" +
                                                cl.getTime(entries
                                                    .elementAt(index)
                                                    .duration!),
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          isThreeLine: true,
                                          trailing: IconButton(
                                              icon: Icon(Icons.phone),
                                              color: Colors.green,
                                              onPressed: () {
                                                //cl.call(entries.elementAt(index).number!);
                                              }),
                                        ),
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            context: context,
                                            builder: (builder) =>
                                                buildBottomSheet(entries, index));
                                      },
                                    ),
                                  ],
                                );
                              } else if (aa ==
                                  cl.getDate(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          entries
                                              .elementAt(index - 1)
                                              .timestamp!))) {
                                return GestureDetector(
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black, width: 3),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    child: ListTile(
                                      leading: cl.getAvator(
                                          entries.elementAt(index).callType!),
                                      title:
                                          cl.getTitle(entries.elementAt(index)),
                                      subtitle: Text(
                                        cl.formatDate(new DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                entries
                                                    .elementAt(index)
                                                    .timestamp!)) +
                                            "\n" +
                                            cl.getTime(entries
                                                .elementAt(index)
                                                .duration!),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      isThreeLine: true,
                                      trailing: IconButton(
                                          icon: Icon(Icons.phone),
                                          color: Colors.green,
                                          onPressed: () {
                                            //cl.call(entries.elementAt(index).number!);
                                          }),
                                    ),
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        context: context,
                                        builder: (builder) =>
                                            buildBottomSheet(entries, index));
                                  },
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      aa.toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                    GestureDetector(
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.black, width: 3),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: ListTile(
                                          leading: cl.getAvator(
                                              entries.elementAt(index).callType!),
                                          title: cl
                                              .getTitle(entries.elementAt(index)),
                                          subtitle: Text(
                                            cl.formatDate(new DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                    entries
                                                        .elementAt(index)
                                                        .timestamp!)) +
                                                "\n" +
                                                cl.getTime(entries
                                                    .elementAt(index)
                                                    .duration!),
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          isThreeLine: true,
                                          trailing: IconButton(
                                              icon: Icon(Icons.phone),
                                              color: Colors.green,
                                              onPressed: () {
                                                //cl.call(entries.elementAt(index).number!);
                                              }),
                                        ),
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            context: context,
                                            builder: (builder) =>
                                                buildBottomSheet(entries, index));
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                            itemCount: entries!.length,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }

  BottomSheet buildBottomSheet(Iterable<CallLogEntry> entries, int index) {
    Future<Iterable<CallLogEntry>> number_logs;
    number_logs = cl.getJW(entries.elementAt(index).number!);
    //number_logs = logs.then((value) => value);

    return BottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        onClosing: () {},
        builder: (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: FutureBuilder(
                  future: number_logs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Iterable<CallLogEntry> entries1 =
                          snapshot.data as Iterable<CallLogEntry>;

                      return Column(
                        children: [
                          Text(
                            "${entries.elementAt(index).name == null || entries.elementAt(index).name == "" ? entries.elementAt(index).formattedNumber : entries.elementAt(index).name} ${entries1.length}통",
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: entries1.length,
                                itemBuilder: (context, index2) {
                                  return ListTile(
                                    title: Text(
                                      cl.formatDate(new DateTime
                                              .fromMillisecondsSinceEpoch(
                                          entries1
                                              .elementAt(index2)
                                              .timestamp!)),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      cl.getTime(
                                          entries1.elementAt(index2).duration!),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }),
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                    // if (snapshot.connectionState == ConnectionState.done) {
                    // Iterable<CallLogEntry>? entries = snapshot.data;
                  }
                  //
                  ),
            )));
  }
}
