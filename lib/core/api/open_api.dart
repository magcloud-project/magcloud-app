import 'package:dio/dio.dart';
import 'package:magcloud_app/core/api/dto/auth_request.dart';
import 'package:magcloud_app/core/api/dto/auth_response.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_integrity_response.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_update_request.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_accept_request.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_request.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_response.dart';
import 'package:magcloud_app/core/api/dto/user_response.dart';
import 'package:retrofit/http.dart';

import 'dto/api_response.dart';
import 'dto/auth_refresh_request.dart';
import 'dto/diary/diary_request.dart';
import 'dto/diary/diary_response.dart';

part 'open_api.g.dart';

@RestApi()
abstract class OpenAPI {
  factory OpenAPI(Dio dio, {String baseUrl}) = _OpenAPI;

  @GET('/health-check')
  Future<dynamic> onlineCheck();

  @POST('/v1/auth')
  Future<AuthResponse> authenticate(@Body() AuthRequest request);

  @POST('/v1/auth/refresh')
  Future<AuthResponse> refresh(@Body() AuthRefreshRequest request);

  @GET('/v1/users/me')
  Future<UserResponse> getMyProfile();

  @GET('/v1/users/friends')
  Future<List<FriendResponse>> getFriends();

  @POST('/v1/users/friends/requests')
  Future<APIResponse> requestFriend(@Body() FriendRequest request);

  @POST('/v1/users/friends/requests/accept')
  Future<APIResponse> acceptFriendRequest(@Body() FriendAcceptRequest request);

  @POST('/v1/users/friends/requests/deny')
  Future<APIResponse> denyFriendRequest(@Body() FriendAcceptRequest request);

  @POST('/v1/users/friends/break')
  Future<APIResponse> breakFriend(@Body() FriendAcceptRequest request);

  @GET('/v1/diaries')
  Future<DiaryResponse> getDiaryByDate(@Query("date") String date);

  @GET('/v1/diaries/{diaryId}/integrity')
  Future<DiaryIntegrityResponse> getDiaryIntegrity(@Path('diaryId') String diaryId);

  @GET('/v1/diaries/{diaryId}')
  Future<DiaryResponse> getDiary(@Path("diaryId") String diaryId);

  @POST('/v1/diaries')
  Future<DiaryResponse> createDiary(@Body() DiaryRequest request);

  @PATCH('/v1/diaries/{diaryId}')
  Future<DiaryResponse> updateDiary(@Path('diaryId') String diaryId, @Body() DiaryUpdateRequest request);

  @GET('/v1/users/{friendId}/diaries')
  Future<DiaryResponse> getFriendDiaryByDate(@Path("friendId") String friendId, @Query("date") String date);
}
