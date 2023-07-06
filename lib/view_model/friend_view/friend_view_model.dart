import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/view/page/friend_view.dart';

import 'friend_view_state.dart';

class FriendViewModel
    extends BaseViewModel<FriendView, FriendViewModel, FriendViewState> {
  FriendViewModel() : super(FriendViewState());

  final TextEditingController searchController = TextEditingController();

  @override
  Future<void> initState() async {}
}
