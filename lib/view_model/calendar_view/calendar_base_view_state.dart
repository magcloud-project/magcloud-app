import 'package:magcloud_app/core/model/daily_user.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_base_view_model.dart';

import '../../core/model/user.dart';
import 'calendar_scope_data_state.dart';

class CalendarBaseViewState {
  // int currentYear;
  // int currentMonth;
  // int currentDay;
  DateTime currentDate;
  CalendarViewScope scope;
  late CalendarScopeData scopeData;
  DailyUser? dailyMe;
  User? selectedUser;
  List<DailyUser> dailyFriends = List.empty();

  CalendarBaseViewState(this.currentDate, this.scope) {
    switch (scope) {
      case CalendarViewScope.MONTH:
        scopeData = CalendarMonthViewScopeData.mock();
        break;
      case CalendarViewScope.YEAR:
        scopeData = CalendarYearViewScopeData.mock();
        break;
      case CalendarViewScope.DAILY:
        scopeData = CalendarDailyViewScopeData.mock();
        break;
    }
  }

  List<List<int>> getMonthGrid() {
    //바깥쪽 리스트 -> 주
    //안쪽 리스트 -> 일
    final weekList =
        List.generate(6, (index) => List.generate(7, (index) => -1));
    final lastDay =
        DateParser.getLastDayOfMonth(currentDate.year, currentDate.month);
    final now = DateTime.now();
    var currentWeekPointer = 0;

    final monthlyFirstDayOfWeek = DateParser.getFirstDayOfWeekOfMonth(
        currentDate.year, currentDate.month);
    var currentDayOfWeek =
        monthlyFirstDayOfWeek == 7 ? 1 : monthlyFirstDayOfWeek + 1;
    for (int day = 1; day <= lastDay; day++) {
      weekList[currentWeekPointer][currentDayOfWeek - 1] =
          DateTime(currentDate.year, currentDate.month, day).isAfter(now)
              ? -1 * day
              : day;
      if (currentDayOfWeek == 7) {
        currentDayOfWeek = 1;
        currentWeekPointer++;
      } else {
        currentDayOfWeek += 1;
      }
    }
    return weekList;
  }
}
