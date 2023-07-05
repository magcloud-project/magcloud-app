import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';

@singleton
class OnlineService {
  final OpenAPI openAPI = inject<OpenAPI>();
  bool? _online;
  late Timer timer;

  int offlineCount = 0;
  OnlineService() {
    timer = Timer.periodic(const Duration(seconds: 1), healthCheck);
  }

  void healthCheck(Timer timer) async {
    try{
      await openAPI.onlineCheck();
      _handleOnline();
    } catch(e){
      _handleOffline();
    }
  }

  void _handleOnline() {
    if(_online == null) {
      _online = true;
      return;
    }
    if(_online == false) {
      _online = true;
      SnackBarUtil.infoSnackBar(message: message("message_online_mode_activated"));
    }
  }

  void _handleOffline() {
    if(_online == null) {
      _online = false;
      return;
    }
    if(_online == true) {
      offlineCount++;
      if(offlineCount > 3) {
        _online = false;
        offlineCount = 0;
        SnackBarUtil.infoSnackBar(message: message("message_offline_mode_activated"));
      }
    }
  }

  bool isOnlineMode() => _online ?? true;
}