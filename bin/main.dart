import 'dart:developer';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

main(List<String> arguments) {
  final file = File('lib/gen.dart');

  // final f = PhysicalResourceProvider.INSTANCE.getFile(file.absolute.path);

  final result = parseFile(
      path: file.absolute.path, featureSet: FeatureSet.fromEnableFlags([]));

  for (final entity in result.unit.childEntities) {
    if (entity is ClassDeclaration) {
      print(entity.runtimeType);
      print(entity);
      print('\n');
      handleClass(entity);
    }
  }
}

void handleClass(ClassDeclaration declaration) {
  for (final entity in declaration.childEntities) {
    if (entity is Annotation) {
      print(entity.runtimeType);
      print(entity);
      print('\n');
      handleAnnotation(entity);
    }
  }
}

void handleAnnotation(Annotation annotation) {
  for (final entity in annotation.childEntities) {
    print(entity.runtimeType);
    print(entity);
    print('\n');

    if (entity is SimpleIdentifier) {
      final simpleId = entity;
      if (simpleId.name != 'AnnoInfo') {
        return;
      }
    }

    if (entity is ArgumentList) {
      handleArgs(entity);
    }
  }
}

void handleArgs(ArgumentList args) {
  for (final entity in args.childEntities) {
    print(entity.runtimeType);
    print(entity);
    print('\n');

    if (entity is NamedExpression) {
      handleNameParam(entity);
    }
  }
}

void handleNameParam(NamedExpression param) {
  AnnoInfoPramsType type;
  for (final entity in param.childEntities) {
    print(entity.runtimeType);
    print(entity);
    print('\n');

    if (entity is Label) {
      if (entity.label.name == 'ext') {
        type = AnnoInfoPramsType.ext;
      }
    }

    if (entity is SetOrMapLiteral) {
      switch (type) {
        case AnnoInfoPramsType.ext:
          handleExtValues(entity);
          break;
      }
    }
  }
}

void handleExtValues(SetOrMapLiteral map) {
  for (final entry in map.elements) {
    if (entry is MapLiteralEntry) {
      if (entry.key is SimpleStringLiteral) {
        final SimpleStringLiteral key = entry.key;
        log('key =  ${key.stringValue}');
      }
      if (entry.value is SimpleStringLiteral) {
        final SimpleStringLiteral value = entry.value;
        log('value =  ${value.stringValue}');
      }
    }
  }
}

enum AnnoInfoPramsType { ext }
