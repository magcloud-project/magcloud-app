import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/util/font.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/fadeable_switcher.dart';
import 'package:magcloud_app/view_model/setting_view/font_setting_view_model.dart';

import '../../component/base_settings_layout.dart';
import '../../component/touchableopacity.dart';
import '../../designsystem/base_color.dart';

class FontSettingView extends BaseView<FontSettingView, FontSettingViewModel,
    FontSettingViewState> {
  const FontSettingView({super.key});

  @override
  FontSettingViewModel initViewModel() => FontSettingViewModel();

  @override
  Widget render(BuildContext context, FontSettingViewModel action,
      FontSettingViewState state) {
    return Fadeable(
        child: BaseSettingLayout(
      key: Key(isKorea.toString()),
      title: message('menu_fonts'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.sp),
          Row(
            children: [
              SizedBox(width: 28.sp),
              Text(message('generic_selected_font'),
                  style:
                      TextStyle(color: BaseColor.warmGray600, fontSize: 16.sp))
            ],
          ),
          SizedBox(height: 10.sp),
          languages(action),
          Row(
            children: [
              SizedBox(width: 28.sp),
              Flexible(
                  child: Text(message('message_font_settings_info'),
                      style: TextStyle(
                          color: BaseColor.warmGray500, fontSize: 12.sp))),
              SizedBox(width: 28.sp),
            ],
          ),
          SizedBox(height: 24.sp),
          Row(
            children: [
              SizedBox(width: 24.sp),
              Text(message('generic_font_size'),
                  style:
                      TextStyle(color: BaseColor.warmGray600, fontSize: 16.sp))
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10.sp),
              Expanded(child: fontSizeBox(action)),
              SizedBox(width: 10.sp),
            ],
          ),
          SizedBox(height: 15.sp),
          Divider(thickness: 10.sp, color: BaseColor.warmGray100),
          SizedBox(height: 10.sp),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: TextField(
              controller: action.controller,
              style: TextStyle(
                fontFamily: diaryFont,
                fontSize: state.fontSize,
              ),
              //controller: scopeData.diaryTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )),
        ],
      ),
    ));
  }

  Widget languages(FontSettingViewModel action) {
    final gapBetweenBadge = 11.sp;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          children: [
            fontBox(action, 'KyoboHandWriting', '교보손글씨 2021 성지영'),
            SizedBox(height: gapBetweenBadge),
            fontBox(action, 'KyoboHandWriting2019', '교보손글씨 2019'),
            SizedBox(height: gapBetweenBadge),
            fontBox(action, 'GmarketSans', 'Gmarket Sans'),
            SizedBox(height: gapBetweenBadge),
          ],
        ));
  }

  Widget fontBox(
      FontSettingViewModel action, String fontName, String fontDisplayName) {
    final isSelected = diaryFont == fontName;
    return TouchableOpacity(
        onTap: () => action.onTapFont(fontName),
        child: Container(
          decoration: BoxDecoration(
              color: BaseColor.warmGray50,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(fontDisplayName,
                      style: TextStyle(
                          color: BaseColor.warmGray600, fontSize: 16.sp)),
                  Text(message('message_font_example_text'),
                      style: TextStyle(
                          color: BaseColor.warmGray500,
                          fontSize: 14.sp,
                          fontFamily: fontName))
                ]),
                Icon(Icons.check,
                    size: 20.sp,
                    color: isSelected
                        ? BaseColor.warmGray700
                        : BaseColor.warmGray300),
              ],
            ),
          ),
        ));
  }

  Widget fontSizeBox(FontSettingViewModel action) {
    return Slider(
      value: action.state.fontSize,
      onChanged: action.onMoveSlider,
      min: fontSizeMin,
      max: fontSizeMax,
      activeColor: BaseColor.warmGray500,
      inactiveColor: BaseColor.warmGray300,
      divisions: 10,
    );
  }
}