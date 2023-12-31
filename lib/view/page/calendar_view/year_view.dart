import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_scope_data_state.dart';

import '../../../core/util/i18n.dart';
import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import 'calendar_base_view.dart';

class CalendarYearView extends BaseChildView<CalendarBaseView,
    CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarYearView({super.key});

  double getAnimationOffset() {
    if (action.animationStart) {
      action.animationStart = false;
      return action.forwardAction ? -0.8 : 0.8;
    } else {
      return action.forwardAction ? 0.8 : -0.8;
    }
  }

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action,
      CalendarBaseViewState state) {
    final scopeData = state.scopeData as CalendarYearViewScopeData;
    final fullWidth = MediaQuery.of(context).size.width;
    final boxWidth = (fullWidth - 100.sp) / 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        yearViewTopBar(context, action, state),
        SizedBox(height: 20.sp),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(getAnimationOffset(), 0.0),
                    // adjust the position as you need
                    end: const Offset(0.0, 0.0),
                  ).animate(animation),
                  child: child);
            },
            child: Column(
              key: Key(state.currentDate.year.toString()),
              children: [
                for (int j = 0; j < 3; j++) ...[
                  Row(
                    children: [
                      SizedBox(width: 20.sp),
                      for (int x = (j * 4) + 1; x <= (j * 4) + 4; x++) ...[
                        createMonthBox(context, action, month: x, boxWidth: boxWidth),
                        SizedBox(width: 20.sp),
                      ],
                    ],
                  ),
                  SizedBox(height: 20.sp),
                ]
              ],
            )),
      ],
    );
  }

  Widget yearViewTopBar(
      BuildContext context,
      CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(
              child: Text(
            '${state.currentDate.year}${message("generic_year")}',
            style: TextStyle(
                color: context.theme.colorScheme.secondary,
                fontSize: 16.sp,
                fontFamily: 'GmarketSans'),
          )),
          Row(
            children: [
              TouchableOpacity(
                  onTap: () => action.changeYear(-1),
                  child: const Icon(BaseIcon.arrowLeft)),
              TouchableOpacity(
                  onTap: () => action.changeYear(1),
                  child: const Icon(BaseIcon.arrowRight))
            ],
          ),
        ],
      ),
    );
  }

  Widget createMonthBox(
      BuildContext context,
      CalendarBaseViewModel action,
      {required int month, required double boxWidth}) {
    final currentYear = DateParser.getCurrentYear();
    final isInvisible = currentYear < action.state.currentDate.year ||
        (currentYear == action.state.currentDate.year &&
            DateParser.getCurrentMonth() < month);
    final scopeData = action.state.scopeData as CalendarYearViewScopeData;
    final monthlyMood = scopeData.monthlyMood[month];
    return TouchableOpacity(
        onTap: () => action.onTapMonthBox(month),
        child: Container(
          width: boxWidth,
          height: boxWidth,
          decoration: BoxDecoration(
            border: Border.all(color: BaseColor.warmGray300),
            borderRadius: BorderRadius.circular(15),
            color: monthlyMood?.moodColor,
          ),
          child: Center(
            child: Text(
              DateParser.formatLocaleMonth(month),
              style: TextStyle(
                  color: isInvisible
                      ? context.theme.colorScheme.outline
                      : (monthlyMood != null ? context.theme.colorScheme.secondaryContainer : context.theme.colorScheme.secondary),

                  fontSize: 18.sp,
                  fontFamily: 'GmarketSans'),
            ),
          ),
        ));
  }
}
