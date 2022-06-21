import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_call_log/components/callLogs.dart';

CallLogs cl = new CallLogs();

Ranking(Iterable<CallLogEntry> entry) {
  if (entry.isNotEmpty) {
    List<CallLogEntry> list = entry.toList();
    Map map = {};
    for (int i = 0; i < list.length; i++) {
      if (map[list[i].number] == null) {
        map[list[i].number] = 1;
      } else {
        map[list[i].number] += 1;
      }
    }
    List<MapEntry> list2 = map.entries.toList();
    list2.sort((a, b) => b.value.compareTo(a.value));
    return list2[0].key;
  }
}

//초를 -> 시간 분 초로 환산해주는 함수
String TimeCalculate(callTime){
  var toHour;
  var toMin;
  var toSec;
  bool toIsHour = false;
  bool toIsMin = false;
  String answer;
  var bestTime = callTime;
  if (bestTime >= 3600) {
    toIsHour = true;
    toHour = (bestTime / 3600).toInt();
    bestTime = bestTime - toHour * 3600;
    toMin = (bestTime / 60).toInt();
    bestTime = bestTime - toMin * 60;
    toSec = bestTime;
    answer = "${toHour}시간 ${toMin}분 ${toSec}초";
    return answer;
  } else if (bestTime < 3600 && bestTime >= 60) {
    toIsMin = true;
    toMin = (bestTime / 60).toInt();
    bestTime = bestTime - toMin * 60;
    toSec = bestTime;
    answer = "${toMin}분 ${toSec}초";
    return answer;
  } else {
    toSec = bestTime;
    answer = "${toSec}초";
    return answer;
  }



}



//요일 구하는 함수
String getDayOfWeek(timestamp){
  String dayOfWeek = cl.formatWeek(new DateTime.fromMillisecondsSinceEpoch(
      timestamp!)).split(" ").last;

  return dayOfWeek;
}

// 한 사람과의 기록 추출 함수
// 1. 통화 시간
// 2. 통화 건수
// 3. 요일별 건수 및 시간
// 4. 수신 / 발신 건수 및 시간
// 5. 시간대별 건수 및 시간

List PersonalLogs(Iterable<CallLogEntry> entry) {
  var weekDays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
  int callCount = entry.length; // 건수
  var callTime = entry.fold(0, (previousValue, element){
      return element.duration! + (previousValue as num);
});
  String callTimeKo = TimeCalculate(callTime); // 통화 시간

  Map inAndOut = {"수신" : [0,"0",0], "발신" : [0,"0",0],};
  Map inAndOutRow = {"수신" : [0,0], "발신" : [0,0],};

  //요일별  0: 통화수  1 : 통화시간
  Map byWeekday = {"Mon":[0,"0",0],"Tue":[0,"0",0],"Wed":[0,"0",0],"Thu":[0,"0",0],"Fri":[0,"0",0],"Sat":[0,"0",0],"Sun":[0,"0",0]};
  Map byWeekdayRaw = {"Mon":[0,0],"Tue":[0,0],"Wed":[0,0],"Thu":[0,0],"Fri":[0,0],"Sat":[0,0],"Sun":[0,0]};
  List timeZone = [6,12,18,22,24];
  //통화 시작 시간 기준.
  Map byTimeZone = {"새벽":[0,"0",0],"오전":[0,"0",0],"오후":[0,"0",0],"저녁":[0,"0",0],"밤":[0,"0",0],};
  Map byTimeZoneRow = {"새벽":[0,0],"오전":[0,0],"오후":[0,0],"저녁":[0,0],"밤":[0,0],};


  // 스트링으로 저장해야해서 변환을 계속 하는 것 때문에 길어짐.
  entry.forEach((element) {
    //요일별 계산
    String dayOfWeek = getDayOfWeek(element.timestamp);
    byWeekdayRaw[dayOfWeek][0] += 1;
    byWeekdayRaw[dayOfWeek][1] += element.duration;


    byWeekday[dayOfWeek][0] += 1;
    // int a =int.parse(byWeekday[dayOfWeek][0]);
    // a += 1;
    // byWeekday[dayOfWeek][0] = "$a";

    int b = int.parse(byWeekday[dayOfWeek][1]);
    b += element.duration!;
    byWeekday[dayOfWeek][1] = "$b";

    //수신발신별 계산
    if(element.callType == CallType.incoming){
      inAndOut['수신'][0] += 1;
      int a = int.parse(inAndOut['수신'][1]);
       a += element.duration!;
      inAndOut['수신'][1] = '$a';

      inAndOutRow['수신'][0] += 1;
      inAndOutRow['수신'][1] += element.duration;

    }else if(element.callType == CallType.outgoing){
      inAndOut['발신'][0] += 1;
      int a = int.parse(inAndOut['발신'][1]);
      a += element.duration!;
      inAndOut['발신'][1] = '$a';

      inAndOutRow['발신'][0] += 1;
      inAndOutRow['발신'][1] += element.duration;
    }

    //시간대별 계산
    // if(cl.getHour(new DateTime.fromMillisecondsSinceEpoch(element.timestamp!))==)
    int time = int.parse(cl.getHour(new DateTime.fromMillisecondsSinceEpoch(element.timestamp!)));
    //6:00 ~ 11:59
    if(5<time && time<12){
      byTimeZoneRow['오전'][0] += 1;
      byTimeZoneRow['오전'][1] += element.duration;

      byTimeZone['오전'][0] +=1;
      int a = int.parse(byTimeZone['오전'][1]);
      a += element.duration!;
      byTimeZone['오전'][1] = "${a}";

    }
    //12:00 ~ 17:59
    else if(11<time && time<18) {
      byTimeZoneRow['오후'][0] += 1;
      byTimeZoneRow['오후'][1] += element.duration;

      byTimeZone['오후'][0] +=1;
      int a = int.parse(byTimeZone['오후'][1]);
      a += element.duration!;
      byTimeZone['오후'][1] = "${a}";

    }
    //18:00 ~ 21:59
    else if(17<time && time<22){
      byTimeZoneRow['저녁'][0] += 1;
      byTimeZoneRow['저녁'][1] += element.duration;

      byTimeZone['저녁'][0] +=1;
      int a = int.parse(byTimeZone['저녁'][1]);
      a += element.duration!;
      byTimeZone['저녁'][1] = "${a}";

    }
    //22:00 ~ 23:59
    else if(21<time && time<24){
      byTimeZoneRow['밤'][0] += 1;
      byTimeZoneRow['밤'][1] += element.duration;

      byTimeZone['밤'][0] +=1;
      int a = int.parse(byTimeZone['밤'][1]);
      a += element.duration!;
      byTimeZone['밤'][1] = "${a}";

    }
    else{
      byTimeZoneRow['새벽'][0] += 1;
      byTimeZoneRow['새벽'][1] += element.duration;

      byTimeZone['새벽'][0] +=1;
      int a = int.parse(byTimeZone['새벽'][1]);
      a += element.duration!;
      byTimeZone['새벽'][1] = "${a}";

    }

  });

  byWeekday.forEach((key, value) {
    value[2] = int.parse(value[1]);
    value[1] = TimeCalculate(int.parse(value[1]));
  });

  inAndOut.forEach((key, value) {
    value[2] = int.parse(value[1]);
    value[1] = TimeCalculate(int.parse(value[1]));

  });

  byTimeZone.forEach((key, value) {
    value[2] = int.parse(value[1]);
    value[1] = TimeCalculate(int.parse(value[1]));
  });


  print(byWeekday);

  print(inAndOut);
  print(byTimeZone);




  List k = [callCount,callTimeKo,byWeekday,inAndOut,byTimeZone];

  return k;


}
