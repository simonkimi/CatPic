# CatPic


# 介绍
CatPic是一款聚合图片软件, 可以采集多个网站的图片

支持列表如下
- [x] Gelbooru
- [x] Moebooru
- [x] Danbooru
- [x] Ehentai


# 说明
本项目基于[Flutter](https://github.com/flutter/flutter), 因此支持跨平台

测试平台如下:

Android: Android 11 | MIUI12.5.9稳定版 | 小米11

IOS: 缺失设备



# 功能
- Booru
  - [x] Post, Tag, Pool, Artist, Favorite
  - [x] Comment, Login, Download
- Ehentai 
  - [x] Home, Watched, Popular, Favourites
  - [x] 高级搜索, 过滤器
  - [x] 下载, 历史
  - [x] 中文翻译以及基于中文的自动补全
  - [x] 单双页切换, 横竖屏切换

# TODO
- [ ] 图片分享, 刷新, 下载原图
- [ ] 评论顶和踩
- [ ] 种子下载
- [ ] 富文本评论支持
- [ ] 评分
- [ ] 横屏优化
- [ ] 公告支持
- [ ] IOS系统下载支持
- [ ] 下载导出


# 运行截图

|主页|网站选择|
|--|--|
|![](https://i.loli.net/2021/02/18/TZUVvlkNaFc1mLd.jpg)|![](https://i.loli.net/2021/02/18/jVRTS1yg9lOsI5h.jpg)|


|预览|Tag|
|--|--|
|![](https://i.loli.net/2021/02/18/EwCUdZkAfBDRGTq.jpg)|![](https://i.loli.net/2021/02/18/1rIFKZ4tShdvoYG.jpg)|


# 编译与运行
clone本项目后, 请执行以下命令获取依赖
```cmd
flutter pub get
```

本项目使用了protobuf, 所以您必须拥有protobuf的环境: [文档](https://developers.google.com/protocol-buffers/docs/reference/dart-generated#invocation)

然后执行以下命令, 此文件可在wtools(windows)和mtools(macos/linux)内找到, 下不赘述
proto.cmd | proto.sh
```cmd
cd \lib\data\models\proto
protoc --dart_out=..\gen eh_gallery.proto
protoc --dart_out=..\gen eh_storage.proto
protoc --dart_out=..\gen eh_preview.proto
protoc --dart_out=..\gen eh_download.proto
protoc --dart_out=..\gen eh_gallery_img.proto
cd ..
cd gen
del /q *.pbjson.dart
del /q *.pbserver.dart
```

然后执行以下命令, 生成代码文件
```cmd
flutter packages pub run build_runner build
```

由于flutter的[bug](https://github.com/mobxjs/mobx.dart/issues/405), 导致生成的文件类型混乱, 您可以运行`fix_store.dart`替换, 或参照以下规则替换掉`lib/data/store/main/main_store.g.dart`内文本
```
raw: List<dynamic> get websiteList
after: List<WebsiteTableData> get websiteList

raw: set websiteList(List<dynamic> value)
after: set websiteList(List<WebsiteTableData> value)

raw: dynamic get websiteEntity
after: WebsiteTableData? get websiteEntity
```

到此, 项目初始化完成, 您可以使用使用以下命令运行
```
flutter run
```