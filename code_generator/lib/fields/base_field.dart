import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/asset_field.dart';
import 'package:flutter_storyblok_code_generator/fields/blok_fields.dart';
import 'package:flutter_storyblok_code_generator/fields/boolean_field.dart';
import 'package:flutter_storyblok_code_generator/fields/datetime_field.dart';
import 'package:flutter_storyblok_code_generator/fields/link_field.dart';
import 'package:flutter_storyblok_code_generator/fields/multi_asset_field.dart';
import 'package:flutter_storyblok_code_generator/fields/number_field.dart';
import 'package:flutter_storyblok_code_generator/fields/option_field.dart';
import 'package:flutter_storyblok_code_generator/fields/rich_text_field.dart';
import 'package:flutter_storyblok_code_generator/fields/text_area_field.dart';
import 'package:flutter_storyblok_code_generator/fields/text_field.dart';
import 'package:flutter_storyblok_code_generator/fields/text_markdown_field.dart';

abstract class BaseField {
  final JSONMap data;
  final String name;
  final bool isRequired;
  final int? position;
  BaseField(this.data, this.name, this.isRequired, this.position);
  BaseField.fromJson(this.data, this.name)
      : isRequired = tryCast<bool>(data["required"]) ?? false,
        position = tryCast<int>(data["pos"]);

  static BaseField? fromData(JSONMap data, String typee, String fieldName) {
    final BaseField? a = switch (typee) {
      "bloks" => BlokField.fromJson(data, fieldName),
      "text" => TextField.fromJson(data, fieldName),
      "textarea" => TextAreaField.fromJson(data, fieldName),
      "markdown" => MarkdownField.fromJson(data, fieldName),
      "number" => NumberField.fromJson(data, fieldName),
      "boolean" => BooleanField.fromJson(data, fieldName),
      "datetime" => DateTimeField.fromJson(data, fieldName),
      "asset" => AssetField.fromJson(data, fieldName),
      "multiasset" => MultiAssetField.fromJson(data, fieldName),
      "multilink" => LinkField.fromJson(data, fieldName),
      "option" => OptionField.fromJson(data, fieldName),
      // "options" => OptionField.fromJson(data, fieldName),
      // table
      // plugin
      "richtext" => RichTextField.fromJson(data, fieldName),
      _ => null,
    };
    return a;
  }

  // TODO: return Reference
  String symbol();

  void buildFieldType(TypeReferenceBuilder t) => t
    ..symbol = symbol()
    ..isNullable = !isRequired;

  List<Spec>? generateSupportingClasses() => null;

  // TODO: return Code
  String generateInitializerCode(String valueCode) => valueCode;
}
