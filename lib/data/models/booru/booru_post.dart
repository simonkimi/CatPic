import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

import 'package:catpic/main.dart';

class PostRating {
  static const SAFE = 0;
  static const EXPLICIT = 1;
  static const QUESTIONABLE = 2;
}

String getRatingText(BuildContext context, int rating) {
  switch (rating) {
    case PostRating.SAFE:
      return I18n.of(context).safe;
    case PostRating.EXPLICIT:
      return I18n.of(context).explicit;
    case PostRating.QUESTIONABLE:
    default:
      return I18n.of(context).questionable;
  }
}

class BooruPost {
  BooruPost({
    required this.id,
    required this.md5,
    required this.creatorId,
    required this.imgURL,
    required this.previewURL,
    required this.sampleURL,
    required this.width,
    required this.height,
    required this.sampleWidth,
    required this.sampleHeight,
    required this.previewWidth,
    required this.previewHeight,
    required this.rating,
    required this.status,
    required this.tags,
    required this.source,
    required this.createTime,
    required this.score,
    this.favourite = false,
  });

  factory BooruPost.fromJson(Map<String, dynamic> jsonRes) {
    return BooruPost(
      id: jsonRes['id'] as String,
      creatorId: jsonRes['creatorId'] as String,
      createTime: jsonRes['createTime'] as String,
      md5: jsonRes['md5'] as String,
      imgURL: jsonRes['imgURL'] as String,
      previewURL: jsonRes['previewURL'] as String,
      sampleURL: jsonRes['sampleURL'] as String,
      width: jsonRes['width'] as int,
      height: jsonRes['height'] as int,
      sampleWidth: jsonRes['sampleWidth'] as int,
      sampleHeight: jsonRes['sampleHeight'] as int,
      previewWidth: jsonRes['previewWidth'] as int,
      previewHeight: jsonRes['previewHeight'] as int,
      rating: jsonRes['rating'] as int,
      status: jsonRes['status'] as String,
      tags: (jsonRes['tags'] as Map<String, dynamic>).map(
        (key, dynamic value) => MapEntry<String, List<String>>(
          key,
          (value as List<dynamic>).cast<String>(),
        ),
      ),
      source: jsonRes['source'] as String,
      score: jsonRes['score'] as String,
    );
  }

  BooruPost copyWith({
    String? id,
    String? md5,
    String? creatorId,
    String? imgURL,
    String? previewURL,
    String? sampleURL,
    int? width,
    int? height,
    int? sampleWidth,
    int? sampleHeight,
    int? previewWidth,
    int? previewHeight,
    int? rating,
    String? status,
    Map<String, List<String>>? tags,
    String? source,
    String? createTime,
    String? score,
    bool? favourite = false,
  }) {
    return BooruPost(
      id: id ?? this.id,
      md5: md5 ?? this.md5,
      creatorId: creatorId ?? this.creatorId,
      imgURL: imgURL ?? this.imgURL,
      previewURL: previewURL ?? this.previewURL,
      sampleURL: sampleURL ?? this.sampleURL,
      width: width ?? this.width,
      height: height ?? this.height,
      sampleWidth: sampleWidth ?? this.sampleWidth,
      sampleHeight: sampleHeight ?? this.sampleHeight,
      previewWidth: previewWidth ?? this.previewWidth,
      previewHeight: previewHeight ?? this.previewHeight,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      createTime: createTime ?? this.createTime,
      score: score ?? this.score,
      favourite: favourite ?? this.favourite,
    );
  }

  final String id;
  final String creatorId;
  final String createTime;
  final String md5;

  final String imgURL;
  final String previewURL;
  final String sampleURL;

  final int width;
  final int height;
  final int sampleWidth;
  final int sampleHeight;
  final int previewWidth;
  final int previewHeight;

  final int rating;
  final String status;
  final Map<String, List<String>> tags;
  final String source;
  final String score;
  bool favourite;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'creatorId': creatorId,
        'createTime': createTime,
        'md5': md5,
        'imgURL': imgURL,
        'previewURL': previewURL,
        'sampleURL': sampleURL,
        'width': width,
        'height': height,
        'sampleWidth': sampleWidth,
        'sampleHeight': sampleHeight,
        'previewWidth': previewWidth,
        'previewHeight': previewHeight,
        'rating': rating,
        'status': status,
        'tags': tags,
        'source': source,
        'score': score
      };

  String getPreviewImg() {
    switch (settingStore.previewQuality) {
      case ImageQuality.preview:
        return previewURL;
      case ImageQuality.sample:
        return sampleURL;
      case ImageQuality.raw:
      default:
        return imgURL;
    }
  }

  String getDisplayImg() {
    switch (settingStore.displayQuality) {
      case ImageQuality.preview:
        return previewURL;
      case ImageQuality.sample:
        return sampleURL;
      case ImageQuality.raw:
      default:
        return imgURL;
    }
  }

  String getDownloadImg() {
    switch (settingStore.downloadQuality) {
      case ImageQuality.preview:
        return previewURL;
      case ImageQuality.sample:
        return sampleURL;
      case ImageQuality.raw:
      default:
        return imgURL;
    }
  }
}
