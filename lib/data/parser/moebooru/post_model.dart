import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.creatorId,
    this.approverId,
    required this.author,
    required this.change,
    required this.source,
    required this.score,
    required this.md5,
    required this.fileSize,
    required this.fileExt,
    required this.fileUrl,
    required this.isShownInIndex,
    required this.previewUrl,
    required this.previewWidth,
    required this.previewHeight,
    required this.actualPreviewWidth,
    required this.actualPreviewHeight,
    required this.sampleUrl,
    required this.sampleWidth,
    required this.sampleHeight,
    required this.sampleFileSize,
    required this.jpegUrl,
    required this.jpegWidth,
    required this.jpegHeight,
    required this.jpegFileSize,
    required this.rating,
    required this.isRatingLocked,
    required this.hasChildren,
    this.parentId,
    required this.status,
    required this.isPending,
    required this.width,
    required this.height,
    required this.isHeld,
    required this.framesPendingString,
    required this.framesPending,
    required this.framesString,
    required this.frames,
    required this.isNoteLocked,
    required this.lastNotedAt,
    required this.lastCommentedAt,
    this.flagDetail,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? framesPending =
        jsonRes['frames_pending'] is List ? <Object>[] : null;
    if (framesPending != null) {
      for (final dynamic item in jsonRes['frames_pending']!) {
        if (item != null) {
          tryCatch(() {
            framesPending.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<Object>? frames = jsonRes['frames'] is List ? <Object>[] : null;
    if (frames != null) {
      for (final dynamic item in jsonRes['frames']!) {
        if (item != null) {
          tryCatch(() {
            frames.add(asT<Object>(item)!);
          });
        }
      }
    }
    return Root(
      id: asT<int>(jsonRes['id'])!,
      tags: asT<String>(jsonRes['tags'])!,
      createdAt: asT<int>(jsonRes['created_at'])!,
      updatedAt: asT<int>(jsonRes['updated_at'])!,
      creatorId: asT<int>(jsonRes['creator_id'])!,
      approverId: asT<Object?>(jsonRes['approver_id']),
      author: asT<String>(jsonRes['author'])!,
      change: asT<int>(jsonRes['change'])!,
      source: asT<String>(jsonRes['source'])!,
      score: asT<int>(jsonRes['score'])!,
      md5: asT<String>(jsonRes['md5'])!,
      fileSize: asT<int>(jsonRes['file_size'])!,
      fileExt: asT<String>(jsonRes['file_ext'])!,
      fileUrl: asT<String>(jsonRes['file_url'])!,
      isShownInIndex: asT<bool>(jsonRes['is_shown_in_index'])!,
      previewUrl: asT<String>(jsonRes['preview_url'])!,
      previewWidth: asT<int>(jsonRes['preview_width'])!,
      previewHeight: asT<int>(jsonRes['preview_height'])!,
      actualPreviewWidth: asT<int>(jsonRes['actual_preview_width'])!,
      actualPreviewHeight: asT<int>(jsonRes['actual_preview_height'])!,
      sampleUrl: asT<String>(jsonRes['sample_url'])!,
      sampleWidth: asT<int>(jsonRes['sample_width'])!,
      sampleHeight: asT<int>(jsonRes['sample_height'])!,
      sampleFileSize: asT<int>(jsonRes['sample_file_size'])!,
      jpegUrl: asT<String>(jsonRes['jpeg_url'])!,
      jpegWidth: asT<int>(jsonRes['jpeg_width'])!,
      jpegHeight: asT<int>(jsonRes['jpeg_height'])!,
      jpegFileSize: asT<int>(jsonRes['jpeg_file_size'])!,
      rating: asT<String>(jsonRes['rating'])!,
      isRatingLocked: asT<bool>(jsonRes['is_rating_locked'])!,
      hasChildren: asT<bool>(jsonRes['has_children'])!,
      parentId: asT<int?>(jsonRes['parent_id']),
      status: asT<String>(jsonRes['status'])!,
      isPending: asT<bool>(jsonRes['is_pending'])!,
      width: asT<int>(jsonRes['width'])!,
      height: asT<int>(jsonRes['height'])!,
      isHeld: asT<bool>(jsonRes['is_held'])!,
      framesPendingString: asT<String>(jsonRes['frames_pending_string'])!,
      framesPending: framesPending!,
      framesString: asT<String>(jsonRes['frames_string'])!,
      frames: frames!,
      isNoteLocked: asT<bool>(jsonRes['is_note_locked'])!,
      lastNotedAt: asT<int>(jsonRes['last_noted_at'])!,
      lastCommentedAt: asT<int>(jsonRes['last_commented_at'])!,
      flagDetail: jsonRes['flag_detail'] == null
          ? null
          : FlagDetail.fromJson(
              asT<Map<String, dynamic>>(jsonRes['flag_detail'])!),
    );
  }

  int id;
  String tags;
  int createdAt;
  int updatedAt;
  int creatorId;
  Object? approverId;
  String author;
  int change;
  String source;
  int score;
  String md5;
  int fileSize;
  String fileExt;
  String fileUrl;
  bool isShownInIndex;
  String previewUrl;
  int previewWidth;
  int previewHeight;
  int actualPreviewWidth;
  int actualPreviewHeight;
  String sampleUrl;
  int sampleWidth;
  int sampleHeight;
  int sampleFileSize;
  String jpegUrl;
  int jpegWidth;
  int jpegHeight;
  int jpegFileSize;
  String rating;
  bool isRatingLocked;
  bool hasChildren;
  int? parentId;
  String status;
  bool isPending;
  int width;
  int height;
  bool isHeld;
  String framesPendingString;
  List<Object> framesPending;
  String framesString;
  List<Object> frames;
  bool isNoteLocked;
  int lastNotedAt;
  int lastCommentedAt;
  FlagDetail? flagDetail;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'tags': tags,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'creator_id': creatorId,
        'approver_id': approverId,
        'author': author,
        'change': change,
        'source': source,
        'score': score,
        'md5': md5,
        'file_size': fileSize,
        'file_ext': fileExt,
        'file_url': fileUrl,
        'is_shown_in_index': isShownInIndex,
        'preview_url': previewUrl,
        'preview_width': previewWidth,
        'preview_height': previewHeight,
        'actual_preview_width': actualPreviewWidth,
        'actual_preview_height': actualPreviewHeight,
        'sample_url': sampleUrl,
        'sample_width': sampleWidth,
        'sample_height': sampleHeight,
        'sample_file_size': sampleFileSize,
        'jpeg_url': jpegUrl,
        'jpeg_width': jpegWidth,
        'jpeg_height': jpegHeight,
        'jpeg_file_size': jpegFileSize,
        'rating': rating,
        'is_rating_locked': isRatingLocked,
        'has_children': hasChildren,
        'parent_id': parentId,
        'status': status,
        'is_pending': isPending,
        'width': width,
        'height': height,
        'is_held': isHeld,
        'frames_pending_string': framesPendingString,
        'frames_pending': framesPending,
        'frames_string': framesString,
        'frames': frames,
        'is_note_locked': isNoteLocked,
        'last_noted_at': lastNotedAt,
        'last_commented_at': lastCommentedAt,
        'flag_detail': flagDetail,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class FlagDetail {
  FlagDetail({
    required this.postId,
    required this.reason,
    required this.createdAt,
    this.userId,
    required this.flaggedBy,
  });

  factory FlagDetail.fromJson(Map<String, dynamic> jsonRes) => FlagDetail(
        postId: asT<int>(jsonRes['post_id'])!,
        reason: asT<String>(jsonRes['reason'])!,
        createdAt: asT<String>(jsonRes['created_at'])!,
        userId: asT<Object?>(jsonRes['user_id']),
        flaggedBy: asT<String>(jsonRes['flagged_by'])!,
      );

  int postId;
  String reason;
  String createdAt;
  Object? userId;
  String flaggedBy;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'post_id': postId,
        'reason': reason,
        'created_at': createdAt,
        'user_id': userId,
        'flagged_by': flaggedBy,
      };

  FlagDetail clone() => FlagDetail.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
