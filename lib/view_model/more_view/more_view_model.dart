import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/dialog/confirm_dialog.dart';
import 'package:magcloud_app/view_model/more_view/more_view_state.dart';

import '../../core/util/i18n.dart';
import '../../core/util/snack_bar_util.dart';
import '../../view/page/more_view.dart';
import '../../view/page/profile_view.dart';

class MoreViewModel
    extends BaseViewModel<MoreView, MoreViewModel, MoreViewState> {
  MoreViewModel() : super(MoreViewState());

  @override
  Future<void> initState() async {
    state.me = await inject<UserService>().getMe();
  }

  @override
  void onReloaded() {
    setStateAsync(() async {
      await initState();
    });
  }

  Future<void> onTapMyProfiles() async {
    if (state.me == null) return;
    route() => ProfileView(state.me!, true, false);
    await GlobalRoute.rightToLeftRouteToDynamic(route);
    onReloaded();
  }

  Future<void> onTapNotification() async {
    if (!inject<OnlineService>().isOnlineMode()) {
      SnackBarUtil.errorSnackBar(
          message: message('message_offline_cannot_use_that'));
      return;
    }
    GlobalRoute.rightToLeftRouteTo('/settings/notification');
  }

  Future<void> onTapFonts() async {
    setStateAsync(() async {
      await GlobalRoute.rightToLeftRouteTo('/settings/font');
    });
  }

  Future<void> onTapLanguage() async {
    setStateAsync(() async {
      await GlobalRoute.rightToLeftRouteTo('/settings/language');
    });
  }

  Future<void> onTapDarkMode() async {
    setStateAsync(() async {
      await GlobalRoute.rightToLeftRouteTo('/settings/dark-mode');
    });
  }

  Future<void> onTapNotice() async {
    await GlobalRoute.noticePage();
  }

  Future<void> onTapPrivacy() async {
    await GlobalRoute.privacyPage();
  }

  Future<void> onTapContact() async {
    await GlobalRoute.contact();
  }


  Future<void> onTapAppInfo() async {
    GlobalRoute.rightToLeftRouteTo('/settings/app-info');
  }

  Future<void> logout() async {
    final result = await confirmDialog(message('message_logout_dialog_title'),
        message('message_logout_dialog_subtitle'),
        confirmText: message('menu_logout'));
    if (result != true) return;

    await inject<AuthService>().logout(true);
    await GlobalRoute.clearAllAndFadeRoute('/login');
  }

  Future<void> leave() async {
    final result = await confirmDialog(message('message_leave_dialog_title'),
        message('message_leave_dialog_description'),
        confirmText: message('generic_leave'));
    if (result != true) return;

    await inject<OpenAPI>().leaveMagCloud();
    await inject<AuthService>().logout(true);
    await GlobalRoute.clearAllAndFadeRoute('/login');
  }
}
