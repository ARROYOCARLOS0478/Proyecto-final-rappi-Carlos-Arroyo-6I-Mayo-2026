import 'dart:io';

void main() {
  print('--- Rappi Management Setup Helper ---');
  print('Este script ayuda a verificar la estructura del proyecto.');
  
  final folders = [
    'lib/models',
    'lib/services',
    'lib/screens',
    'lib/widgets',
    'lib/theme',
  ];

  for (var folder in folders) {
    if (Directory(folder).existsSync()) {
      print('[OK] Carpeta encontrada: $folder');
    } else {
      print('[ERROR] Carpeta no encontrada: $folder');
    }
  }

  print('\nRecuerda ejecutar "flutterfire configure" para conectar con tu proyecto Firebase: rappicarlos');
  print('-------------------------------------');
}
