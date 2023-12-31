// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      diaryId: json['diaryId'] as String,
      mood: json['mood'] as String,
      ymd: json['ymd'] as String,
      content: json['content'] as String,
      isLiked: json['isLiked'] as bool,
      likeCount: json['likeCount'] as int,
      createdAtTs: json['createdAtTs'] as int,
      imageUrl: json['imageUrl'] as String?,
      commentCount: json['commentCount'] as int,
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'profileImageUrl': instance.profileImageUrl,
      'diaryId': instance.diaryId,
      'mood': instance.mood,
      'ymd': instance.ymd,
      'content': instance.content,
      'isLiked': instance.isLiked,
      'likeCount': instance.likeCount,
      'imageUrl': instance.imageUrl,
      'createdAtTs': instance.createdAtTs,
      'commentCount': instance.commentCount,
    };
