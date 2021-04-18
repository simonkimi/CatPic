import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    this.id,
    required this.createdAt,
    required this.uploaderId,
    required this.score,
    required this.source,
    this.md5,
    this.lastCommentBumpedAt,
    required this.rating,
    required this.imageWidth,
    required this.imageHeight,
    required this.tagString,
    required this.isNoteLocked,
    required this.favCount,
    this.fileExt,
    this.lastNotedAt,
    required this.isRatingLocked,
    this.parentId,
    required this.hasChildren,
    this.approverId,
    required this.tagCountGeneral,
    required this.tagCountArtist,
    required this.tagCountCharacter,
    required this.tagCountCopyright,
    required this.fileSize,
    required this.isStatusLocked,
    required this.poolString,
    required this.upScore,
    required this.downScore,
    required this.isPending,
    required this.isFlagged,
    required this.isDeleted,
    required this.tagCount,
    required this.updatedAt,
    required this.isBanned,
    this.pixivId,
    this.lastCommentedAt,
    required this.hasActiveChildren,
    required this.bitFlags,
    required this.tagCountMeta,
    required this.hasLarge,
    required this.hasVisibleChildren,
    required this.tagStringGeneral,
    required this.tagStringCharacter,
    required this.tagStringCopyright,
    required this.tagStringArtist,
    required this.tagStringMeta,
    this.fileUrl,
    this.largeFileUrl,
    this.previewFileUrl,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => Root(
        id: asT<int?>(jsonRes['id']),
        createdAt: asT<String>(jsonRes['created_at'])!,
        uploaderId: asT<int>(jsonRes['uploader_id'])!,
        score: asT<int>(jsonRes['score'])!,
        source: asT<String>(jsonRes['source'])!,
        md5: asT<String?>(jsonRes['md5']),
        lastCommentBumpedAt: asT<String?>(jsonRes['last_comment_bumped_at']),
        rating: asT<String>(jsonRes['rating'])!,
        imageWidth: asT<int>(jsonRes['image_width'])!,
        imageHeight: asT<int>(jsonRes['image_height'])!,
        tagString: asT<String>(jsonRes['tag_string'])!,
        isNoteLocked: asT<bool>(jsonRes['is_note_locked'])!,
        favCount: asT<int>(jsonRes['fav_count'])!,
        fileExt: asT<String?>(jsonRes['file_ext']),
        lastNotedAt: asT<String?>(jsonRes['last_noted_at']),
        isRatingLocked: asT<bool>(jsonRes['is_rating_locked'])!,
        parentId: asT<int?>(jsonRes['parent_id']),
        hasChildren: asT<bool>(jsonRes['has_children'])!,
        approverId: asT<int?>(jsonRes['approver_id']),
        tagCountGeneral: asT<int>(jsonRes['tag_count_general'])!,
        tagCountArtist: asT<int>(jsonRes['tag_count_artist'])!,
        tagCountCharacter: asT<int>(jsonRes['tag_count_character'])!,
        tagCountCopyright: asT<int>(jsonRes['tag_count_copyright'])!,
        fileSize: asT<int>(jsonRes['file_size'])!,
        isStatusLocked: asT<bool>(jsonRes['is_status_locked'])!,
        poolString: asT<String>(jsonRes['pool_string'])!,
        upScore: asT<int>(jsonRes['up_score'])!,
        downScore: asT<int>(jsonRes['down_score'])!,
        isPending: asT<bool>(jsonRes['is_pending'])!,
        isFlagged: asT<bool>(jsonRes['is_flagged'])!,
        isDeleted: asT<bool>(jsonRes['is_deleted'])!,
        tagCount: asT<int>(jsonRes['tag_count'])!,
        updatedAt: asT<String>(jsonRes['updated_at'])!,
        isBanned: asT<bool>(jsonRes['is_banned'])!,
        pixivId: asT<int?>(jsonRes['pixiv_id']),
        lastCommentedAt: asT<String?>(jsonRes['last_commented_at']),
        hasActiveChildren: asT<bool>(jsonRes['has_active_children'])!,
        bitFlags: asT<int>(jsonRes['bit_flags'])!,
        tagCountMeta: asT<int>(jsonRes['tag_count_meta'])!,
        hasLarge: asT<bool>(jsonRes['has_large'])!,
        hasVisibleChildren: asT<bool>(jsonRes['has_visible_children'])!,
        tagStringGeneral: asT<String>(jsonRes['tag_string_general'])!,
        tagStringCharacter: asT<String>(jsonRes['tag_string_character'])!,
        tagStringCopyright: asT<String>(jsonRes['tag_string_copyright'])!,
        tagStringArtist: asT<String>(jsonRes['tag_string_artist'])!,
        tagStringMeta: asT<String>(jsonRes['tag_string_meta'])!,
        fileUrl: asT<String?>(jsonRes['file_url']),
        largeFileUrl: asT<String?>(jsonRes['large_file_url']),
        previewFileUrl: asT<String?>(jsonRes['preview_file_url']),
      );

  int? id;
  String createdAt;
  int uploaderId;
  int score;
  String source;
  String? md5;
  String? lastCommentBumpedAt;
  String rating;
  int imageWidth;
  int imageHeight;
  String tagString;
  bool isNoteLocked;
  int favCount;
  String? fileExt;
  String? lastNotedAt;
  bool isRatingLocked;
  int? parentId;
  bool hasChildren;
  int? approverId;
  int tagCountGeneral;
  int tagCountArtist;
  int tagCountCharacter;
  int tagCountCopyright;
  int fileSize;
  bool isStatusLocked;
  String poolString;
  int upScore;
  int downScore;
  bool isPending;
  bool isFlagged;
  bool isDeleted;
  int tagCount;
  String updatedAt;
  bool isBanned;
  int? pixivId;
  String? lastCommentedAt;
  bool hasActiveChildren;
  int bitFlags;
  int tagCountMeta;
  bool hasLarge;
  bool hasVisibleChildren;
  String tagStringGeneral;
  String tagStringCharacter;
  String tagStringCopyright;
  String tagStringArtist;
  String tagStringMeta;
  String? fileUrl;
  String? largeFileUrl;
  String? previewFileUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt,
        'uploader_id': uploaderId,
        'score': score,
        'source': source,
        'md5': md5,
        'last_comment_bumped_at': lastCommentBumpedAt,
        'rating': rating,
        'image_width': imageWidth,
        'image_height': imageHeight,
        'tag_string': tagString,
        'is_note_locked': isNoteLocked,
        'fav_count': favCount,
        'file_ext': fileExt,
        'last_noted_at': lastNotedAt,
        'is_rating_locked': isRatingLocked,
        'parent_id': parentId,
        'has_children': hasChildren,
        'approver_id': approverId,
        'tag_count_general': tagCountGeneral,
        'tag_count_artist': tagCountArtist,
        'tag_count_character': tagCountCharacter,
        'tag_count_copyright': tagCountCopyright,
        'file_size': fileSize,
        'is_status_locked': isStatusLocked,
        'pool_string': poolString,
        'up_score': upScore,
        'down_score': downScore,
        'is_pending': isPending,
        'is_flagged': isFlagged,
        'is_deleted': isDeleted,
        'tag_count': tagCount,
        'updated_at': updatedAt,
        'is_banned': isBanned,
        'pixiv_id': pixivId,
        'last_commented_at': lastCommentedAt,
        'has_active_children': hasActiveChildren,
        'bit_flags': bitFlags,
        'tag_count_meta': tagCountMeta,
        'has_large': hasLarge,
        'has_visible_children': hasVisibleChildren,
        'tag_string_general': tagStringGeneral,
        'tag_string_character': tagStringCharacter,
        'tag_string_copyright': tagStringCopyright,
        'tag_string_artist': tagStringArtist,
        'tag_string_meta': tagStringMeta,
        'file_url': fileUrl,
        'large_file_url': largeFileUrl,
        'preview_file_url': previewFileUrl,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
