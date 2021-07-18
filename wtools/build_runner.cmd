:: del /f /s /q *.g.dart
flutter packages pub run build_runner build && dart fix_store.dart

