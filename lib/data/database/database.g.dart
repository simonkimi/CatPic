// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DownloadTableData extends DataClass
    implements Insertable<DownloadTableData> {
  final int id;
  final String fileName;
  final String postId;
  final String md5;
  final int websiteId;
  final String imgUrl;
  final String previewUrl;
  final String largerUrl;
  final int quality;
  final int status;
  final String booruJson;
  final DateTime createTime;
  DownloadTableData(
      {required this.id,
      required this.fileName,
      required this.postId,
      required this.md5,
      required this.websiteId,
      required this.imgUrl,
      required this.previewUrl,
      required this.largerUrl,
      required this.quality,
      required this.status,
      required this.booruJson,
      required this.createTime});
  factory DownloadTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DownloadTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      fileName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file_name'])!,
      postId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}post_id'])!,
      md5: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}md5'])!,
      websiteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}website_id'])!,
      imgUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}img_url'])!,
      previewUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}preview_url'])!,
      largerUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}larger_url'])!,
      quality: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quality'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      booruJson: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}booru_json'])!,
      createTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_name'] = Variable<String>(fileName);
    map['post_id'] = Variable<String>(postId);
    map['md5'] = Variable<String>(md5);
    map['website_id'] = Variable<int>(websiteId);
    map['img_url'] = Variable<String>(imgUrl);
    map['preview_url'] = Variable<String>(previewUrl);
    map['larger_url'] = Variable<String>(largerUrl);
    map['quality'] = Variable<int>(quality);
    map['status'] = Variable<int>(status);
    map['booru_json'] = Variable<String>(booruJson);
    map['create_time'] = Variable<DateTime>(createTime);
    return map;
  }

  DownloadTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadTableCompanion(
      id: Value(id),
      fileName: Value(fileName),
      postId: Value(postId),
      md5: Value(md5),
      websiteId: Value(websiteId),
      imgUrl: Value(imgUrl),
      previewUrl: Value(previewUrl),
      largerUrl: Value(largerUrl),
      quality: Value(quality),
      status: Value(status),
      booruJson: Value(booruJson),
      createTime: Value(createTime),
    );
  }

  factory DownloadTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DownloadTableData(
      id: serializer.fromJson<int>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      postId: serializer.fromJson<String>(json['postId']),
      md5: serializer.fromJson<String>(json['md5']),
      websiteId: serializer.fromJson<int>(json['websiteId']),
      imgUrl: serializer.fromJson<String>(json['imgUrl']),
      previewUrl: serializer.fromJson<String>(json['previewUrl']),
      largerUrl: serializer.fromJson<String>(json['largerUrl']),
      quality: serializer.fromJson<int>(json['quality']),
      status: serializer.fromJson<int>(json['status']),
      booruJson: serializer.fromJson<String>(json['booruJson']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileName': serializer.toJson<String>(fileName),
      'postId': serializer.toJson<String>(postId),
      'md5': serializer.toJson<String>(md5),
      'websiteId': serializer.toJson<int>(websiteId),
      'imgUrl': serializer.toJson<String>(imgUrl),
      'previewUrl': serializer.toJson<String>(previewUrl),
      'largerUrl': serializer.toJson<String>(largerUrl),
      'quality': serializer.toJson<int>(quality),
      'status': serializer.toJson<int>(status),
      'booruJson': serializer.toJson<String>(booruJson),
      'createTime': serializer.toJson<DateTime>(createTime),
    };
  }

  DownloadTableData copyWith(
          {int? id,
          String? fileName,
          String? postId,
          String? md5,
          int? websiteId,
          String? imgUrl,
          String? previewUrl,
          String? largerUrl,
          int? quality,
          int? status,
          String? booruJson,
          DateTime? createTime}) =>
      DownloadTableData(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        postId: postId ?? this.postId,
        md5: md5 ?? this.md5,
        websiteId: websiteId ?? this.websiteId,
        imgUrl: imgUrl ?? this.imgUrl,
        previewUrl: previewUrl ?? this.previewUrl,
        largerUrl: largerUrl ?? this.largerUrl,
        quality: quality ?? this.quality,
        status: status ?? this.status,
        booruJson: booruJson ?? this.booruJson,
        createTime: createTime ?? this.createTime,
      );
  @override
  String toString() {
    return (StringBuffer('DownloadTableData(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('postId: $postId, ')
          ..write('md5: $md5, ')
          ..write('websiteId: $websiteId, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('previewUrl: $previewUrl, ')
          ..write('largerUrl: $largerUrl, ')
          ..write('quality: $quality, ')
          ..write('status: $status, ')
          ..write('booruJson: $booruJson, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          fileName.hashCode,
          $mrjc(
              postId.hashCode,
              $mrjc(
                  md5.hashCode,
                  $mrjc(
                      websiteId.hashCode,
                      $mrjc(
                          imgUrl.hashCode,
                          $mrjc(
                              previewUrl.hashCode,
                              $mrjc(
                                  largerUrl.hashCode,
                                  $mrjc(
                                      quality.hashCode,
                                      $mrjc(
                                          status.hashCode,
                                          $mrjc(booruJson.hashCode,
                                              createTime.hashCode))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadTableData &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.postId == this.postId &&
          other.md5 == this.md5 &&
          other.websiteId == this.websiteId &&
          other.imgUrl == this.imgUrl &&
          other.previewUrl == this.previewUrl &&
          other.largerUrl == this.largerUrl &&
          other.quality == this.quality &&
          other.status == this.status &&
          other.booruJson == this.booruJson &&
          other.createTime == this.createTime);
}

class DownloadTableCompanion extends UpdateCompanion<DownloadTableData> {
  final Value<int> id;
  final Value<String> fileName;
  final Value<String> postId;
  final Value<String> md5;
  final Value<int> websiteId;
  final Value<String> imgUrl;
  final Value<String> previewUrl;
  final Value<String> largerUrl;
  final Value<int> quality;
  final Value<int> status;
  final Value<String> booruJson;
  final Value<DateTime> createTime;
  const DownloadTableCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.postId = const Value.absent(),
    this.md5 = const Value.absent(),
    this.websiteId = const Value.absent(),
    this.imgUrl = const Value.absent(),
    this.previewUrl = const Value.absent(),
    this.largerUrl = const Value.absent(),
    this.quality = const Value.absent(),
    this.status = const Value.absent(),
    this.booruJson = const Value.absent(),
    this.createTime = const Value.absent(),
  });
  DownloadTableCompanion.insert({
    this.id = const Value.absent(),
    required String fileName,
    required String postId,
    required String md5,
    required int websiteId,
    required String imgUrl,
    required String previewUrl,
    required String largerUrl,
    required int quality,
    required int status,
    required String booruJson,
    this.createTime = const Value.absent(),
  })  : fileName = Value(fileName),
        postId = Value(postId),
        md5 = Value(md5),
        websiteId = Value(websiteId),
        imgUrl = Value(imgUrl),
        previewUrl = Value(previewUrl),
        largerUrl = Value(largerUrl),
        quality = Value(quality),
        status = Value(status),
        booruJson = Value(booruJson);
  static Insertable<DownloadTableData> custom({
    Expression<int>? id,
    Expression<String>? fileName,
    Expression<String>? postId,
    Expression<String>? md5,
    Expression<int>? websiteId,
    Expression<String>? imgUrl,
    Expression<String>? previewUrl,
    Expression<String>? largerUrl,
    Expression<int>? quality,
    Expression<int>? status,
    Expression<String>? booruJson,
    Expression<DateTime>? createTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (postId != null) 'post_id': postId,
      if (md5 != null) 'md5': md5,
      if (websiteId != null) 'website_id': websiteId,
      if (imgUrl != null) 'img_url': imgUrl,
      if (previewUrl != null) 'preview_url': previewUrl,
      if (largerUrl != null) 'larger_url': largerUrl,
      if (quality != null) 'quality': quality,
      if (status != null) 'status': status,
      if (booruJson != null) 'booru_json': booruJson,
      if (createTime != null) 'create_time': createTime,
    });
  }

  DownloadTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? fileName,
      Value<String>? postId,
      Value<String>? md5,
      Value<int>? websiteId,
      Value<String>? imgUrl,
      Value<String>? previewUrl,
      Value<String>? largerUrl,
      Value<int>? quality,
      Value<int>? status,
      Value<String>? booruJson,
      Value<DateTime>? createTime}) {
    return DownloadTableCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      postId: postId ?? this.postId,
      md5: md5 ?? this.md5,
      websiteId: websiteId ?? this.websiteId,
      imgUrl: imgUrl ?? this.imgUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      largerUrl: largerUrl ?? this.largerUrl,
      quality: quality ?? this.quality,
      status: status ?? this.status,
      booruJson: booruJson ?? this.booruJson,
      createTime: createTime ?? this.createTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (md5.present) {
      map['md5'] = Variable<String>(md5.value);
    }
    if (websiteId.present) {
      map['website_id'] = Variable<int>(websiteId.value);
    }
    if (imgUrl.present) {
      map['img_url'] = Variable<String>(imgUrl.value);
    }
    if (previewUrl.present) {
      map['preview_url'] = Variable<String>(previewUrl.value);
    }
    if (largerUrl.present) {
      map['larger_url'] = Variable<String>(largerUrl.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (booruJson.present) {
      map['booru_json'] = Variable<String>(booruJson.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTableCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('postId: $postId, ')
          ..write('md5: $md5, ')
          ..write('websiteId: $websiteId, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('previewUrl: $previewUrl, ')
          ..write('largerUrl: $largerUrl, ')
          ..write('quality: $quality, ')
          ..write('status: $status, ')
          ..write('booruJson: $booruJson, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }
}

class $DownloadTableTable extends DownloadTable
    with TableInfo<$DownloadTableTable, DownloadTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DownloadTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _fileNameMeta = const VerificationMeta('fileName');
  late final GeneratedColumn<String?> fileName = GeneratedColumn<String?>(
      'file_name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _postIdMeta = const VerificationMeta('postId');
  late final GeneratedColumn<String?> postId = GeneratedColumn<String?>(
      'post_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _md5Meta = const VerificationMeta('md5');
  late final GeneratedColumn<String?> md5 = GeneratedColumn<String?>(
      'md5', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _websiteIdMeta = const VerificationMeta('websiteId');
  late final GeneratedColumn<int?> websiteId = GeneratedColumn<int?>(
      'website_id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _imgUrlMeta = const VerificationMeta('imgUrl');
  late final GeneratedColumn<String?> imgUrl = GeneratedColumn<String?>(
      'img_url', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _previewUrlMeta = const VerificationMeta('previewUrl');
  late final GeneratedColumn<String?> previewUrl = GeneratedColumn<String?>(
      'preview_url', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _largerUrlMeta = const VerificationMeta('largerUrl');
  late final GeneratedColumn<String?> largerUrl = GeneratedColumn<String?>(
      'larger_url', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _qualityMeta = const VerificationMeta('quality');
  late final GeneratedColumn<int?> quality = GeneratedColumn<int?>(
      'quality', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _booruJsonMeta = const VerificationMeta('booruJson');
  late final GeneratedColumn<String?> booruJson = GeneratedColumn<String?>(
      'booru_json', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  late final GeneratedColumn<DateTime?> createTime = GeneratedColumn<DateTime?>(
      'create_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fileName,
        postId,
        md5,
        websiteId,
        imgUrl,
        previewUrl,
        largerUrl,
        quality,
        status,
        booruJson,
        createTime
      ];
  @override
  String get aliasedName => _alias ?? 'download_table';
  @override
  String get actualTableName => 'download_table';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(_postIdMeta,
          postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta));
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('md5')) {
      context.handle(
          _md5Meta, md5.isAcceptableOrUnknown(data['md5']!, _md5Meta));
    } else if (isInserting) {
      context.missing(_md5Meta);
    }
    if (data.containsKey('website_id')) {
      context.handle(_websiteIdMeta,
          websiteId.isAcceptableOrUnknown(data['website_id']!, _websiteIdMeta));
    } else if (isInserting) {
      context.missing(_websiteIdMeta);
    }
    if (data.containsKey('img_url')) {
      context.handle(_imgUrlMeta,
          imgUrl.isAcceptableOrUnknown(data['img_url']!, _imgUrlMeta));
    } else if (isInserting) {
      context.missing(_imgUrlMeta);
    }
    if (data.containsKey('preview_url')) {
      context.handle(
          _previewUrlMeta,
          previewUrl.isAcceptableOrUnknown(
              data['preview_url']!, _previewUrlMeta));
    } else if (isInserting) {
      context.missing(_previewUrlMeta);
    }
    if (data.containsKey('larger_url')) {
      context.handle(_largerUrlMeta,
          largerUrl.isAcceptableOrUnknown(data['larger_url']!, _largerUrlMeta));
    } else if (isInserting) {
      context.missing(_largerUrlMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(_qualityMeta,
          quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta));
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('booru_json')) {
      context.handle(_booruJsonMeta,
          booruJson.isAcceptableOrUnknown(data['booru_json']!, _booruJsonMeta));
    } else if (isInserting) {
      context.missing(_booruJsonMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DownloadTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DownloadTableTable createAlias(String alias) {
    return $DownloadTableTable(_db, alias);
  }
}

class HistoryTableData extends DataClass
    implements Insertable<HistoryTableData> {
  final int id;
  final String history;
  final int type;
  final DateTime createTime;
  HistoryTableData(
      {required this.id,
      required this.history,
      required this.type,
      required this.createTime});
  factory HistoryTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return HistoryTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      history: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}history'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      createTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['history'] = Variable<String>(history);
    map['type'] = Variable<int>(type);
    map['create_time'] = Variable<DateTime>(createTime);
    return map;
  }

  HistoryTableCompanion toCompanion(bool nullToAbsent) {
    return HistoryTableCompanion(
      id: Value(id),
      history: Value(history),
      type: Value(type),
      createTime: Value(createTime),
    );
  }

  factory HistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return HistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      history: serializer.fromJson<String>(json['history']),
      type: serializer.fromJson<int>(json['type']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'history': serializer.toJson<String>(history),
      'type': serializer.toJson<int>(type),
      'createTime': serializer.toJson<DateTime>(createTime),
    };
  }

  HistoryTableData copyWith(
          {int? id, String? history, int? type, DateTime? createTime}) =>
      HistoryTableData(
        id: id ?? this.id,
        history: history ?? this.history,
        type: type ?? this.type,
        createTime: createTime ?? this.createTime,
      );
  @override
  String toString() {
    return (StringBuffer('HistoryTableData(')
          ..write('id: $id, ')
          ..write('history: $history, ')
          ..write('type: $type, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(history.hashCode, $mrjc(type.hashCode, createTime.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryTableData &&
          other.id == this.id &&
          other.history == this.history &&
          other.type == this.type &&
          other.createTime == this.createTime);
}

class HistoryTableCompanion extends UpdateCompanion<HistoryTableData> {
  final Value<int> id;
  final Value<String> history;
  final Value<int> type;
  final Value<DateTime> createTime;
  const HistoryTableCompanion({
    this.id = const Value.absent(),
    this.history = const Value.absent(),
    this.type = const Value.absent(),
    this.createTime = const Value.absent(),
  });
  HistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String history,
    required int type,
    this.createTime = const Value.absent(),
  })  : history = Value(history),
        type = Value(type);
  static Insertable<HistoryTableData> custom({
    Expression<int>? id,
    Expression<String>? history,
    Expression<int>? type,
    Expression<DateTime>? createTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (history != null) 'history': history,
      if (type != null) 'type': type,
      if (createTime != null) 'create_time': createTime,
    });
  }

  HistoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? history,
      Value<int>? type,
      Value<DateTime>? createTime}) {
    return HistoryTableCompanion(
      id: id ?? this.id,
      history: history ?? this.history,
      type: type ?? this.type,
      createTime: createTime ?? this.createTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (history.present) {
      map['history'] = Variable<String>(history.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('history: $history, ')
          ..write('type: $type, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }
}

class $HistoryTableTable extends HistoryTable
    with TableInfo<$HistoryTableTable, HistoryTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $HistoryTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _historyMeta = const VerificationMeta('history');
  late final GeneratedColumn<String?> history = GeneratedColumn<String?>(
      'history', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  late final GeneratedColumn<DateTime?> createTime = GeneratedColumn<DateTime?>(
      'create_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, history, type, createTime];
  @override
  String get aliasedName => _alias ?? 'history_table';
  @override
  String get actualTableName => 'history_table';
  @override
  VerificationContext validateIntegrity(Insertable<HistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('history')) {
      context.handle(_historyMeta,
          history.isAcceptableOrUnknown(data['history']!, _historyMeta));
    } else if (isInserting) {
      context.missing(_historyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return HistoryTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HistoryTableTable createAlias(String alias) {
    return $HistoryTableTable(_db, alias);
  }
}

class HostTableData extends DataClass implements Insertable<HostTableData> {
  final int id;
  final String host;
  final String ip;
  final int websiteId;
  HostTableData(
      {required this.id,
      required this.host,
      required this.ip,
      required this.websiteId});
  factory HostTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return HostTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      host: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}host'])!,
      ip: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ip'])!,
      websiteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}website_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['host'] = Variable<String>(host);
    map['ip'] = Variable<String>(ip);
    map['website_id'] = Variable<int>(websiteId);
    return map;
  }

  HostTableCompanion toCompanion(bool nullToAbsent) {
    return HostTableCompanion(
      id: Value(id),
      host: Value(host),
      ip: Value(ip),
      websiteId: Value(websiteId),
    );
  }

  factory HostTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return HostTableData(
      id: serializer.fromJson<int>(json['id']),
      host: serializer.fromJson<String>(json['host']),
      ip: serializer.fromJson<String>(json['ip']),
      websiteId: serializer.fromJson<int>(json['websiteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'host': serializer.toJson<String>(host),
      'ip': serializer.toJson<String>(ip),
      'websiteId': serializer.toJson<int>(websiteId),
    };
  }

  HostTableData copyWith({int? id, String? host, String? ip, int? websiteId}) =>
      HostTableData(
        id: id ?? this.id,
        host: host ?? this.host,
        ip: ip ?? this.ip,
        websiteId: websiteId ?? this.websiteId,
      );
  @override
  String toString() {
    return (StringBuffer('HostTableData(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('ip: $ip, ')
          ..write('websiteId: $websiteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(host.hashCode, $mrjc(ip.hashCode, websiteId.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HostTableData &&
          other.id == this.id &&
          other.host == this.host &&
          other.ip == this.ip &&
          other.websiteId == this.websiteId);
}

class HostTableCompanion extends UpdateCompanion<HostTableData> {
  final Value<int> id;
  final Value<String> host;
  final Value<String> ip;
  final Value<int> websiteId;
  const HostTableCompanion({
    this.id = const Value.absent(),
    this.host = const Value.absent(),
    this.ip = const Value.absent(),
    this.websiteId = const Value.absent(),
  });
  HostTableCompanion.insert({
    this.id = const Value.absent(),
    required String host,
    required String ip,
    required int websiteId,
  })  : host = Value(host),
        ip = Value(ip),
        websiteId = Value(websiteId);
  static Insertable<HostTableData> custom({
    Expression<int>? id,
    Expression<String>? host,
    Expression<String>? ip,
    Expression<int>? websiteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (host != null) 'host': host,
      if (ip != null) 'ip': ip,
      if (websiteId != null) 'website_id': websiteId,
    });
  }

  HostTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? host,
      Value<String>? ip,
      Value<int>? websiteId}) {
    return HostTableCompanion(
      id: id ?? this.id,
      host: host ?? this.host,
      ip: ip ?? this.ip,
      websiteId: websiteId ?? this.websiteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    if (websiteId.present) {
      map['website_id'] = Variable<int>(websiteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HostTableCompanion(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('ip: $ip, ')
          ..write('websiteId: $websiteId')
          ..write(')'))
        .toString();
  }
}

class $HostTableTable extends HostTable
    with TableInfo<$HostTableTable, HostTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $HostTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _hostMeta = const VerificationMeta('host');
  late final GeneratedColumn<String?> host = GeneratedColumn<String?>(
      'host', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _ipMeta = const VerificationMeta('ip');
  late final GeneratedColumn<String?> ip = GeneratedColumn<String?>(
      'ip', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _websiteIdMeta = const VerificationMeta('websiteId');
  late final GeneratedColumn<int?> websiteId = GeneratedColumn<int?>(
      'website_id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, host, ip, websiteId];
  @override
  String get aliasedName => _alias ?? 'host_table';
  @override
  String get actualTableName => 'host_table';
  @override
  VerificationContext validateIntegrity(Insertable<HostTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('host')) {
      context.handle(
          _hostMeta, host.isAcceptableOrUnknown(data['host']!, _hostMeta));
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip']!, _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    if (data.containsKey('website_id')) {
      context.handle(_websiteIdMeta,
          websiteId.isAcceptableOrUnknown(data['website_id']!, _websiteIdMeta));
    } else if (isInserting) {
      context.missing(_websiteIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HostTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return HostTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HostTableTable createAlias(String alias) {
    return $HostTableTable(_db, alias);
  }
}

class TagTableData extends DataClass implements Insertable<TagTableData> {
  final int website;
  final String tag;
  TagTableData({required this.website, required this.tag});
  factory TagTableData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TagTableData(
      website: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}website'])!,
      tag: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tag'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['website'] = Variable<int>(website);
    map['tag'] = Variable<String>(tag);
    return map;
  }

  TagTableCompanion toCompanion(bool nullToAbsent) {
    return TagTableCompanion(
      website: Value(website),
      tag: Value(tag),
    );
  }

  factory TagTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TagTableData(
      website: serializer.fromJson<int>(json['website']),
      tag: serializer.fromJson<String>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'website': serializer.toJson<int>(website),
      'tag': serializer.toJson<String>(tag),
    };
  }

  TagTableData copyWith({int? website, String? tag}) => TagTableData(
        website: website ?? this.website,
        tag: tag ?? this.tag,
      );
  @override
  String toString() {
    return (StringBuffer('TagTableData(')
          ..write('website: $website, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(website.hashCode, tag.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagTableData &&
          other.website == this.website &&
          other.tag == this.tag);
}

class TagTableCompanion extends UpdateCompanion<TagTableData> {
  final Value<int> website;
  final Value<String> tag;
  const TagTableCompanion({
    this.website = const Value.absent(),
    this.tag = const Value.absent(),
  });
  TagTableCompanion.insert({
    required int website,
    required String tag,
  })  : website = Value(website),
        tag = Value(tag);
  static Insertable<TagTableData> custom({
    Expression<int>? website,
    Expression<String>? tag,
  }) {
    return RawValuesInsertable({
      if (website != null) 'website': website,
      if (tag != null) 'tag': tag,
    });
  }

  TagTableCompanion copyWith({Value<int>? website, Value<String>? tag}) {
    return TagTableCompanion(
      website: website ?? this.website,
      tag: tag ?? this.tag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (website.present) {
      map['website'] = Variable<int>(website.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagTableCompanion(')
          ..write('website: $website, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }
}

class $TagTableTable extends TagTable
    with TableInfo<$TagTableTable, TagTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TagTableTable(this._db, [this._alias]);
  final VerificationMeta _websiteMeta = const VerificationMeta('website');
  late final GeneratedColumn<int?> website = GeneratedColumn<int?>(
      'website', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _tagMeta = const VerificationMeta('tag');
  late final GeneratedColumn<String?> tag = GeneratedColumn<String?>(
      'tag', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [website, tag];
  @override
  String get aliasedName => _alias ?? 'tag_table';
  @override
  String get actualTableName => 'tag_table';
  @override
  VerificationContext validateIntegrity(Insertable<TagTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('website')) {
      context.handle(_websiteMeta,
          website.isAcceptableOrUnknown(data['website']!, _websiteMeta));
    } else if (isInserting) {
      context.missing(_websiteMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tag};
  @override
  TagTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TagTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TagTableTable createAlias(String alias) {
    return $TagTableTable(_db, alias);
  }
}

class WebsiteTableData extends DataClass
    implements Insertable<WebsiteTableData> {
  final int id;
  final String name;
  final String host;
  final int scheme;
  final int type;
  final bool useDoH;
  final bool onlyHost;
  final bool directLink;
  final String cookies;
  final Uint8List favicon;
  final String? username;
  final String? password;
  final int lastOpen;
  final Uint8List? storage;
  WebsiteTableData(
      {required this.id,
      required this.name,
      required this.host,
      required this.scheme,
      required this.type,
      required this.useDoH,
      required this.onlyHost,
      required this.directLink,
      required this.cookies,
      required this.favicon,
      this.username,
      this.password,
      required this.lastOpen,
      this.storage});
  factory WebsiteTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WebsiteTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      host: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}host'])!,
      scheme: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scheme'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      useDoH: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}use_do_h'])!,
      onlyHost: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}only_host'])!,
      directLink: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}direct_link'])!,
      cookies: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cookies'])!,
      favicon: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}favicon'])!,
      username: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}username']),
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      lastOpen: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_open'])!,
      storage: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}storage']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['host'] = Variable<String>(host);
    map['scheme'] = Variable<int>(scheme);
    map['type'] = Variable<int>(type);
    map['use_do_h'] = Variable<bool>(useDoH);
    map['only_host'] = Variable<bool>(onlyHost);
    map['direct_link'] = Variable<bool>(directLink);
    map['cookies'] = Variable<String>(cookies);
    map['favicon'] = Variable<Uint8List>(favicon);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String?>(username);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String?>(password);
    }
    map['last_open'] = Variable<int>(lastOpen);
    if (!nullToAbsent || storage != null) {
      map['storage'] = Variable<Uint8List?>(storage);
    }
    return map;
  }

  WebsiteTableCompanion toCompanion(bool nullToAbsent) {
    return WebsiteTableCompanion(
      id: Value(id),
      name: Value(name),
      host: Value(host),
      scheme: Value(scheme),
      type: Value(type),
      useDoH: Value(useDoH),
      onlyHost: Value(onlyHost),
      directLink: Value(directLink),
      cookies: Value(cookies),
      favicon: Value(favicon),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      lastOpen: Value(lastOpen),
      storage: storage == null && nullToAbsent
          ? const Value.absent()
          : Value(storage),
    );
  }

  factory WebsiteTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return WebsiteTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      host: serializer.fromJson<String>(json['host']),
      scheme: serializer.fromJson<int>(json['scheme']),
      type: serializer.fromJson<int>(json['type']),
      useDoH: serializer.fromJson<bool>(json['useDoH']),
      onlyHost: serializer.fromJson<bool>(json['onlyHost']),
      directLink: serializer.fromJson<bool>(json['directLink']),
      cookies: serializer.fromJson<String>(json['cookies']),
      favicon: serializer.fromJson<Uint8List>(json['favicon']),
      username: serializer.fromJson<String?>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      lastOpen: serializer.fromJson<int>(json['lastOpen']),
      storage: serializer.fromJson<Uint8List?>(json['storage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'host': serializer.toJson<String>(host),
      'scheme': serializer.toJson<int>(scheme),
      'type': serializer.toJson<int>(type),
      'useDoH': serializer.toJson<bool>(useDoH),
      'onlyHost': serializer.toJson<bool>(onlyHost),
      'directLink': serializer.toJson<bool>(directLink),
      'cookies': serializer.toJson<String>(cookies),
      'favicon': serializer.toJson<Uint8List>(favicon),
      'username': serializer.toJson<String?>(username),
      'password': serializer.toJson<String?>(password),
      'lastOpen': serializer.toJson<int>(lastOpen),
      'storage': serializer.toJson<Uint8List?>(storage),
    };
  }

  WebsiteTableData copyWith(
          {int? id,
          String? name,
          String? host,
          int? scheme,
          int? type,
          bool? useDoH,
          bool? onlyHost,
          bool? directLink,
          String? cookies,
          Uint8List? favicon,
          String? username,
          String? password,
          int? lastOpen,
          Uint8List? storage}) =>
      WebsiteTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        host: host ?? this.host,
        scheme: scheme ?? this.scheme,
        type: type ?? this.type,
        useDoH: useDoH ?? this.useDoH,
        onlyHost: onlyHost ?? this.onlyHost,
        directLink: directLink ?? this.directLink,
        cookies: cookies ?? this.cookies,
        favicon: favicon ?? this.favicon,
        username: username ?? this.username,
        password: password ?? this.password,
        lastOpen: lastOpen ?? this.lastOpen,
        storage: storage ?? this.storage,
      );
  @override
  String toString() {
    return (StringBuffer('WebsiteTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('host: $host, ')
          ..write('scheme: $scheme, ')
          ..write('type: $type, ')
          ..write('useDoH: $useDoH, ')
          ..write('onlyHost: $onlyHost, ')
          ..write('directLink: $directLink, ')
          ..write('cookies: $cookies, ')
          ..write('favicon: $favicon, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('lastOpen: $lastOpen, ')
          ..write('storage: $storage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              host.hashCode,
              $mrjc(
                  scheme.hashCode,
                  $mrjc(
                      type.hashCode,
                      $mrjc(
                          useDoH.hashCode,
                          $mrjc(
                              onlyHost.hashCode,
                              $mrjc(
                                  directLink.hashCode,
                                  $mrjc(
                                      cookies.hashCode,
                                      $mrjc(
                                          favicon.hashCode,
                                          $mrjc(
                                              username.hashCode,
                                              $mrjc(
                                                  password.hashCode,
                                                  $mrjc(
                                                      lastOpen.hashCode,
                                                      storage
                                                          .hashCode))))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WebsiteTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.host == this.host &&
          other.scheme == this.scheme &&
          other.type == this.type &&
          other.useDoH == this.useDoH &&
          other.onlyHost == this.onlyHost &&
          other.directLink == this.directLink &&
          other.cookies == this.cookies &&
          other.favicon == this.favicon &&
          other.username == this.username &&
          other.password == this.password &&
          other.lastOpen == this.lastOpen &&
          other.storage == this.storage);
}

class WebsiteTableCompanion extends UpdateCompanion<WebsiteTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> host;
  final Value<int> scheme;
  final Value<int> type;
  final Value<bool> useDoH;
  final Value<bool> onlyHost;
  final Value<bool> directLink;
  final Value<String> cookies;
  final Value<Uint8List> favicon;
  final Value<String?> username;
  final Value<String?> password;
  final Value<int> lastOpen;
  final Value<Uint8List?> storage;
  const WebsiteTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.host = const Value.absent(),
    this.scheme = const Value.absent(),
    this.type = const Value.absent(),
    this.useDoH = const Value.absent(),
    this.onlyHost = const Value.absent(),
    this.directLink = const Value.absent(),
    this.cookies = const Value.absent(),
    this.favicon = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.lastOpen = const Value.absent(),
    this.storage = const Value.absent(),
  });
  WebsiteTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String host,
    required int scheme,
    required int type,
    required bool useDoH,
    required bool onlyHost,
    required bool directLink,
    this.cookies = const Value.absent(),
    this.favicon = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.lastOpen = const Value.absent(),
    this.storage = const Value.absent(),
  })  : name = Value(name),
        host = Value(host),
        scheme = Value(scheme),
        type = Value(type),
        useDoH = Value(useDoH),
        onlyHost = Value(onlyHost),
        directLink = Value(directLink);
  static Insertable<WebsiteTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? host,
    Expression<int>? scheme,
    Expression<int>? type,
    Expression<bool>? useDoH,
    Expression<bool>? onlyHost,
    Expression<bool>? directLink,
    Expression<String>? cookies,
    Expression<Uint8List>? favicon,
    Expression<String?>? username,
    Expression<String?>? password,
    Expression<int>? lastOpen,
    Expression<Uint8List?>? storage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (host != null) 'host': host,
      if (scheme != null) 'scheme': scheme,
      if (type != null) 'type': type,
      if (useDoH != null) 'use_do_h': useDoH,
      if (onlyHost != null) 'only_host': onlyHost,
      if (directLink != null) 'direct_link': directLink,
      if (cookies != null) 'cookies': cookies,
      if (favicon != null) 'favicon': favicon,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (lastOpen != null) 'last_open': lastOpen,
      if (storage != null) 'storage': storage,
    });
  }

  WebsiteTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? host,
      Value<int>? scheme,
      Value<int>? type,
      Value<bool>? useDoH,
      Value<bool>? onlyHost,
      Value<bool>? directLink,
      Value<String>? cookies,
      Value<Uint8List>? favicon,
      Value<String?>? username,
      Value<String?>? password,
      Value<int>? lastOpen,
      Value<Uint8List?>? storage}) {
    return WebsiteTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      scheme: scheme ?? this.scheme,
      type: type ?? this.type,
      useDoH: useDoH ?? this.useDoH,
      onlyHost: onlyHost ?? this.onlyHost,
      directLink: directLink ?? this.directLink,
      cookies: cookies ?? this.cookies,
      favicon: favicon ?? this.favicon,
      username: username ?? this.username,
      password: password ?? this.password,
      lastOpen: lastOpen ?? this.lastOpen,
      storage: storage ?? this.storage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (scheme.present) {
      map['scheme'] = Variable<int>(scheme.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (useDoH.present) {
      map['use_do_h'] = Variable<bool>(useDoH.value);
    }
    if (onlyHost.present) {
      map['only_host'] = Variable<bool>(onlyHost.value);
    }
    if (directLink.present) {
      map['direct_link'] = Variable<bool>(directLink.value);
    }
    if (cookies.present) {
      map['cookies'] = Variable<String>(cookies.value);
    }
    if (favicon.present) {
      map['favicon'] = Variable<Uint8List>(favicon.value);
    }
    if (username.present) {
      map['username'] = Variable<String?>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String?>(password.value);
    }
    if (lastOpen.present) {
      map['last_open'] = Variable<int>(lastOpen.value);
    }
    if (storage.present) {
      map['storage'] = Variable<Uint8List?>(storage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WebsiteTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('host: $host, ')
          ..write('scheme: $scheme, ')
          ..write('type: $type, ')
          ..write('useDoH: $useDoH, ')
          ..write('onlyHost: $onlyHost, ')
          ..write('directLink: $directLink, ')
          ..write('cookies: $cookies, ')
          ..write('favicon: $favicon, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('lastOpen: $lastOpen, ')
          ..write('storage: $storage')
          ..write(')'))
        .toString();
  }
}

class $WebsiteTableTable extends WebsiteTable
    with TableInfo<$WebsiteTableTable, WebsiteTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WebsiteTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _hostMeta = const VerificationMeta('host');
  late final GeneratedColumn<String?> host = GeneratedColumn<String?>(
      'host', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _schemeMeta = const VerificationMeta('scheme');
  late final GeneratedColumn<int?> scheme = GeneratedColumn<int?>(
      'scheme', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _useDoHMeta = const VerificationMeta('useDoH');
  late final GeneratedColumn<bool?> useDoH = GeneratedColumn<bool?>(
      'use_do_h', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (use_do_h IN (0, 1))');
  final VerificationMeta _onlyHostMeta = const VerificationMeta('onlyHost');
  late final GeneratedColumn<bool?> onlyHost = GeneratedColumn<bool?>(
      'only_host', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (only_host IN (0, 1))');
  final VerificationMeta _directLinkMeta = const VerificationMeta('directLink');
  late final GeneratedColumn<bool?> directLink = GeneratedColumn<bool?>(
      'direct_link', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (direct_link IN (0, 1))');
  final VerificationMeta _cookiesMeta = const VerificationMeta('cookies');
  late final GeneratedColumn<String?> cookies = GeneratedColumn<String?>(
      'cookies', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  final VerificationMeta _faviconMeta = const VerificationMeta('favicon');
  late final GeneratedColumn<Uint8List?> favicon = GeneratedColumn<Uint8List?>(
      'favicon', aliasedName, false,
      typeName: 'BLOB',
      requiredDuringInsert: false,
      clientDefault: () => Uint8List.fromList([]));
  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  late final GeneratedColumn<String?> username = GeneratedColumn<String?>(
      'username', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _lastOpenMeta = const VerificationMeta('lastOpen');
  late final GeneratedColumn<int?> lastOpen = GeneratedColumn<int?>(
      'last_open', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().microsecond);
  final VerificationMeta _storageMeta = const VerificationMeta('storage');
  late final GeneratedColumn<Uint8List?> storage = GeneratedColumn<Uint8List?>(
      'storage', aliasedName, true,
      typeName: 'BLOB', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        host,
        scheme,
        type,
        useDoH,
        onlyHost,
        directLink,
        cookies,
        favicon,
        username,
        password,
        lastOpen,
        storage
      ];
  @override
  String get aliasedName => _alias ?? 'website_table';
  @override
  String get actualTableName => 'website_table';
  @override
  VerificationContext validateIntegrity(Insertable<WebsiteTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
          _hostMeta, host.isAcceptableOrUnknown(data['host']!, _hostMeta));
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('scheme')) {
      context.handle(_schemeMeta,
          scheme.isAcceptableOrUnknown(data['scheme']!, _schemeMeta));
    } else if (isInserting) {
      context.missing(_schemeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('use_do_h')) {
      context.handle(_useDoHMeta,
          useDoH.isAcceptableOrUnknown(data['use_do_h']!, _useDoHMeta));
    } else if (isInserting) {
      context.missing(_useDoHMeta);
    }
    if (data.containsKey('only_host')) {
      context.handle(_onlyHostMeta,
          onlyHost.isAcceptableOrUnknown(data['only_host']!, _onlyHostMeta));
    } else if (isInserting) {
      context.missing(_onlyHostMeta);
    }
    if (data.containsKey('direct_link')) {
      context.handle(
          _directLinkMeta,
          directLink.isAcceptableOrUnknown(
              data['direct_link']!, _directLinkMeta));
    } else if (isInserting) {
      context.missing(_directLinkMeta);
    }
    if (data.containsKey('cookies')) {
      context.handle(_cookiesMeta,
          cookies.isAcceptableOrUnknown(data['cookies']!, _cookiesMeta));
    }
    if (data.containsKey('favicon')) {
      context.handle(_faviconMeta,
          favicon.isAcceptableOrUnknown(data['favicon']!, _faviconMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('last_open')) {
      context.handle(_lastOpenMeta,
          lastOpen.isAcceptableOrUnknown(data['last_open']!, _lastOpenMeta));
    }
    if (data.containsKey('storage')) {
      context.handle(_storageMeta,
          storage.isAcceptableOrUnknown(data['storage']!, _storageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WebsiteTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WebsiteTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WebsiteTableTable createAlias(String alias) {
    return $WebsiteTableTable(_db, alias);
  }
}

class EhTranslateTableData extends DataClass
    implements Insertable<EhTranslateTableData> {
  final int id;
  final String namespace;
  final String name;
  final String translate;
  final String link;
  EhTranslateTableData(
      {required this.id,
      required this.namespace,
      required this.name,
      required this.translate,
      required this.link});
  factory EhTranslateTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhTranslateTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      namespace: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}namespace'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      translate: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}translate'])!,
      link: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}link'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['namespace'] = Variable<String>(namespace);
    map['name'] = Variable<String>(name);
    map['translate'] = Variable<String>(translate);
    map['link'] = Variable<String>(link);
    return map;
  }

  EhTranslateTableCompanion toCompanion(bool nullToAbsent) {
    return EhTranslateTableCompanion(
      id: Value(id),
      namespace: Value(namespace),
      name: Value(name),
      translate: Value(translate),
      link: Value(link),
    );
  }

  factory EhTranslateTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhTranslateTableData(
      id: serializer.fromJson<int>(json['id']),
      namespace: serializer.fromJson<String>(json['namespace']),
      name: serializer.fromJson<String>(json['name']),
      translate: serializer.fromJson<String>(json['translate']),
      link: serializer.fromJson<String>(json['link']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'namespace': serializer.toJson<String>(namespace),
      'name': serializer.toJson<String>(name),
      'translate': serializer.toJson<String>(translate),
      'link': serializer.toJson<String>(link),
    };
  }

  EhTranslateTableData copyWith(
          {int? id,
          String? namespace,
          String? name,
          String? translate,
          String? link}) =>
      EhTranslateTableData(
        id: id ?? this.id,
        namespace: namespace ?? this.namespace,
        name: name ?? this.name,
        translate: translate ?? this.translate,
        link: link ?? this.link,
      );
  @override
  String toString() {
    return (StringBuffer('EhTranslateTableData(')
          ..write('id: $id, ')
          ..write('namespace: $namespace, ')
          ..write('name: $name, ')
          ..write('translate: $translate, ')
          ..write('link: $link')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(namespace.hashCode,
          $mrjc(name.hashCode, $mrjc(translate.hashCode, link.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhTranslateTableData &&
          other.id == this.id &&
          other.namespace == this.namespace &&
          other.name == this.name &&
          other.translate == this.translate &&
          other.link == this.link);
}

class EhTranslateTableCompanion extends UpdateCompanion<EhTranslateTableData> {
  final Value<int> id;
  final Value<String> namespace;
  final Value<String> name;
  final Value<String> translate;
  final Value<String> link;
  const EhTranslateTableCompanion({
    this.id = const Value.absent(),
    this.namespace = const Value.absent(),
    this.name = const Value.absent(),
    this.translate = const Value.absent(),
    this.link = const Value.absent(),
  });
  EhTranslateTableCompanion.insert({
    this.id = const Value.absent(),
    required String namespace,
    required String name,
    required String translate,
    required String link,
  })  : namespace = Value(namespace),
        name = Value(name),
        translate = Value(translate),
        link = Value(link);
  static Insertable<EhTranslateTableData> custom({
    Expression<int>? id,
    Expression<String>? namespace,
    Expression<String>? name,
    Expression<String>? translate,
    Expression<String>? link,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namespace != null) 'namespace': namespace,
      if (name != null) 'name': name,
      if (translate != null) 'translate': translate,
      if (link != null) 'link': link,
    });
  }

  EhTranslateTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? namespace,
      Value<String>? name,
      Value<String>? translate,
      Value<String>? link}) {
    return EhTranslateTableCompanion(
      id: id ?? this.id,
      namespace: namespace ?? this.namespace,
      name: name ?? this.name,
      translate: translate ?? this.translate,
      link: link ?? this.link,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (namespace.present) {
      map['namespace'] = Variable<String>(namespace.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (translate.present) {
      map['translate'] = Variable<String>(translate.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhTranslateTableCompanion(')
          ..write('id: $id, ')
          ..write('namespace: $namespace, ')
          ..write('name: $name, ')
          ..write('translate: $translate, ')
          ..write('link: $link')
          ..write(')'))
        .toString();
  }
}

class $EhTranslateTableTable extends EhTranslateTable
    with TableInfo<$EhTranslateTableTable, EhTranslateTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhTranslateTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _namespaceMeta = const VerificationMeta('namespace');
  late final GeneratedColumn<String?> namespace = GeneratedColumn<String?>(
      'namespace', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _translateMeta = const VerificationMeta('translate');
  late final GeneratedColumn<String?> translate = GeneratedColumn<String?>(
      'translate', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _linkMeta = const VerificationMeta('link');
  late final GeneratedColumn<String?> link = GeneratedColumn<String?>(
      'link', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, namespace, name, translate, link];
  @override
  String get aliasedName => _alias ?? 'eh_translate_table';
  @override
  String get actualTableName => 'eh_translate_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EhTranslateTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('namespace')) {
      context.handle(_namespaceMeta,
          namespace.isAcceptableOrUnknown(data['namespace']!, _namespaceMeta));
    } else if (isInserting) {
      context.missing(_namespaceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('translate')) {
      context.handle(_translateMeta,
          translate.isAcceptableOrUnknown(data['translate']!, _translateMeta));
    } else if (isInserting) {
      context.missing(_translateMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
          _linkMeta, link.isAcceptableOrUnknown(data['link']!, _linkMeta));
    } else if (isInserting) {
      context.missing(_linkMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EhTranslateTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EhTranslateTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhTranslateTableTable createAlias(String alias) {
    return $EhTranslateTableTable(_db, alias);
  }
}

class GalleryCacheTableData extends DataClass
    implements Insertable<GalleryCacheTableData> {
  final String gid;
  final String token;
  final int cacheTime;
  final Uint8List data;
  GalleryCacheTableData(
      {required this.gid,
      required this.token,
      required this.cacheTime,
      required this.data});
  factory GalleryCacheTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return GalleryCacheTableData(
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      token: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}token'])!,
      cacheTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cache_time'])!,
      data: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gid'] = Variable<String>(gid);
    map['token'] = Variable<String>(token);
    map['cache_time'] = Variable<int>(cacheTime);
    map['data'] = Variable<Uint8List>(data);
    return map;
  }

  GalleryCacheTableCompanion toCompanion(bool nullToAbsent) {
    return GalleryCacheTableCompanion(
      gid: Value(gid),
      token: Value(token),
      cacheTime: Value(cacheTime),
      data: Value(data),
    );
  }

  factory GalleryCacheTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GalleryCacheTableData(
      gid: serializer.fromJson<String>(json['gid']),
      token: serializer.fromJson<String>(json['token']),
      cacheTime: serializer.fromJson<int>(json['cacheTime']),
      data: serializer.fromJson<Uint8List>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gid': serializer.toJson<String>(gid),
      'token': serializer.toJson<String>(token),
      'cacheTime': serializer.toJson<int>(cacheTime),
      'data': serializer.toJson<Uint8List>(data),
    };
  }

  GalleryCacheTableData copyWith(
          {String? gid, String? token, int? cacheTime, Uint8List? data}) =>
      GalleryCacheTableData(
        gid: gid ?? this.gid,
        token: token ?? this.token,
        cacheTime: cacheTime ?? this.cacheTime,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('GalleryCacheTableData(')
          ..write('gid: $gid, ')
          ..write('token: $token, ')
          ..write('cacheTime: $cacheTime, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(gid.hashCode,
      $mrjc(token.hashCode, $mrjc(cacheTime.hashCode, data.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GalleryCacheTableData &&
          other.gid == this.gid &&
          other.token == this.token &&
          other.cacheTime == this.cacheTime &&
          other.data == this.data);
}

class GalleryCacheTableCompanion
    extends UpdateCompanion<GalleryCacheTableData> {
  final Value<String> gid;
  final Value<String> token;
  final Value<int> cacheTime;
  final Value<Uint8List> data;
  const GalleryCacheTableCompanion({
    this.gid = const Value.absent(),
    this.token = const Value.absent(),
    this.cacheTime = const Value.absent(),
    this.data = const Value.absent(),
  });
  GalleryCacheTableCompanion.insert({
    required String gid,
    required String token,
    this.cacheTime = const Value.absent(),
    required Uint8List data,
  })  : gid = Value(gid),
        token = Value(token),
        data = Value(data);
  static Insertable<GalleryCacheTableData> custom({
    Expression<String>? gid,
    Expression<String>? token,
    Expression<int>? cacheTime,
    Expression<Uint8List>? data,
  }) {
    return RawValuesInsertable({
      if (gid != null) 'gid': gid,
      if (token != null) 'token': token,
      if (cacheTime != null) 'cache_time': cacheTime,
      if (data != null) 'data': data,
    });
  }

  GalleryCacheTableCompanion copyWith(
      {Value<String>? gid,
      Value<String>? token,
      Value<int>? cacheTime,
      Value<Uint8List>? data}) {
    return GalleryCacheTableCompanion(
      gid: gid ?? this.gid,
      token: token ?? this.token,
      cacheTime: cacheTime ?? this.cacheTime,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (cacheTime.present) {
      map['cache_time'] = Variable<int>(cacheTime.value);
    }
    if (data.present) {
      map['data'] = Variable<Uint8List>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GalleryCacheTableCompanion(')
          ..write('gid: $gid, ')
          ..write('token: $token, ')
          ..write('cacheTime: $cacheTime, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $GalleryCacheTableTable extends GalleryCacheTable
    with TableInfo<$GalleryCacheTableTable, GalleryCacheTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $GalleryCacheTableTable(this._db, [this._alias]);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  late final GeneratedColumn<String?> token = GeneratedColumn<String?>(
      'token', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _cacheTimeMeta = const VerificationMeta('cacheTime');
  late final GeneratedColumn<int?> cacheTime = GeneratedColumn<int?>(
      'cache_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecond);
  final VerificationMeta _dataMeta = const VerificationMeta('data');
  late final GeneratedColumn<Uint8List?> data = GeneratedColumn<Uint8List?>(
      'data', aliasedName, false,
      typeName: 'BLOB', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [gid, token, cacheTime, data];
  @override
  String get aliasedName => _alias ?? 'gallery_cache_table';
  @override
  String get actualTableName => 'gallery_cache_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<GalleryCacheTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('cache_time')) {
      context.handle(_cacheTimeMeta,
          cacheTime.isAcceptableOrUnknown(data['cache_time']!, _cacheTimeMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gid, token};
  @override
  GalleryCacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return GalleryCacheTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GalleryCacheTableTable createAlias(String alias) {
    return $GalleryCacheTableTable(_db, alias);
  }
}

class EhGalleryHistoryTableData extends DataClass
    implements Insertable<EhGalleryHistoryTableData> {
  final String gid;
  final String gtoken;
  final int lastViewTime;

  /// [PreViewItemModel]
  final Uint8List pb;
  EhGalleryHistoryTableData(
      {required this.gid,
      required this.gtoken,
      required this.lastViewTime,
      required this.pb});
  factory EhGalleryHistoryTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhGalleryHistoryTableData(
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      gtoken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gtoken'])!,
      lastViewTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_view_time'])!,
      pb: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pb'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gid'] = Variable<String>(gid);
    map['gtoken'] = Variable<String>(gtoken);
    map['last_view_time'] = Variable<int>(lastViewTime);
    map['pb'] = Variable<Uint8List>(pb);
    return map;
  }

  EhGalleryHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return EhGalleryHistoryTableCompanion(
      gid: Value(gid),
      gtoken: Value(gtoken),
      lastViewTime: Value(lastViewTime),
      pb: Value(pb),
    );
  }

  factory EhGalleryHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhGalleryHistoryTableData(
      gid: serializer.fromJson<String>(json['gid']),
      gtoken: serializer.fromJson<String>(json['gtoken']),
      lastViewTime: serializer.fromJson<int>(json['lastViewTime']),
      pb: serializer.fromJson<Uint8List>(json['pb']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gid': serializer.toJson<String>(gid),
      'gtoken': serializer.toJson<String>(gtoken),
      'lastViewTime': serializer.toJson<int>(lastViewTime),
      'pb': serializer.toJson<Uint8List>(pb),
    };
  }

  EhGalleryHistoryTableData copyWith(
          {String? gid, String? gtoken, int? lastViewTime, Uint8List? pb}) =>
      EhGalleryHistoryTableData(
        gid: gid ?? this.gid,
        gtoken: gtoken ?? this.gtoken,
        lastViewTime: lastViewTime ?? this.lastViewTime,
        pb: pb ?? this.pb,
      );
  @override
  String toString() {
    return (StringBuffer('EhGalleryHistoryTableData(')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('lastViewTime: $lastViewTime, ')
          ..write('pb: $pb')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(gid.hashCode,
      $mrjc(gtoken.hashCode, $mrjc(lastViewTime.hashCode, pb.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhGalleryHistoryTableData &&
          other.gid == this.gid &&
          other.gtoken == this.gtoken &&
          other.lastViewTime == this.lastViewTime &&
          other.pb == this.pb);
}

class EhGalleryHistoryTableCompanion
    extends UpdateCompanion<EhGalleryHistoryTableData> {
  final Value<String> gid;
  final Value<String> gtoken;
  final Value<int> lastViewTime;
  final Value<Uint8List> pb;
  const EhGalleryHistoryTableCompanion({
    this.gid = const Value.absent(),
    this.gtoken = const Value.absent(),
    this.lastViewTime = const Value.absent(),
    this.pb = const Value.absent(),
  });
  EhGalleryHistoryTableCompanion.insert({
    required String gid,
    required String gtoken,
    this.lastViewTime = const Value.absent(),
    required Uint8List pb,
  })  : gid = Value(gid),
        gtoken = Value(gtoken),
        pb = Value(pb);
  static Insertable<EhGalleryHistoryTableData> custom({
    Expression<String>? gid,
    Expression<String>? gtoken,
    Expression<int>? lastViewTime,
    Expression<Uint8List>? pb,
  }) {
    return RawValuesInsertable({
      if (gid != null) 'gid': gid,
      if (gtoken != null) 'gtoken': gtoken,
      if (lastViewTime != null) 'last_view_time': lastViewTime,
      if (pb != null) 'pb': pb,
    });
  }

  EhGalleryHistoryTableCompanion copyWith(
      {Value<String>? gid,
      Value<String>? gtoken,
      Value<int>? lastViewTime,
      Value<Uint8List>? pb}) {
    return EhGalleryHistoryTableCompanion(
      gid: gid ?? this.gid,
      gtoken: gtoken ?? this.gtoken,
      lastViewTime: lastViewTime ?? this.lastViewTime,
      pb: pb ?? this.pb,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (gtoken.present) {
      map['gtoken'] = Variable<String>(gtoken.value);
    }
    if (lastViewTime.present) {
      map['last_view_time'] = Variable<int>(lastViewTime.value);
    }
    if (pb.present) {
      map['pb'] = Variable<Uint8List>(pb.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhGalleryHistoryTableCompanion(')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('lastViewTime: $lastViewTime, ')
          ..write('pb: $pb')
          ..write(')'))
        .toString();
  }
}

class $EhGalleryHistoryTableTable extends EhGalleryHistoryTable
    with TableInfo<$EhGalleryHistoryTableTable, EhGalleryHistoryTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhGalleryHistoryTableTable(this._db, [this._alias]);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _gtokenMeta = const VerificationMeta('gtoken');
  late final GeneratedColumn<String?> gtoken = GeneratedColumn<String?>(
      'gtoken', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _lastViewTimeMeta =
      const VerificationMeta('lastViewTime');
  late final GeneratedColumn<int?> lastViewTime = GeneratedColumn<int?>(
      'last_view_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecond);
  final VerificationMeta _pbMeta = const VerificationMeta('pb');
  late final GeneratedColumn<Uint8List?> pb = GeneratedColumn<Uint8List?>(
      'pb', aliasedName, false,
      typeName: 'BLOB', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [gid, gtoken, lastViewTime, pb];
  @override
  String get aliasedName => _alias ?? 'eh_gallery_history_table';
  @override
  String get actualTableName => 'eh_gallery_history_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EhGalleryHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('gtoken')) {
      context.handle(_gtokenMeta,
          gtoken.isAcceptableOrUnknown(data['gtoken']!, _gtokenMeta));
    } else if (isInserting) {
      context.missing(_gtokenMeta);
    }
    if (data.containsKey('last_view_time')) {
      context.handle(
          _lastViewTimeMeta,
          lastViewTime.isAcceptableOrUnknown(
              data['last_view_time']!, _lastViewTimeMeta));
    }
    if (data.containsKey('pb')) {
      context.handle(_pbMeta, pb.isAcceptableOrUnknown(data['pb']!, _pbMeta));
    } else if (isInserting) {
      context.missing(_pbMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gid, gtoken};
  @override
  EhGalleryHistoryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    return EhGalleryHistoryTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhGalleryHistoryTableTable createAlias(String alias) {
    return $EhGalleryHistoryTableTable(_db, alias);
  }
}

class EhDownloadTableData extends DataClass
    implements Insertable<EhDownloadTableData> {
  final int id;
  final int createTime;
  final int websiteId;
  final int status;
  final int pageTotal;
  final int pageDownload;
  final String gid;
  final String gtoken;
  final Uint8List galleryPb;
  EhDownloadTableData(
      {required this.id,
      required this.createTime,
      required this.websiteId,
      required this.status,
      required this.pageTotal,
      required this.pageDownload,
      required this.gid,
      required this.gtoken,
      required this.galleryPb});
  factory EhDownloadTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhDownloadTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time'])!,
      websiteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}website_id'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      pageTotal: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}page_total'])!,
      pageDownload: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}page_download'])!,
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      gtoken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gtoken'])!,
      galleryPb: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gallery_pb'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['create_time'] = Variable<int>(createTime);
    map['website_id'] = Variable<int>(websiteId);
    map['status'] = Variable<int>(status);
    map['page_total'] = Variable<int>(pageTotal);
    map['page_download'] = Variable<int>(pageDownload);
    map['gid'] = Variable<String>(gid);
    map['gtoken'] = Variable<String>(gtoken);
    map['gallery_pb'] = Variable<Uint8List>(galleryPb);
    return map;
  }

  EhDownloadTableCompanion toCompanion(bool nullToAbsent) {
    return EhDownloadTableCompanion(
      id: Value(id),
      createTime: Value(createTime),
      websiteId: Value(websiteId),
      status: Value(status),
      pageTotal: Value(pageTotal),
      pageDownload: Value(pageDownload),
      gid: Value(gid),
      gtoken: Value(gtoken),
      galleryPb: Value(galleryPb),
    );
  }

  factory EhDownloadTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhDownloadTableData(
      id: serializer.fromJson<int>(json['id']),
      createTime: serializer.fromJson<int>(json['createTime']),
      websiteId: serializer.fromJson<int>(json['websiteId']),
      status: serializer.fromJson<int>(json['status']),
      pageTotal: serializer.fromJson<int>(json['pageTotal']),
      pageDownload: serializer.fromJson<int>(json['pageDownload']),
      gid: serializer.fromJson<String>(json['gid']),
      gtoken: serializer.fromJson<String>(json['gtoken']),
      galleryPb: serializer.fromJson<Uint8List>(json['galleryPb']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createTime': serializer.toJson<int>(createTime),
      'websiteId': serializer.toJson<int>(websiteId),
      'status': serializer.toJson<int>(status),
      'pageTotal': serializer.toJson<int>(pageTotal),
      'pageDownload': serializer.toJson<int>(pageDownload),
      'gid': serializer.toJson<String>(gid),
      'gtoken': serializer.toJson<String>(gtoken),
      'galleryPb': serializer.toJson<Uint8List>(galleryPb),
    };
  }

  EhDownloadTableData copyWith(
          {int? id,
          int? createTime,
          int? websiteId,
          int? status,
          int? pageTotal,
          int? pageDownload,
          String? gid,
          String? gtoken,
          Uint8List? galleryPb}) =>
      EhDownloadTableData(
        id: id ?? this.id,
        createTime: createTime ?? this.createTime,
        websiteId: websiteId ?? this.websiteId,
        status: status ?? this.status,
        pageTotal: pageTotal ?? this.pageTotal,
        pageDownload: pageDownload ?? this.pageDownload,
        gid: gid ?? this.gid,
        gtoken: gtoken ?? this.gtoken,
        galleryPb: galleryPb ?? this.galleryPb,
      );
  @override
  String toString() {
    return (StringBuffer('EhDownloadTableData(')
          ..write('id: $id, ')
          ..write('createTime: $createTime, ')
          ..write('websiteId: $websiteId, ')
          ..write('status: $status, ')
          ..write('pageTotal: $pageTotal, ')
          ..write('pageDownload: $pageDownload, ')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('galleryPb: $galleryPb')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          createTime.hashCode,
          $mrjc(
              websiteId.hashCode,
              $mrjc(
                  status.hashCode,
                  $mrjc(
                      pageTotal.hashCode,
                      $mrjc(
                          pageDownload.hashCode,
                          $mrjc(
                              gid.hashCode,
                              $mrjc(
                                  gtoken.hashCode, galleryPb.hashCode)))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhDownloadTableData &&
          other.id == this.id &&
          other.createTime == this.createTime &&
          other.websiteId == this.websiteId &&
          other.status == this.status &&
          other.pageTotal == this.pageTotal &&
          other.pageDownload == this.pageDownload &&
          other.gid == this.gid &&
          other.gtoken == this.gtoken &&
          other.galleryPb == this.galleryPb);
}

class EhDownloadTableCompanion extends UpdateCompanion<EhDownloadTableData> {
  final Value<int> id;
  final Value<int> createTime;
  final Value<int> websiteId;
  final Value<int> status;
  final Value<int> pageTotal;
  final Value<int> pageDownload;
  final Value<String> gid;
  final Value<String> gtoken;
  final Value<Uint8List> galleryPb;
  const EhDownloadTableCompanion({
    this.id = const Value.absent(),
    this.createTime = const Value.absent(),
    this.websiteId = const Value.absent(),
    this.status = const Value.absent(),
    this.pageTotal = const Value.absent(),
    this.pageDownload = const Value.absent(),
    this.gid = const Value.absent(),
    this.gtoken = const Value.absent(),
    this.galleryPb = const Value.absent(),
  });
  EhDownloadTableCompanion.insert({
    this.id = const Value.absent(),
    this.createTime = const Value.absent(),
    required int websiteId,
    required int status,
    required int pageTotal,
    required int pageDownload,
    required String gid,
    required String gtoken,
    required Uint8List galleryPb,
  })  : websiteId = Value(websiteId),
        status = Value(status),
        pageTotal = Value(pageTotal),
        pageDownload = Value(pageDownload),
        gid = Value(gid),
        gtoken = Value(gtoken),
        galleryPb = Value(galleryPb);
  static Insertable<EhDownloadTableData> custom({
    Expression<int>? id,
    Expression<int>? createTime,
    Expression<int>? websiteId,
    Expression<int>? status,
    Expression<int>? pageTotal,
    Expression<int>? pageDownload,
    Expression<String>? gid,
    Expression<String>? gtoken,
    Expression<Uint8List>? galleryPb,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createTime != null) 'create_time': createTime,
      if (websiteId != null) 'website_id': websiteId,
      if (status != null) 'status': status,
      if (pageTotal != null) 'page_total': pageTotal,
      if (pageDownload != null) 'page_download': pageDownload,
      if (gid != null) 'gid': gid,
      if (gtoken != null) 'gtoken': gtoken,
      if (galleryPb != null) 'gallery_pb': galleryPb,
    });
  }

  EhDownloadTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? createTime,
      Value<int>? websiteId,
      Value<int>? status,
      Value<int>? pageTotal,
      Value<int>? pageDownload,
      Value<String>? gid,
      Value<String>? gtoken,
      Value<Uint8List>? galleryPb}) {
    return EhDownloadTableCompanion(
      id: id ?? this.id,
      createTime: createTime ?? this.createTime,
      websiteId: websiteId ?? this.websiteId,
      status: status ?? this.status,
      pageTotal: pageTotal ?? this.pageTotal,
      pageDownload: pageDownload ?? this.pageDownload,
      gid: gid ?? this.gid,
      gtoken: gtoken ?? this.gtoken,
      galleryPb: galleryPb ?? this.galleryPb,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<int>(createTime.value);
    }
    if (websiteId.present) {
      map['website_id'] = Variable<int>(websiteId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (pageTotal.present) {
      map['page_total'] = Variable<int>(pageTotal.value);
    }
    if (pageDownload.present) {
      map['page_download'] = Variable<int>(pageDownload.value);
    }
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (gtoken.present) {
      map['gtoken'] = Variable<String>(gtoken.value);
    }
    if (galleryPb.present) {
      map['gallery_pb'] = Variable<Uint8List>(galleryPb.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhDownloadTableCompanion(')
          ..write('id: $id, ')
          ..write('createTime: $createTime, ')
          ..write('websiteId: $websiteId, ')
          ..write('status: $status, ')
          ..write('pageTotal: $pageTotal, ')
          ..write('pageDownload: $pageDownload, ')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('galleryPb: $galleryPb')
          ..write(')'))
        .toString();
  }
}

class $EhDownloadTableTable extends EhDownloadTable
    with TableInfo<$EhDownloadTableTable, EhDownloadTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhDownloadTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  late final GeneratedColumn<int?> createTime = GeneratedColumn<int?>(
      'create_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecond);
  final VerificationMeta _websiteIdMeta = const VerificationMeta('websiteId');
  late final GeneratedColumn<int?> websiteId = GeneratedColumn<int?>(
      'website_id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _pageTotalMeta = const VerificationMeta('pageTotal');
  late final GeneratedColumn<int?> pageTotal = GeneratedColumn<int?>(
      'page_total', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _pageDownloadMeta =
      const VerificationMeta('pageDownload');
  late final GeneratedColumn<int?> pageDownload = GeneratedColumn<int?>(
      'page_download', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _gtokenMeta = const VerificationMeta('gtoken');
  late final GeneratedColumn<String?> gtoken = GeneratedColumn<String?>(
      'gtoken', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _galleryPbMeta = const VerificationMeta('galleryPb');
  late final GeneratedColumn<Uint8List?> galleryPb =
      GeneratedColumn<Uint8List?>('gallery_pb', aliasedName, false,
          typeName: 'BLOB', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createTime,
        websiteId,
        status,
        pageTotal,
        pageDownload,
        gid,
        gtoken,
        galleryPb
      ];
  @override
  String get aliasedName => _alias ?? 'eh_download_table';
  @override
  String get actualTableName => 'eh_download_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EhDownloadTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    if (data.containsKey('website_id')) {
      context.handle(_websiteIdMeta,
          websiteId.isAcceptableOrUnknown(data['website_id']!, _websiteIdMeta));
    } else if (isInserting) {
      context.missing(_websiteIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('page_total')) {
      context.handle(_pageTotalMeta,
          pageTotal.isAcceptableOrUnknown(data['page_total']!, _pageTotalMeta));
    } else if (isInserting) {
      context.missing(_pageTotalMeta);
    }
    if (data.containsKey('page_download')) {
      context.handle(
          _pageDownloadMeta,
          pageDownload.isAcceptableOrUnknown(
              data['page_download']!, _pageDownloadMeta));
    } else if (isInserting) {
      context.missing(_pageDownloadMeta);
    }
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('gtoken')) {
      context.handle(_gtokenMeta,
          gtoken.isAcceptableOrUnknown(data['gtoken']!, _gtokenMeta));
    } else if (isInserting) {
      context.missing(_gtokenMeta);
    }
    if (data.containsKey('gallery_pb')) {
      context.handle(_galleryPbMeta,
          galleryPb.isAcceptableOrUnknown(data['gallery_pb']!, _galleryPbMeta));
    } else if (isInserting) {
      context.missing(_galleryPbMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EhDownloadTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EhDownloadTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhDownloadTableTable createAlias(String alias) {
    return $EhDownloadTableTable(_db, alias);
  }
}

class EhDownloadShaTableData extends DataClass
    implements Insertable<EhDownloadShaTableData> {
  final int id;
  final String sha;
  final String gid;
  final int index;
  EhDownloadShaTableData(
      {required this.id,
      required this.sha,
      required this.gid,
      required this.index});
  factory EhDownloadShaTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhDownloadShaTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      sha: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sha'])!,
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      index: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}index'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sha'] = Variable<String>(sha);
    map['gid'] = Variable<String>(gid);
    map['index'] = Variable<int>(index);
    return map;
  }

  EhDownloadShaTableCompanion toCompanion(bool nullToAbsent) {
    return EhDownloadShaTableCompanion(
      id: Value(id),
      sha: Value(sha),
      gid: Value(gid),
      index: Value(index),
    );
  }

  factory EhDownloadShaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhDownloadShaTableData(
      id: serializer.fromJson<int>(json['id']),
      sha: serializer.fromJson<String>(json['sha']),
      gid: serializer.fromJson<String>(json['gid']),
      index: serializer.fromJson<int>(json['index']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sha': serializer.toJson<String>(sha),
      'gid': serializer.toJson<String>(gid),
      'index': serializer.toJson<int>(index),
    };
  }

  EhDownloadShaTableData copyWith(
          {int? id, String? sha, String? gid, int? index}) =>
      EhDownloadShaTableData(
        id: id ?? this.id,
        sha: sha ?? this.sha,
        gid: gid ?? this.gid,
        index: index ?? this.index,
      );
  @override
  String toString() {
    return (StringBuffer('EhDownloadShaTableData(')
          ..write('id: $id, ')
          ..write('sha: $sha, ')
          ..write('gid: $gid, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode, $mrjc(sha.hashCode, $mrjc(gid.hashCode, index.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhDownloadShaTableData &&
          other.id == this.id &&
          other.sha == this.sha &&
          other.gid == this.gid &&
          other.index == this.index);
}

class EhDownloadShaTableCompanion
    extends UpdateCompanion<EhDownloadShaTableData> {
  final Value<int> id;
  final Value<String> sha;
  final Value<String> gid;
  final Value<int> index;
  const EhDownloadShaTableCompanion({
    this.id = const Value.absent(),
    this.sha = const Value.absent(),
    this.gid = const Value.absent(),
    this.index = const Value.absent(),
  });
  EhDownloadShaTableCompanion.insert({
    this.id = const Value.absent(),
    required String sha,
    required String gid,
    required int index,
  })  : sha = Value(sha),
        gid = Value(gid),
        index = Value(index);
  static Insertable<EhDownloadShaTableData> custom({
    Expression<int>? id,
    Expression<String>? sha,
    Expression<String>? gid,
    Expression<int>? index,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sha != null) 'sha': sha,
      if (gid != null) 'gid': gid,
      if (index != null) 'index': index,
    });
  }

  EhDownloadShaTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? sha,
      Value<String>? gid,
      Value<int>? index}) {
    return EhDownloadShaTableCompanion(
      id: id ?? this.id,
      sha: sha ?? this.sha,
      gid: gid ?? this.gid,
      index: index ?? this.index,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sha.present) {
      map['sha'] = Variable<String>(sha.value);
    }
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhDownloadShaTableCompanion(')
          ..write('id: $id, ')
          ..write('sha: $sha, ')
          ..write('gid: $gid, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }
}

class $EhDownloadShaTableTable extends EhDownloadShaTable
    with TableInfo<$EhDownloadShaTableTable, EhDownloadShaTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhDownloadShaTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _shaMeta = const VerificationMeta('sha');
  late final GeneratedColumn<String?> sha = GeneratedColumn<String?>(
      'sha', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _indexMeta = const VerificationMeta('index');
  late final GeneratedColumn<int?> index = GeneratedColumn<int?>(
      'index', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sha, gid, index];
  @override
  String get aliasedName => _alias ?? 'eh_download_sha_table';
  @override
  String get actualTableName => 'eh_download_sha_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EhDownloadShaTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sha')) {
      context.handle(
          _shaMeta, sha.isAcceptableOrUnknown(data['sha']!, _shaMeta));
    } else if (isInserting) {
      context.missing(_shaMeta);
    }
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EhDownloadShaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EhDownloadShaTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhDownloadShaTableTable createAlias(String alias) {
    return $EhDownloadShaTableTable(_db, alias);
  }
}

class EhReadHistoryTableData extends DataClass
    implements Insertable<EhReadHistoryTableData> {
  final String gid;
  final String gtoken;
  final int readPage;
  EhReadHistoryTableData(
      {required this.gid, required this.gtoken, required this.readPage});
  factory EhReadHistoryTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhReadHistoryTableData(
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      gtoken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gtoken'])!,
      readPage: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}read_page'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gid'] = Variable<String>(gid);
    map['gtoken'] = Variable<String>(gtoken);
    map['read_page'] = Variable<int>(readPage);
    return map;
  }

  EhReadHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return EhReadHistoryTableCompanion(
      gid: Value(gid),
      gtoken: Value(gtoken),
      readPage: Value(readPage),
    );
  }

  factory EhReadHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhReadHistoryTableData(
      gid: serializer.fromJson<String>(json['gid']),
      gtoken: serializer.fromJson<String>(json['gtoken']),
      readPage: serializer.fromJson<int>(json['readPage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gid': serializer.toJson<String>(gid),
      'gtoken': serializer.toJson<String>(gtoken),
      'readPage': serializer.toJson<int>(readPage),
    };
  }

  EhReadHistoryTableData copyWith(
          {String? gid, String? gtoken, int? readPage}) =>
      EhReadHistoryTableData(
        gid: gid ?? this.gid,
        gtoken: gtoken ?? this.gtoken,
        readPage: readPage ?? this.readPage,
      );
  @override
  String toString() {
    return (StringBuffer('EhReadHistoryTableData(')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('readPage: $readPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(gid.hashCode, $mrjc(gtoken.hashCode, readPage.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhReadHistoryTableData &&
          other.gid == this.gid &&
          other.gtoken == this.gtoken &&
          other.readPage == this.readPage);
}

class EhReadHistoryTableCompanion
    extends UpdateCompanion<EhReadHistoryTableData> {
  final Value<String> gid;
  final Value<String> gtoken;
  final Value<int> readPage;
  const EhReadHistoryTableCompanion({
    this.gid = const Value.absent(),
    this.gtoken = const Value.absent(),
    this.readPage = const Value.absent(),
  });
  EhReadHistoryTableCompanion.insert({
    required String gid,
    required String gtoken,
    required int readPage,
  })  : gid = Value(gid),
        gtoken = Value(gtoken),
        readPage = Value(readPage);
  static Insertable<EhReadHistoryTableData> custom({
    Expression<String>? gid,
    Expression<String>? gtoken,
    Expression<int>? readPage,
  }) {
    return RawValuesInsertable({
      if (gid != null) 'gid': gid,
      if (gtoken != null) 'gtoken': gtoken,
      if (readPage != null) 'read_page': readPage,
    });
  }

  EhReadHistoryTableCompanion copyWith(
      {Value<String>? gid, Value<String>? gtoken, Value<int>? readPage}) {
    return EhReadHistoryTableCompanion(
      gid: gid ?? this.gid,
      gtoken: gtoken ?? this.gtoken,
      readPage: readPage ?? this.readPage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (gtoken.present) {
      map['gtoken'] = Variable<String>(gtoken.value);
    }
    if (readPage.present) {
      map['read_page'] = Variable<int>(readPage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhReadHistoryTableCompanion(')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('readPage: $readPage')
          ..write(')'))
        .toString();
  }
}

class $EhReadHistoryTableTable extends EhReadHistoryTable
    with TableInfo<$EhReadHistoryTableTable, EhReadHistoryTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhReadHistoryTableTable(this._db, [this._alias]);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _gtokenMeta = const VerificationMeta('gtoken');
  late final GeneratedColumn<String?> gtoken = GeneratedColumn<String?>(
      'gtoken', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _readPageMeta = const VerificationMeta('readPage');
  late final GeneratedColumn<int?> readPage = GeneratedColumn<int?>(
      'read_page', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [gid, gtoken, readPage];
  @override
  String get aliasedName => _alias ?? 'eh_read_history_table';
  @override
  String get actualTableName => 'eh_read_history_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EhReadHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('gtoken')) {
      context.handle(_gtokenMeta,
          gtoken.isAcceptableOrUnknown(data['gtoken']!, _gtokenMeta));
    } else if (isInserting) {
      context.missing(_gtokenMeta);
    }
    if (data.containsKey('read_page')) {
      context.handle(_readPageMeta,
          readPage.isAcceptableOrUnknown(data['read_page']!, _readPageMeta));
    } else if (isInserting) {
      context.missing(_readPageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gid, gtoken};
  @override
  EhReadHistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EhReadHistoryTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhReadHistoryTableTable createAlias(String alias) {
    return $EhReadHistoryTableTable(_db, alias);
  }
}

class EhGalleryPreviewImgCacheData extends DataClass
    implements Insertable<EhGalleryPreviewImgCacheData> {
  final String gid;
  final String gtoken;
  final int index;
  final Uint8List pb;
  final int cacheTime;
  EhGalleryPreviewImgCacheData(
      {required this.gid,
      required this.gtoken,
      required this.index,
      required this.pb,
      required this.cacheTime});
  factory EhGalleryPreviewImgCacheData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhGalleryPreviewImgCacheData(
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      gtoken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gtoken'])!,
      index: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}index'])!,
      pb: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pb'])!,
      cacheTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cache_time'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gid'] = Variable<String>(gid);
    map['gtoken'] = Variable<String>(gtoken);
    map['index'] = Variable<int>(index);
    map['pb'] = Variable<Uint8List>(pb);
    map['cache_time'] = Variable<int>(cacheTime);
    return map;
  }

  EhGalleryPreviewImgCacheCompanion toCompanion(bool nullToAbsent) {
    return EhGalleryPreviewImgCacheCompanion(
      gid: Value(gid),
      gtoken: Value(gtoken),
      index: Value(index),
      pb: Value(pb),
      cacheTime: Value(cacheTime),
    );
  }

  factory EhGalleryPreviewImgCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhGalleryPreviewImgCacheData(
      gid: serializer.fromJson<String>(json['gid']),
      gtoken: serializer.fromJson<String>(json['gtoken']),
      index: serializer.fromJson<int>(json['index']),
      pb: serializer.fromJson<Uint8List>(json['pb']),
      cacheTime: serializer.fromJson<int>(json['cacheTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gid': serializer.toJson<String>(gid),
      'gtoken': serializer.toJson<String>(gtoken),
      'index': serializer.toJson<int>(index),
      'pb': serializer.toJson<Uint8List>(pb),
      'cacheTime': serializer.toJson<int>(cacheTime),
    };
  }

  EhGalleryPreviewImgCacheData copyWith(
          {String? gid,
          String? gtoken,
          int? index,
          Uint8List? pb,
          int? cacheTime}) =>
      EhGalleryPreviewImgCacheData(
        gid: gid ?? this.gid,
        gtoken: gtoken ?? this.gtoken,
        index: index ?? this.index,
        pb: pb ?? this.pb,
        cacheTime: cacheTime ?? this.cacheTime,
      );
  @override
  String toString() {
    return (StringBuffer('EhGalleryPreviewImgCacheData(')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('index: $index, ')
          ..write('pb: $pb, ')
          ..write('cacheTime: $cacheTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      gid.hashCode,
      $mrjc(gtoken.hashCode,
          $mrjc(index.hashCode, $mrjc(pb.hashCode, cacheTime.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhGalleryPreviewImgCacheData &&
          other.gid == this.gid &&
          other.gtoken == this.gtoken &&
          other.index == this.index &&
          other.pb == this.pb &&
          other.cacheTime == this.cacheTime);
}

class EhGalleryPreviewImgCacheCompanion
    extends UpdateCompanion<EhGalleryPreviewImgCacheData> {
  final Value<String> gid;
  final Value<String> gtoken;
  final Value<int> index;
  final Value<Uint8List> pb;
  final Value<int> cacheTime;
  const EhGalleryPreviewImgCacheCompanion({
    this.gid = const Value.absent(),
    this.gtoken = const Value.absent(),
    this.index = const Value.absent(),
    this.pb = const Value.absent(),
    this.cacheTime = const Value.absent(),
  });
  EhGalleryPreviewImgCacheCompanion.insert({
    required String gid,
    required String gtoken,
    required int index,
    required Uint8List pb,
    this.cacheTime = const Value.absent(),
  })  : gid = Value(gid),
        gtoken = Value(gtoken),
        index = Value(index),
        pb = Value(pb);
  static Insertable<EhGalleryPreviewImgCacheData> custom({
    Expression<String>? gid,
    Expression<String>? gtoken,
    Expression<int>? index,
    Expression<Uint8List>? pb,
    Expression<int>? cacheTime,
  }) {
    return RawValuesInsertable({
      if (gid != null) 'gid': gid,
      if (gtoken != null) 'gtoken': gtoken,
      if (index != null) 'index': index,
      if (pb != null) 'pb': pb,
      if (cacheTime != null) 'cache_time': cacheTime,
    });
  }

  EhGalleryPreviewImgCacheCompanion copyWith(
      {Value<String>? gid,
      Value<String>? gtoken,
      Value<int>? index,
      Value<Uint8List>? pb,
      Value<int>? cacheTime}) {
    return EhGalleryPreviewImgCacheCompanion(
      gid: gid ?? this.gid,
      gtoken: gtoken ?? this.gtoken,
      index: index ?? this.index,
      pb: pb ?? this.pb,
      cacheTime: cacheTime ?? this.cacheTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (gtoken.present) {
      map['gtoken'] = Variable<String>(gtoken.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (pb.present) {
      map['pb'] = Variable<Uint8List>(pb.value);
    }
    if (cacheTime.present) {
      map['cache_time'] = Variable<int>(cacheTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhGalleryPreviewImgCacheCompanion(')
          ..write('gid: $gid, ')
          ..write('gtoken: $gtoken, ')
          ..write('index: $index, ')
          ..write('pb: $pb, ')
          ..write('cacheTime: $cacheTime')
          ..write(')'))
        .toString();
  }
}

class $EhGalleryPreviewImgCacheTable extends EhGalleryPreviewImgCache
    with
        TableInfo<$EhGalleryPreviewImgCacheTable,
            EhGalleryPreviewImgCacheData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhGalleryPreviewImgCacheTable(this._db, [this._alias]);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _gtokenMeta = const VerificationMeta('gtoken');
  late final GeneratedColumn<String?> gtoken = GeneratedColumn<String?>(
      'gtoken', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _indexMeta = const VerificationMeta('index');
  late final GeneratedColumn<int?> index = GeneratedColumn<int?>(
      'index', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _pbMeta = const VerificationMeta('pb');
  late final GeneratedColumn<Uint8List?> pb = GeneratedColumn<Uint8List?>(
      'pb', aliasedName, false,
      typeName: 'BLOB', requiredDuringInsert: true);
  final VerificationMeta _cacheTimeMeta = const VerificationMeta('cacheTime');
  late final GeneratedColumn<int?> cacheTime = GeneratedColumn<int?>(
      'cache_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecond);
  @override
  List<GeneratedColumn> get $columns => [gid, gtoken, index, pb, cacheTime];
  @override
  String get aliasedName => _alias ?? 'eh_gallery_preview_img_cache';
  @override
  String get actualTableName => 'eh_gallery_preview_img_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<EhGalleryPreviewImgCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('gtoken')) {
      context.handle(_gtokenMeta,
          gtoken.isAcceptableOrUnknown(data['gtoken']!, _gtokenMeta));
    } else if (isInserting) {
      context.missing(_gtokenMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('pb')) {
      context.handle(_pbMeta, pb.isAcceptableOrUnknown(data['pb']!, _pbMeta));
    } else if (isInserting) {
      context.missing(_pbMeta);
    }
    if (data.containsKey('cache_time')) {
      context.handle(_cacheTimeMeta,
          cacheTime.isAcceptableOrUnknown(data['cache_time']!, _cacheTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  EhGalleryPreviewImgCacheData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    return EhGalleryPreviewImgCacheData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhGalleryPreviewImgCacheTable createAlias(String alias) {
    return $EhGalleryPreviewImgCacheTable(_db, alias);
  }
}

class EhImageCacheData extends DataClass
    implements Insertable<EhImageCacheData> {
  final String shaToken;
  final String gid;
  final int page;
  final Uint8List pb;
  final int lastViewTime;
  EhImageCacheData(
      {required this.shaToken,
      required this.gid,
      required this.page,
      required this.pb,
      required this.lastViewTime});
  factory EhImageCacheData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EhImageCacheData(
      shaToken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sha_token'])!,
      gid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gid'])!,
      page: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}page'])!,
      pb: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pb'])!,
      lastViewTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_view_time'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sha_token'] = Variable<String>(shaToken);
    map['gid'] = Variable<String>(gid);
    map['page'] = Variable<int>(page);
    map['pb'] = Variable<Uint8List>(pb);
    map['last_view_time'] = Variable<int>(lastViewTime);
    return map;
  }

  EhImageCacheCompanion toCompanion(bool nullToAbsent) {
    return EhImageCacheCompanion(
      shaToken: Value(shaToken),
      gid: Value(gid),
      page: Value(page),
      pb: Value(pb),
      lastViewTime: Value(lastViewTime),
    );
  }

  factory EhImageCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return EhImageCacheData(
      shaToken: serializer.fromJson<String>(json['shaToken']),
      gid: serializer.fromJson<String>(json['gid']),
      page: serializer.fromJson<int>(json['page']),
      pb: serializer.fromJson<Uint8List>(json['pb']),
      lastViewTime: serializer.fromJson<int>(json['lastViewTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shaToken': serializer.toJson<String>(shaToken),
      'gid': serializer.toJson<String>(gid),
      'page': serializer.toJson<int>(page),
      'pb': serializer.toJson<Uint8List>(pb),
      'lastViewTime': serializer.toJson<int>(lastViewTime),
    };
  }

  EhImageCacheData copyWith(
          {String? shaToken,
          String? gid,
          int? page,
          Uint8List? pb,
          int? lastViewTime}) =>
      EhImageCacheData(
        shaToken: shaToken ?? this.shaToken,
        gid: gid ?? this.gid,
        page: page ?? this.page,
        pb: pb ?? this.pb,
        lastViewTime: lastViewTime ?? this.lastViewTime,
      );
  @override
  String toString() {
    return (StringBuffer('EhImageCacheData(')
          ..write('shaToken: $shaToken, ')
          ..write('gid: $gid, ')
          ..write('page: $page, ')
          ..write('pb: $pb, ')
          ..write('lastViewTime: $lastViewTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      shaToken.hashCode,
      $mrjc(gid.hashCode,
          $mrjc(page.hashCode, $mrjc(pb.hashCode, lastViewTime.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EhImageCacheData &&
          other.shaToken == this.shaToken &&
          other.gid == this.gid &&
          other.page == this.page &&
          other.pb == this.pb &&
          other.lastViewTime == this.lastViewTime);
}

class EhImageCacheCompanion extends UpdateCompanion<EhImageCacheData> {
  final Value<String> shaToken;
  final Value<String> gid;
  final Value<int> page;
  final Value<Uint8List> pb;
  final Value<int> lastViewTime;
  const EhImageCacheCompanion({
    this.shaToken = const Value.absent(),
    this.gid = const Value.absent(),
    this.page = const Value.absent(),
    this.pb = const Value.absent(),
    this.lastViewTime = const Value.absent(),
  });
  EhImageCacheCompanion.insert({
    required String shaToken,
    required String gid,
    required int page,
    required Uint8List pb,
    this.lastViewTime = const Value.absent(),
  })  : shaToken = Value(shaToken),
        gid = Value(gid),
        page = Value(page),
        pb = Value(pb);
  static Insertable<EhImageCacheData> custom({
    Expression<String>? shaToken,
    Expression<String>? gid,
    Expression<int>? page,
    Expression<Uint8List>? pb,
    Expression<int>? lastViewTime,
  }) {
    return RawValuesInsertable({
      if (shaToken != null) 'sha_token': shaToken,
      if (gid != null) 'gid': gid,
      if (page != null) 'page': page,
      if (pb != null) 'pb': pb,
      if (lastViewTime != null) 'last_view_time': lastViewTime,
    });
  }

  EhImageCacheCompanion copyWith(
      {Value<String>? shaToken,
      Value<String>? gid,
      Value<int>? page,
      Value<Uint8List>? pb,
      Value<int>? lastViewTime}) {
    return EhImageCacheCompanion(
      shaToken: shaToken ?? this.shaToken,
      gid: gid ?? this.gid,
      page: page ?? this.page,
      pb: pb ?? this.pb,
      lastViewTime: lastViewTime ?? this.lastViewTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shaToken.present) {
      map['sha_token'] = Variable<String>(shaToken.value);
    }
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (pb.present) {
      map['pb'] = Variable<Uint8List>(pb.value);
    }
    if (lastViewTime.present) {
      map['last_view_time'] = Variable<int>(lastViewTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EhImageCacheCompanion(')
          ..write('shaToken: $shaToken, ')
          ..write('gid: $gid, ')
          ..write('page: $page, ')
          ..write('pb: $pb, ')
          ..write('lastViewTime: $lastViewTime')
          ..write(')'))
        .toString();
  }
}

class $EhImageCacheTable extends EhImageCache
    with TableInfo<$EhImageCacheTable, EhImageCacheData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EhImageCacheTable(this._db, [this._alias]);
  final VerificationMeta _shaTokenMeta = const VerificationMeta('shaToken');
  late final GeneratedColumn<String?> shaToken = GeneratedColumn<String?>(
      'sha_token', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _gidMeta = const VerificationMeta('gid');
  late final GeneratedColumn<String?> gid = GeneratedColumn<String?>(
      'gid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _pageMeta = const VerificationMeta('page');
  late final GeneratedColumn<int?> page = GeneratedColumn<int?>(
      'page', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _pbMeta = const VerificationMeta('pb');
  late final GeneratedColumn<Uint8List?> pb = GeneratedColumn<Uint8List?>(
      'pb', aliasedName, false,
      typeName: 'BLOB', requiredDuringInsert: true);
  final VerificationMeta _lastViewTimeMeta =
      const VerificationMeta('lastViewTime');
  late final GeneratedColumn<int?> lastViewTime = GeneratedColumn<int?>(
      'last_view_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecond);
  @override
  List<GeneratedColumn> get $columns => [shaToken, gid, page, pb, lastViewTime];
  @override
  String get aliasedName => _alias ?? 'eh_image_cache';
  @override
  String get actualTableName => 'eh_image_cache';
  @override
  VerificationContext validateIntegrity(Insertable<EhImageCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sha_token')) {
      context.handle(_shaTokenMeta,
          shaToken.isAcceptableOrUnknown(data['sha_token']!, _shaTokenMeta));
    } else if (isInserting) {
      context.missing(_shaTokenMeta);
    }
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('pb')) {
      context.handle(_pbMeta, pb.isAcceptableOrUnknown(data['pb']!, _pbMeta));
    } else if (isInserting) {
      context.missing(_pbMeta);
    }
    if (data.containsKey('last_view_time')) {
      context.handle(
          _lastViewTimeMeta,
          lastViewTime.isAcceptableOrUnknown(
              data['last_view_time']!, _lastViewTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shaToken, gid};
  @override
  EhImageCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EhImageCacheData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EhImageCacheTable createAlias(String alias) {
    return $EhImageCacheTable(_db, alias);
  }
}

abstract class _$AppDataBase extends GeneratedDatabase {
  _$AppDataBase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $DownloadTableTable downloadTable = $DownloadTableTable(this);
  late final $HistoryTableTable historyTable = $HistoryTableTable(this);
  late final $HostTableTable hostTable = $HostTableTable(this);
  late final $TagTableTable tagTable = $TagTableTable(this);
  late final $WebsiteTableTable websiteTable = $WebsiteTableTable(this);
  late final $EhTranslateTableTable ehTranslateTable =
      $EhTranslateTableTable(this);
  late final $GalleryCacheTableTable galleryCacheTable =
      $GalleryCacheTableTable(this);
  late final $EhGalleryHistoryTableTable ehGalleryHistoryTable =
      $EhGalleryHistoryTableTable(this);
  late final $EhDownloadTableTable ehDownloadTable =
      $EhDownloadTableTable(this);
  late final $EhDownloadShaTableTable ehDownloadShaTable =
      $EhDownloadShaTableTable(this);
  late final $EhReadHistoryTableTable ehReadHistoryTable =
      $EhReadHistoryTableTable(this);
  late final $EhGalleryPreviewImgCacheTable ehGalleryPreviewImgCache =
      $EhGalleryPreviewImgCacheTable(this);
  late final $EhImageCacheTable ehImageCache = $EhImageCacheTable(this);
  late final DownloadDao downloadDao = DownloadDao(this as AppDataBase);
  late final HistoryDao historyDao = HistoryDao(this as AppDataBase);
  late final HostDao hostDao = HostDao(this as AppDataBase);
  late final TagDao tagDao = TagDao(this as AppDataBase);
  late final WebsiteDao websiteDao = WebsiteDao(this as AppDataBase);
  late final TranslateDao translateDao = TranslateDao(this as AppDataBase);
  late final GalleryCacheDao galleryCacheDao =
      GalleryCacheDao(this as AppDataBase);
  late final GalleryHistoryDao galleryHistoryDao =
      GalleryHistoryDao(this as AppDataBase);
  late final EhReadHistoryDao ehReadHistoryDao =
      EhReadHistoryDao(this as AppDataBase);
  late final EhDownloadDao ehDownloadDao = EhDownloadDao(this as AppDataBase);
  late final EhImageDao ehImageDao = EhImageDao(this as AppDataBase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        downloadTable,
        historyTable,
        hostTable,
        tagTable,
        websiteTable,
        ehTranslateTable,
        galleryCacheTable,
        ehGalleryHistoryTable,
        ehDownloadTable,
        ehDownloadShaTable,
        ehReadHistoryTable,
        ehGalleryPreviewImgCache,
        ehImageCache
      ];
}
