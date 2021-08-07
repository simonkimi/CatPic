///
//  Generated code. Do not modify.
//  source: eh_preview.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PreviewTag extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PreviewTag',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tag')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'color',
        $pb.PbFieldType.O3)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'translate')
    ..hasRequiredFields = false;

  PreviewTag._() : super();
  factory PreviewTag({
    $core.String? tag,
    $core.int? color,
    $core.String? translate,
  }) {
    final _result = create();
    if (tag != null) {
      _result.tag = tag;
    }
    if (color != null) {
      _result.color = color;
    }
    if (translate != null) {
      _result.translate = translate;
    }
    return _result;
  }
  factory PreviewTag.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PreviewTag.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PreviewTag clone() => PreviewTag()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PreviewTag copyWith(void Function(PreviewTag) updates) =>
      super.copyWith((message) => updates(message as PreviewTag))
          as PreviewTag; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PreviewTag create() => PreviewTag._();
  PreviewTag createEmptyInstance() => create();
  static $pb.PbList<PreviewTag> createRepeated() => $pb.PbList<PreviewTag>();
  @$core.pragma('dart2js:noInline')
  static PreviewTag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewTag>(create);
  static PreviewTag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get color => $_getIZ(1);
  @$pb.TagNumber(2)
  set color($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearColor() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get translate => $_getSZ(2);
  @$pb.TagNumber(3)
  set translate($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTranslate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTranslate() => clearField(3);
}

class PreViewItemModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PreViewItemModel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'title')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tag',
        $pb.PbFieldType.O3)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'uploader')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadTime', protoName: 'uploadTime')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pages', $pb.PbFieldType.O3)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stars', $pb.PbFieldType.OD)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'language')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewImg', protoName: 'previewImg')
    ..pc<PreviewTag>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyTags', $pb.PbFieldType.PM, protoName: 'keyTags', subBuilder: PreviewTag.create)
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewHeight', $pb.PbFieldType.O3, protoName: 'previewHeight')
    ..a<$core.int>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewWidth', $pb.PbFieldType.O3, protoName: 'previewWidth')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gid')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gtoken')
    ..hasRequiredFields = false;

  PreViewItemModel._() : super();
  factory PreViewItemModel({
    $core.String? title,
    $core.int? tag,
    $core.String? uploader,
    $core.String? uploadTime,
    $core.int? pages,
    $core.double? stars,
    $core.String? language,
    $core.String? previewImg,
    $core.Iterable<PreviewTag>? keyTags,
    $core.int? previewHeight,
    $core.int? previewWidth,
    $core.String? gid,
    $core.String? gtoken,
  }) {
    final _result = create();
    if (title != null) {
      _result.title = title;
    }
    if (tag != null) {
      _result.tag = tag;
    }
    if (uploader != null) {
      _result.uploader = uploader;
    }
    if (uploadTime != null) {
      _result.uploadTime = uploadTime;
    }
    if (pages != null) {
      _result.pages = pages;
    }
    if (stars != null) {
      _result.stars = stars;
    }
    if (language != null) {
      _result.language = language;
    }
    if (previewImg != null) {
      _result.previewImg = previewImg;
    }
    if (keyTags != null) {
      _result.keyTags.addAll(keyTags);
    }
    if (previewHeight != null) {
      _result.previewHeight = previewHeight;
    }
    if (previewWidth != null) {
      _result.previewWidth = previewWidth;
    }
    if (gid != null) {
      _result.gid = gid;
    }
    if (gtoken != null) {
      _result.gtoken = gtoken;
    }
    return _result;
  }
  factory PreViewItemModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PreViewItemModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PreViewItemModel clone() => PreViewItemModel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PreViewItemModel copyWith(void Function(PreViewItemModel) updates) =>
      super.copyWith((message) => updates(message as PreViewItemModel))
          as PreViewItemModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PreViewItemModel create() => PreViewItemModel._();
  PreViewItemModel createEmptyInstance() => create();
  static $pb.PbList<PreViewItemModel> createRepeated() =>
      $pb.PbList<PreViewItemModel>();
  @$core.pragma('dart2js:noInline')
  static PreViewItemModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreViewItemModel>(create);
  static PreViewItemModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get tag => $_getIZ(1);
  @$pb.TagNumber(2)
  set tag($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearTag() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uploader => $_getSZ(2);
  @$pb.TagNumber(3)
  set uploader($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasUploader() => $_has(2);
  @$pb.TagNumber(3)
  void clearUploader() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get uploadTime => $_getSZ(3);
  @$pb.TagNumber(4)
  set uploadTime($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasUploadTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearUploadTime() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get pages => $_getIZ(4);
  @$pb.TagNumber(5)
  set pages($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPages() => $_has(4);
  @$pb.TagNumber(5)
  void clearPages() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get stars => $_getN(5);
  @$pb.TagNumber(6)
  set stars($core.double v) {
    $_setDouble(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasStars() => $_has(5);
  @$pb.TagNumber(6)
  void clearStars() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get language => $_getSZ(6);
  @$pb.TagNumber(7)
  set language($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLanguage() => $_has(6);
  @$pb.TagNumber(7)
  void clearLanguage() => clearField(7);

  @$pb.TagNumber(9)
  $core.String get previewImg => $_getSZ(7);
  @$pb.TagNumber(9)
  set previewImg($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPreviewImg() => $_has(7);
  @$pb.TagNumber(9)
  void clearPreviewImg() => clearField(9);

  @$pb.TagNumber(10)
  $core.List<PreviewTag> get keyTags => $_getList(8);

  @$pb.TagNumber(11)
  $core.int get previewHeight => $_getIZ(9);
  @$pb.TagNumber(11)
  set previewHeight($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPreviewHeight() => $_has(9);
  @$pb.TagNumber(11)
  void clearPreviewHeight() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get previewWidth => $_getIZ(10);
  @$pb.TagNumber(12)
  set previewWidth($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasPreviewWidth() => $_has(10);
  @$pb.TagNumber(12)
  void clearPreviewWidth() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get gid => $_getSZ(11);
  @$pb.TagNumber(13)
  set gid($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasGid() => $_has(11);
  @$pb.TagNumber(13)
  void clearGid() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get gtoken => $_getSZ(12);
  @$pb.TagNumber(14)
  set gtoken($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasGtoken() => $_has(12);
  @$pb.TagNumber(14)
  void clearGtoken() => clearField(14);
}
