import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class PoolList {
  PoolList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isPublic,
    required this.postCount,
    required this.description,
  });

  factory PoolList.fromJson(Map<String, dynamic> jsonRes) => PoolList(
        id: asT<int>(jsonRes['id'])!,
        name: asT<String>(jsonRes['name'])!,
        createdAt: asT<String>(jsonRes['created_at'])!,
        updatedAt: asT<String>(jsonRes['updated_at'])!,
        userId: asT<int>(jsonRes['user_id'])!,
        isPublic: asT<bool>(jsonRes['is_public'])!,
        postCount: asT<int>(jsonRes['post_count'])!,
        description: asT<String>(jsonRes['description'])!,
      );

  int id;
  String name;
  String createdAt;
  String updatedAt;
  int userId;
  bool isPublic;
  int postCount;
  String description;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user_id': userId,
        'is_public': isPublic,
        'post_count': postCount,
        'description': description,
      };

  PoolList clone() => PoolList.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Pool {
  Pool({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isPublic,
    required this.postCount,
    required this.description,
    required this.posts,
  });

  factory Pool.fromJson(Map<String, dynamic> jsonRes) {
    final List<PoolPosts>? posts =
        jsonRes['posts'] is List ? <PoolPosts>[] : null;
    if (posts != null) {
      for (final dynamic item in jsonRes['posts']!) {
        if (item != null) {
          tryCatch(() {
            posts.add(PoolPosts.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return Pool(
      id: asT<int>(jsonRes['id'])!,
      name: asT<String>(jsonRes['name'])!,
      createdAt: asT<String>(jsonRes['created_at'])!,
      updatedAt: asT<String>(jsonRes['updated_at'])!,
      userId: asT<int>(jsonRes['user_id'])!,
      isPublic: asT<bool>(jsonRes['is_public'])!,
      postCount: asT<int>(jsonRes['post_count'])!,
      description: asT<String>(jsonRes['description'])!,
      posts: posts!,
    );
  }

  int id;
  String name;
  String createdAt;
  String updatedAt;
  int userId;
  bool isPublic;
  int postCount;
  String description;
  List<PoolPosts> posts;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user_id': userId,
        'is_public': isPublic,
        'post_count': postCount,
        'description': description,
        'posts': posts,
      };

  Pool clone() =>
      Pool.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class PoolPosts {
  PoolPosts({
    required this.id,
    required this.tags,
    required this.createdAt,
    required this.creatorId,
    required this.author,
    required this.change,
    required this.source,
    required this.score,
    required this.md5,
    required this.fileSize,
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
    required this.hasChildren,
    this.parentId,
    required this.status,
    required this.width,
    required this.height,
    required this.isHeld,
    required this.framesPendingString,
    required this.framesPending,
    required this.framesString,
    required this.frames,
  });

  factory PoolPosts.fromJson(Map<String, dynamic> jsonRes) {
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
    return PoolPosts(
      id: asT<int>(jsonRes['id'])!,
      tags: asT<String>(jsonRes['tags'])!,
      createdAt: asT<String>(jsonRes['created_at'])!,
      creatorId: asT<int>(jsonRes['creator_id'])!,
      author: asT<String>(jsonRes['author'])!,
      change: asT<int>(jsonRes['change'])!,
      source: asT<String>(jsonRes['source'])!,
      score: asT<int>(jsonRes['score'])!,
      md5: asT<String>(jsonRes['md5'])!,
      fileSize: asT<int>(jsonRes['file_size'])!,
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
      hasChildren: asT<bool>(jsonRes['has_children'])!,
      parentId: asT<Object?>(jsonRes['parent_id']),
      status: asT<String>(jsonRes['status'])!,
      width: asT<int>(jsonRes['width'])!,
      height: asT<int>(jsonRes['height'])!,
      isHeld: asT<bool>(jsonRes['is_held'])!,
      framesPendingString: asT<String>(jsonRes['frames_pending_string'])!,
      framesPending: framesPending!,
      framesString: asT<String>(jsonRes['frames_string'])!,
      frames: frames!,
    );
  }

  int id;
  String tags;
  String createdAt;
  int creatorId;
  String author;
  int change;
  String source;
  int score;
  String md5;
  int fileSize;
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
  bool hasChildren;
  Object? parentId;
  String status;
  int width;
  int height;
  bool isHeld;
  String framesPendingString;
  List<Object> framesPending;
  String framesString;
  List<Object> frames;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'tags': tags,
        'created_at': createdAt,
        'creator_id': creatorId,
        'author': author,
        'change': change,
        'source': source,
        'score': score,
        'md5': md5,
        'file_size': fileSize,
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
        'has_children': hasChildren,
        'parent_id': parentId,
        'status': status,
        'width': width,
        'height': height,
        'is_held': isHeld,
        'frames_pending_string': framesPendingString,
        'frames_pending': framesPending,
        'frames_string': framesString,
        'frames': frames,
      };

  PoolPosts clone() => PoolPosts.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
