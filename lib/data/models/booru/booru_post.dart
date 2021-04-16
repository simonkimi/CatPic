import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

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
  });

  factory BooruPost.fromJson(Map<String, dynamic> jsonRes) {
    return BooruPost(
      id: jsonRes['id'],
      creatorId: jsonRes['creatorId'],
      createTime: jsonRes['createTime'],
      md5: jsonRes['md5'],
      imgURL: jsonRes['imgURL'],
      previewURL: jsonRes['previewURL'],
      sampleURL: jsonRes['sampleURL'],
      width: jsonRes['width'],
      height: jsonRes['height'],
      sampleWidth: jsonRes['sampleWidth'],
      sampleHeight: jsonRes['sampleHeight'],
      previewWidth: jsonRes['previewWidth'],
      previewHeight: jsonRes['previewHeight'],
      rating: jsonRes['rating'],
      status: jsonRes['status'],
      tags: (jsonRes['tags'] as Map<String, dynamic>).map(
        (key, value) => MapEntry<String, List<String>>(
          key,
          (value as List<dynamic>).cast<String>(),
        ),
      ),
      source: jsonRes['source'],
      score: jsonRes['score'],
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

  Map<String, dynamic> toJson() => {
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
}
