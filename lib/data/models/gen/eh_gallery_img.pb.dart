///
//  Generated code. Do not modify.
//  source: eh_gallery_img.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class GalleryImgModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GalleryImgModel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imgUrl',
        protoName: 'imgUrl')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imgSize',
        protoName: 'imgSize')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'width',
        $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawWidth', $pb.PbFieldType.O3, protoName: 'rawWidth')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawHeight', $pb.PbFieldType.O3, protoName: 'rawHeight')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawImgUrl', protoName: 'rawImgUrl')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawImgSize', protoName: 'rawImgSize')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sha')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shaToken', protoName: 'shaToken')
    ..hasRequiredFields = false;

  GalleryImgModel._() : super();
  factory GalleryImgModel({
    $core.String? imgUrl,
    $core.String? imgSize,
    $core.int? width,
    $core.int? height,
    $core.int? rawWidth,
    $core.int? rawHeight,
    $core.String? rawImgUrl,
    $core.String? rawImgSize,
    $core.String? sha,
    $core.String? shaToken,
  }) {
    final _result = create();
    if (imgUrl != null) {
      _result.imgUrl = imgUrl;
    }
    if (imgSize != null) {
      _result.imgSize = imgSize;
    }
    if (width != null) {
      _result.width = width;
    }
    if (height != null) {
      _result.height = height;
    }
    if (rawWidth != null) {
      _result.rawWidth = rawWidth;
    }
    if (rawHeight != null) {
      _result.rawHeight = rawHeight;
    }
    if (rawImgUrl != null) {
      _result.rawImgUrl = rawImgUrl;
    }
    if (rawImgSize != null) {
      _result.rawImgSize = rawImgSize;
    }
    if (sha != null) {
      _result.sha = sha;
    }
    if (shaToken != null) {
      _result.shaToken = shaToken;
    }
    return _result;
  }
  factory GalleryImgModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GalleryImgModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GalleryImgModel clone() => GalleryImgModel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GalleryImgModel copyWith(void Function(GalleryImgModel) updates) =>
      super.copyWith((message) => updates(message as GalleryImgModel))
          as GalleryImgModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryImgModel create() => GalleryImgModel._();
  GalleryImgModel createEmptyInstance() => create();
  static $pb.PbList<GalleryImgModel> createRepeated() =>
      $pb.PbList<GalleryImgModel>();
  @$core.pragma('dart2js:noInline')
  static GalleryImgModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GalleryImgModel>(create);
  static GalleryImgModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imgUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set imgUrl($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasImgUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearImgUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get imgSize => $_getSZ(1);
  @$pb.TagNumber(2)
  set imgSize($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasImgSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearImgSize() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get rawWidth => $_getIZ(4);
  @$pb.TagNumber(5)
  set rawWidth($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRawWidth() => $_has(4);
  @$pb.TagNumber(5)
  void clearRawWidth() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get rawHeight => $_getIZ(5);
  @$pb.TagNumber(6)
  set rawHeight($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasRawHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearRawHeight() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get rawImgUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set rawImgUrl($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasRawImgUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearRawImgUrl() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get rawImgSize => $_getSZ(7);
  @$pb.TagNumber(8)
  set rawImgSize($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasRawImgSize() => $_has(7);
  @$pb.TagNumber(8)
  void clearRawImgSize() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get sha => $_getSZ(8);
  @$pb.TagNumber(9)
  set sha($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasSha() => $_has(8);
  @$pb.TagNumber(9)
  void clearSha() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get shaToken => $_getSZ(9);
  @$pb.TagNumber(10)
  set shaToken($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasShaToken() => $_has(9);
  @$pb.TagNumber(10)
  void clearShaToken() => clearField(10);
}
