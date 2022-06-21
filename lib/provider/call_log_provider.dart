import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:my_call_log/components/callLogs.dart';
import 'package:my_call_log/repository/call_log_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class CallLogProvider extends ChangeNotifier {
  Iterable<CallLogEntry> _logs = [];
  Iterable<CallLogEntry> personal_logs = [];
  CallLogs cl = CallLogs();
  Iterable<CallLogEntry> get getLogs => _logs;

  loadLogs() async {
    _logs = await cl.getCallLogs();
    notifyListeners();
  }

  loadPersonalLogs(number) async {
    personal_logs = await cl.getPersonal(number);
    notifyListeners();
  }

  clearLogs() async {
    _logs = [];
  }

  DateTimeRange _dateRange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));

  DateTimeRange setDateRange(DateTimeRange dateRange) {
    _dateRange = dateRange;
    notifyListeners();
    return _dateRange;
  }

  DateTimeRange get getDateRange => _dateRange;

}

