import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AvatarService {
  static const _avatarPathKey = 'avatar_path';

  static Future<File?> pickAndSave() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
    );
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(picked.path).copy('${dir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, saved.path);

    return saved;
  }

  static Future<String?> getSavedPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPathKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final oldPath = prefs.getString(_avatarPathKey);
    if (oldPath != null) {
      final file = File(oldPath);
      if (file.existsSync()) await file.delete();
    }
    await prefs.remove(_avatarPathKey);
  }
}
