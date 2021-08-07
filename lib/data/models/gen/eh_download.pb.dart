///
//  Generated code. Do not modify.
//  source: eh_download.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'eh_gallery.pb.dart' as $0;

class EhDownloadModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'EhDownloadModel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOM<$0.GalleryModel>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'model',
        subBuilder: $0.GalleryModel.create)
    ..m<$core.int, $core.String>(2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pageInfo',
        protoName: 'pageInfo',
        entryClassName: 'EhDownloadModel.PageInfoEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('ehentai'))
    ..hasRequiredFields = false;

  EhDownloadModel._() : super();
  factory EhDownloadModel({
    $0.GalleryModel? model,
    $core.Map<$core.int, $core.String>? pageInfo,
  }) {
    final _result = create();
    if (model != null) {
      _result.model = model;
    }
    if (pageInfo != null) {
      _result.pageInfo.addAll(pageInfo);
    }
    return _result;
  }
  factory EhDownloadModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EhDownloadModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  EhDownloadModel clone() => EhDownloadModel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  EhDownloadModel copyWith(void Function(EhDownloadModel) updates) =>
      super.copyWith((message) => updates(message as EhDownloadModel))
          as EhDownloadModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EhDownloadModel create() => EhDownloadModel._();
  EhDownloadModel createEmptyInstance() => create();
  static $pb.PbList<EhDownloadModel> createRepeated() =>
      $pb.PbList<EhDownloadModel>();
  @$core.pragma('dart2js:noInline')
  static EhDownloadModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EhDownloadModel>(create);
  static EhDownloadModel? _defaultInstance;

  @$pb.TagNumber(1)
  $0.GalleryModel get model => $_getN(0);
  @$pb.TagNumber(1)
  set model($0.GalleryModel v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => clearField(1);
  @$pb.TagNumber(1)
  $0.GalleryModel ensureModel() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.Map<$core.int, $core.String> get pageInfo => $_getMap(1);
}
