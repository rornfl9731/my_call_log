import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      helpText: "날짜를 선택하세요",
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Home Screen 2', style: TextStyle(color: Colors.black)),
        toolbarHeight: 60,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "asd",
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
                      child: Text("asd"),
                    ),

                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}
