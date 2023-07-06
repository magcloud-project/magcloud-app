import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/framework/state_store.dart';
import 'package:magcloud_app/core/model/daily_user.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/calendar_view/month_view.dart';
import 'package:magcloud_app/view/page/calendar_view/year_view.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_scope_data_state.dart';

import '../../view/page/calendar_view/calendar_base_view.dart';
import '../../view/page/calendar_view/daily_diary_view.dart';
import 'calendar_base_view_state.dart';

enum CalendarViewScope { YEAR, MONTH, DAILY }

class CalendarBaseViewModel extends BaseViewModel<CalendarBaseView,
    CalendarBaseViewModel, CalendarBaseViewState> {
  final DiaryService diaryService = inject<DiaryService>();
  final UserService userService = inject<UserService>();
  final OnlineService onlineService = inject<OnlineService>();

  bool forwardAction = false;
  bool animationStart = false;

  bool verticalForwardAction = false;
  bool verticalAnimationStart = false;

  bool isFriendBarOpen = StateStore.getBool("isFriendBarOpen", true);

  @override
  void dispose() {
    StateStore.setBool("isFriendBarOpen", isFriendBarOpen);
    StateStore.setInt("currentYear", state.currentYear);
    StateStore.setInt("currentMonth", state.currentMonth);
    StateStore.setInt("currentDay", state.currentDay);
  }

  void refreshPage() async {
    setupVerticalAnimation(state.scope == CalendarViewScope.YEAR);
    setStateAsync(() async {
      await setScope(CalendarViewScope.MONTH);
    });
  }

  void toggleFriendBar() {
    setState(() {
      isFriendBarOpen = !isFriendBarOpen;
    });
  }

  void toggleOnline() {
    setState(() {
      OnlineService.invokeOnlineToggle();
    });
  }

  bool isOnline() => onlineService.isOnlineMode();

  bool isMeSelected() => state.selectedUser?.userId == state.dailyMe?.userId;

  CalendarBaseViewModel()
      : super(
          CalendarBaseViewState(
            StateStore.getInt("currentYear") ?? DateParser.getCurrentYear(),
            StateStore.getInt("currentMonth") ?? DateParser.getCurrentMonth(),
            StateStore.getInt("currentDay") ?? DateParser.getCurrentDay(),
            CalendarViewScope.MONTH,
            CalendarMonthViewScopeData({}),
          ),
        );

  Future<void> setScope(CalendarViewScope scope) async {
    if (state.scope == CalendarViewScope.DAILY) {
      final scopeData = state.scopeData as CalendarDailyViewScopeData;
      final lastDiary = scopeData.currentDiary;
      diaryService.updateDiary(lastDiary, scopeData.diaryTextController.text);
    }
    state.scope = scope;
    switch (state.scope) {
      case CalendarViewScope.YEAR:
        final mood = await diaryService.getMonthlyMood(state.currentYear);
        setScopeData(CalendarYearViewScopeData(mood));
        break;
      case CalendarViewScope.MONTH:
        final mood = await diaryService.getDailyMood(
            state.currentYear, state.currentMonth);
        setScopeData(CalendarMonthViewScopeData(mood));
        break;
      case CalendarViewScope.DAILY:
        final diary = await diaryService.getDiary(
            state.currentYear, state.currentMonth, state.currentDay);
        final dailyScopeData = CalendarDailyViewScopeData(diary);
        setScopeData(dailyScopeData);
        dailyScopeData.focusNode.addListener(() {
          if (isFriendBarOpen) {
            toggleFriendBar();
          }
        });
        break;
    }
  }

  Future<void> setScopeData(CalendarScopeData data) async {
    if ((state.scope == CalendarViewScope.YEAR &&
            data is CalendarYearViewScopeData) ||
        (state.scope == CalendarViewScope.MONTH &&
            data is CalendarMonthViewScopeData) ||
        (state.scope == CalendarViewScope.DAILY &&
            data is CalendarDailyViewScopeData)) {
      state.scopeData = data;
    }
  }

  Widget Function() getRoutedWidgetBuilder() {
    switch (state.scope) {
      case CalendarViewScope.YEAR:
        return () => CalendarYearView();
      case CalendarViewScope.MONTH:
        return () => CalendarMonthView();
      case CalendarViewScope.DAILY:
        return () => CalendarDailyDiaryView();
    }
  }

  @override
  Future<void> initState() async {
    setStateAsync(() async {
      await setScope(state.scope);
      state.dailyMe = await userService.getDailyMe();
      state.selectedUser = state.dailyMe; //기본값은 나 선택 ㅇㅅㅇ
    });
    if (isOnline()) {
      setStateAsync(() async {
        state.dailyFriends = await userService.getDailyFriends();
      });
    }
  }

  Future<void> onTapFriendIcon(User user) async {
    await setStateAsync(() async {
      state.selectedUser = user;
    });
  }

  void setupAnimation(int delta) {
    forwardAction = delta > 0;
    animationStart = true;
  }

  void setupVerticalAnimation(bool forward) {
    verticalForwardAction = forward;
    verticalAnimationStart = true;
  }

  Future<void> changeDay(int delta) async {
    final now = DateTime.now();
    final afterDelta = DateTime(
        state.currentYear, state.currentMonth, state.currentDay + delta);
    if (afterDelta.isAfter(now)) {
      snackNoFuture();
      return;
    }
    setupAnimation(delta);
    setStateAsync(() async {
      state.currentYear = afterDelta.year;
      state.currentMonth = afterDelta.month;
      state.currentDay = afterDelta.day;
      await setScope(CalendarViewScope.DAILY);
    });
  }

  Future<void> changeMonth(int delta) async {
    if (state.scopeData is! CalendarMonthViewScopeData) return;

    final afterDelta = state.currentMonth + delta;
    int targetMonth = state.currentMonth;
    int targetYear = state.currentYear;
    if (afterDelta < 1) {
      targetMonth = 12;
      targetYear -= 1;
    } else if (afterDelta > 12) {
      targetMonth = 1;
      targetYear += 1;
    } else {
      targetMonth = afterDelta;
    }

    final currentYear = DateParser.getCurrentYear();
    final currentMonth = DateParser.getCurrentMonth();
    if ((targetYear == currentYear && targetMonth > currentMonth) ||
        targetYear > currentYear) {
      snackNoFuture();
      return;
    }
    setupAnimation(delta);

    setStateAsync(() async {
      state.currentYear = targetYear;
      state.currentMonth = targetMonth;
      await setScope(CalendarViewScope.MONTH);
    });
  }

  Future<void> changeYear(int delta) async {
    final afterDelta = state.currentYear + delta;
    if (afterDelta > DateParser.getCurrentYear()) {
      snackNoFuture();
      return;
    }
    setupAnimation(delta);
    setStateAsync(() async {
      state.currentYear = afterDelta;
      await setScope(CalendarViewScope.YEAR);
    });
  }

  Future<void> onTapMonthBox(int month) async {
    setupVerticalAnimation(true);
    setStateAsync(() async {
      state.currentMonth = month;
      await setScope(CalendarViewScope.MONTH);
    });
  }

  Future<void> onTapDayBox(int day) async {
    setupVerticalAnimation(true);
    setStateAsync(() async {
      state.currentDay = day;
      await setScope(CalendarViewScope.DAILY);
    });
  }

  Future<void> onTapYearTitle() async {
    //이럼 머야???
  }

  Future<void> onTapMonthTitle() async {
    setupVerticalAnimation(false);
    setStateAsync(() async {
      await setScope(CalendarViewScope.YEAR);
    });
  }

  Future<void> onTapDayTitle() async {
    setupVerticalAnimation(false);
    setStateAsync(() async {
      await setScope(CalendarViewScope.MONTH);
    });
  }

  void snackNoFuture() {
    SnackBarUtil.errorSnackBar(
        message: message("message_cannot_move_to_future"));
  }
}
