:: del /f /s /q *.g.dart
cd ..
flutter packages pub run build_runner build && dart fix_store.dart
cd wtools

