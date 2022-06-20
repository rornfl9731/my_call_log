import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

Ranking(Iterable<CallLogEntry> entry){
  if(entry.isNotEmpty){
    List<CallLogEntry> list = entry.toList();
    Map map = {};
    for(int i = 0; i < list.length; i++){
      if(map[list[i].number] == null){
        map[list[i].number] = 1;
      }else{
        map[list[i].number] += 1;
      }
    }
    List<MapEntry> list2 = map.entries.toList();
    list2.sort((a, b) => b.value.compareTo(a.value));
    return list2[0].key;


  }




}