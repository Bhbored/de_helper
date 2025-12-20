// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconCodePointMeta = const VerificationMeta(
    'iconCodePoint',
  );
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
    'icon_code_point',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, iconCodePoint];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
        _iconCodePointMeta,
        iconCodePoint.isAcceptableOrUnknown(
          data['icon_code_point']!,
          _iconCodePointMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconCodePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code_point'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final int iconCodePoint;
  const Category({
    required this.id,
    required this.name,
    required this.iconCodePoint,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconCodePoint: Value(iconCodePoint),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
    };
  }

  Category copyWith({String? id, String? name, int? iconCodePoint}) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    iconCodePoint: iconCodePoint ?? this.iconCodePoint,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodePoint: $iconCodePoint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, iconCodePoint);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconCodePoint == this.iconCodePoint);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> iconCodePoint;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required int iconCodePoint,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       iconCodePoint = Value(iconCodePoint);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? iconCodePoint,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? iconCodePoint,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubCategoriesTable extends SubCategories
    with TableInfo<$SubCategoriesTable, SubCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $SubCategoriesTable createAlias(String alias) {
    return $SubCategoriesTable(attachedDatabase, alias);
  }
}

class SubCategory extends DataClass implements Insertable<SubCategory> {
  final String id;
  final String name;
  final String categoryId;
  const SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  SubCategoriesCompanion toCompanion(bool nullToAbsent) {
    return SubCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
    );
  }

  factory SubCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  SubCategory copyWith({String? id, String? name, String? categoryId}) =>
      SubCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
      );
  SubCategory copyWithCompanion(SubCategoriesCompanion data) {
    return SubCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId);
}

class SubCategoriesCompanion extends UpdateCompanion<SubCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categoryId;
  final Value<int> rowid;
  const SubCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubCategoriesCompanion.insert({
    required String id,
    required String name,
    required String categoryId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       categoryId = Value(categoryId);
  static Insertable<SubCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? categoryId,
    Value<int>? rowid,
  }) {
    return SubCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ColorPresetsTable extends ColorPresets
    with TableInfo<$ColorPresetsTable, ColorPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColorPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hexCodeMeta = const VerificationMeta(
    'hexCode',
  );
  @override
  late final GeneratedColumn<String> hexCode = GeneratedColumn<String>(
    'hex_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, hexCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'color_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ColorPreset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('hex_code')) {
      context.handle(
        _hexCodeMeta,
        hexCode.isAcceptableOrUnknown(data['hex_code']!, _hexCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ColorPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ColorPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      hexCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hex_code'],
      ),
    );
  }

  @override
  $ColorPresetsTable createAlias(String alias) {
    return $ColorPresetsTable(attachedDatabase, alias);
  }
}

class ColorPreset extends DataClass implements Insertable<ColorPreset> {
  final String id;
  final String? name;
  final String? hexCode;
  const ColorPreset({required this.id, this.name, this.hexCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || hexCode != null) {
      map['hex_code'] = Variable<String>(hexCode);
    }
    return map;
  }

  ColorPresetsCompanion toCompanion(bool nullToAbsent) {
    return ColorPresetsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      hexCode: hexCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hexCode),
    );
  }

  factory ColorPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ColorPreset(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      hexCode: serializer.fromJson<String?>(json['hexCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'hexCode': serializer.toJson<String?>(hexCode),
    };
  }

  ColorPreset copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> hexCode = const Value.absent(),
  }) => ColorPreset(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    hexCode: hexCode.present ? hexCode.value : this.hexCode,
  );
  ColorPreset copyWithCompanion(ColorPresetsCompanion data) {
    return ColorPreset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hexCode: data.hexCode.present ? data.hexCode.value : this.hexCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ColorPreset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hexCode: $hexCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, hexCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ColorPreset &&
          other.id == this.id &&
          other.name == this.name &&
          other.hexCode == this.hexCode);
}

class ColorPresetsCompanion extends UpdateCompanion<ColorPreset> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> hexCode;
  final Value<int> rowid;
  const ColorPresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hexCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ColorPresetsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.hexCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ColorPreset> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? hexCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hexCode != null) 'hex_code': hexCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ColorPresetsCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? hexCode,
    Value<int>? rowid,
  }) {
    return ColorPresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hexCode.present) {
      map['hex_code'] = Variable<String>(hexCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColorPresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hexCode: $hexCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementPresetsTable extends MeasurementPresets
    with TableInfo<$MeasurementPresetsTable, MeasurementPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementPreset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasurementPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $MeasurementPresetsTable createAlias(String alias) {
    return $MeasurementPresetsTable(attachedDatabase, alias);
  }
}

class MeasurementPreset extends DataClass
    implements Insertable<MeasurementPreset> {
  final String id;
  final String name;
  const MeasurementPreset({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  MeasurementPresetsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementPresetsCompanion(id: Value(id), name: Value(name));
  }

  factory MeasurementPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementPreset(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  MeasurementPreset copyWith({String? id, String? name}) =>
      MeasurementPreset(id: id ?? this.id, name: name ?? this.name);
  MeasurementPreset copyWithCompanion(MeasurementPresetsCompanion data) {
    return MeasurementPreset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementPreset(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementPreset &&
          other.id == this.id &&
          other.name == this.name);
}

class MeasurementPresetsCompanion extends UpdateCompanion<MeasurementPreset> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const MeasurementPresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementPresetsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<MeasurementPreset> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementPresetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return MeasurementPresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementPresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subCategoryIdMeta = const VerificationMeta(
    'subCategoryId',
  );
  @override
  late final GeneratedColumn<String> subCategoryId = GeneratedColumn<String>(
    'sub_category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualCostMeta = const VerificationMeta(
    'manualCost',
  );
  @override
  late final GeneratedColumn<double> manualCost = GeneratedColumn<double>(
    'manual_cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profitMarginMeta = const VerificationMeta(
    'profitMargin',
  );
  @override
  late final GeneratedColumn<double> profitMargin = GeneratedColumn<double>(
    'profit_margin',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondaryBarcodeMeta = const VerificationMeta(
    'secondaryBarcode',
  );
  @override
  late final GeneratedColumn<String> secondaryBarcode = GeneratedColumn<String>(
    'secondary_barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorPresetIdMeta = const VerificationMeta(
    'colorPresetId',
  );
  @override
  late final GeneratedColumn<String> colorPresetId = GeneratedColumn<String>(
    'color_preset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementPresetIdMeta =
      const VerificationMeta('measurementPresetId');
  @override
  late final GeneratedColumn<String> measurementPresetId =
      GeneratedColumn<String>(
        'measurement_preset_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryId,
    subCategoryId,
    quantity,
    price,
    manualCost,
    profitMargin,
    barcode,
    secondaryBarcode,
    colorPresetId,
    measurementPresetId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('sub_category_id')) {
      context.handle(
        _subCategoryIdMeta,
        subCategoryId.isAcceptableOrUnknown(
          data['sub_category_id']!,
          _subCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('manual_cost')) {
      context.handle(
        _manualCostMeta,
        manualCost.isAcceptableOrUnknown(data['manual_cost']!, _manualCostMeta),
      );
    }
    if (data.containsKey('profit_margin')) {
      context.handle(
        _profitMarginMeta,
        profitMargin.isAcceptableOrUnknown(
          data['profit_margin']!,
          _profitMarginMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('secondary_barcode')) {
      context.handle(
        _secondaryBarcodeMeta,
        secondaryBarcode.isAcceptableOrUnknown(
          data['secondary_barcode']!,
          _secondaryBarcodeMeta,
        ),
      );
    }
    if (data.containsKey('color_preset_id')) {
      context.handle(
        _colorPresetIdMeta,
        colorPresetId.isAcceptableOrUnknown(
          data['color_preset_id']!,
          _colorPresetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_colorPresetIdMeta);
    }
    if (data.containsKey('measurement_preset_id')) {
      context.handle(
        _measurementPresetIdMeta,
        measurementPresetId.isAcceptableOrUnknown(
          data['measurement_preset_id']!,
          _measurementPresetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementPresetIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      subCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_category_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      manualCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manual_cost'],
      ),
      profitMargin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}profit_margin'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      secondaryBarcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_barcode'],
      ),
      colorPresetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_preset_id'],
      )!,
      measurementPresetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_preset_id'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String categoryId;
  final String? subCategoryId;
  final int quantity;
  final double price;
  final double? manualCost;
  final double profitMargin;
  final String barcode;
  final String? secondaryBarcode;
  final String colorPresetId;
  final String measurementPresetId;
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    this.subCategoryId,
    required this.quantity,
    required this.price,
    this.manualCost,
    required this.profitMargin,
    required this.barcode,
    this.secondaryBarcode,
    required this.colorPresetId,
    required this.measurementPresetId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || subCategoryId != null) {
      map['sub_category_id'] = Variable<String>(subCategoryId);
    }
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || manualCost != null) {
      map['manual_cost'] = Variable<double>(manualCost);
    }
    map['profit_margin'] = Variable<double>(profitMargin);
    map['barcode'] = Variable<String>(barcode);
    if (!nullToAbsent || secondaryBarcode != null) {
      map['secondary_barcode'] = Variable<String>(secondaryBarcode);
    }
    map['color_preset_id'] = Variable<String>(colorPresetId);
    map['measurement_preset_id'] = Variable<String>(measurementPresetId);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
      subCategoryId: subCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(subCategoryId),
      quantity: Value(quantity),
      price: Value(price),
      manualCost: manualCost == null && nullToAbsent
          ? const Value.absent()
          : Value(manualCost),
      profitMargin: Value(profitMargin),
      barcode: Value(barcode),
      secondaryBarcode: secondaryBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryBarcode),
      colorPresetId: Value(colorPresetId),
      measurementPresetId: Value(measurementPresetId),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      subCategoryId: serializer.fromJson<String?>(json['subCategoryId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      manualCost: serializer.fromJson<double?>(json['manualCost']),
      profitMargin: serializer.fromJson<double>(json['profitMargin']),
      barcode: serializer.fromJson<String>(json['barcode']),
      secondaryBarcode: serializer.fromJson<String?>(json['secondaryBarcode']),
      colorPresetId: serializer.fromJson<String>(json['colorPresetId']),
      measurementPresetId: serializer.fromJson<String>(
        json['measurementPresetId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String>(categoryId),
      'subCategoryId': serializer.toJson<String?>(subCategoryId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'manualCost': serializer.toJson<double?>(manualCost),
      'profitMargin': serializer.toJson<double>(profitMargin),
      'barcode': serializer.toJson<String>(barcode),
      'secondaryBarcode': serializer.toJson<String?>(secondaryBarcode),
      'colorPresetId': serializer.toJson<String>(colorPresetId),
      'measurementPresetId': serializer.toJson<String>(measurementPresetId),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    Value<String?> subCategoryId = const Value.absent(),
    int? quantity,
    double? price,
    Value<double?> manualCost = const Value.absent(),
    double? profitMargin,
    String? barcode,
    Value<String?> secondaryBarcode = const Value.absent(),
    String? colorPresetId,
    String? measurementPresetId,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    subCategoryId: subCategoryId.present
        ? subCategoryId.value
        : this.subCategoryId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    manualCost: manualCost.present ? manualCost.value : this.manualCost,
    profitMargin: profitMargin ?? this.profitMargin,
    barcode: barcode ?? this.barcode,
    secondaryBarcode: secondaryBarcode.present
        ? secondaryBarcode.value
        : this.secondaryBarcode,
    colorPresetId: colorPresetId ?? this.colorPresetId,
    measurementPresetId: measurementPresetId ?? this.measurementPresetId,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subCategoryId: data.subCategoryId.present
          ? data.subCategoryId.value
          : this.subCategoryId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      manualCost: data.manualCost.present
          ? data.manualCost.value
          : this.manualCost,
      profitMargin: data.profitMargin.present
          ? data.profitMargin.value
          : this.profitMargin,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      secondaryBarcode: data.secondaryBarcode.present
          ? data.secondaryBarcode.value
          : this.secondaryBarcode,
      colorPresetId: data.colorPresetId.present
          ? data.colorPresetId.value
          : this.colorPresetId,
      measurementPresetId: data.measurementPresetId.present
          ? data.measurementPresetId.value
          : this.measurementPresetId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('subCategoryId: $subCategoryId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('manualCost: $manualCost, ')
          ..write('profitMargin: $profitMargin, ')
          ..write('barcode: $barcode, ')
          ..write('secondaryBarcode: $secondaryBarcode, ')
          ..write('colorPresetId: $colorPresetId, ')
          ..write('measurementPresetId: $measurementPresetId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    categoryId,
    subCategoryId,
    quantity,
    price,
    manualCost,
    profitMargin,
    barcode,
    secondaryBarcode,
    colorPresetId,
    measurementPresetId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.subCategoryId == this.subCategoryId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.manualCost == this.manualCost &&
          other.profitMargin == this.profitMargin &&
          other.barcode == this.barcode &&
          other.secondaryBarcode == this.secondaryBarcode &&
          other.colorPresetId == this.colorPresetId &&
          other.measurementPresetId == this.measurementPresetId);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categoryId;
  final Value<String?> subCategoryId;
  final Value<int> quantity;
  final Value<double> price;
  final Value<double?> manualCost;
  final Value<double> profitMargin;
  final Value<String> barcode;
  final Value<String?> secondaryBarcode;
  final Value<String> colorPresetId;
  final Value<String> measurementPresetId;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subCategoryId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.manualCost = const Value.absent(),
    this.profitMargin = const Value.absent(),
    this.barcode = const Value.absent(),
    this.secondaryBarcode = const Value.absent(),
    this.colorPresetId = const Value.absent(),
    this.measurementPresetId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required String categoryId,
    this.subCategoryId = const Value.absent(),
    required int quantity,
    required double price,
    this.manualCost = const Value.absent(),
    this.profitMargin = const Value.absent(),
    required String barcode,
    this.secondaryBarcode = const Value.absent(),
    required String colorPresetId,
    required String measurementPresetId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       categoryId = Value(categoryId),
       quantity = Value(quantity),
       price = Value(price),
       barcode = Value(barcode),
       colorPresetId = Value(colorPresetId),
       measurementPresetId = Value(measurementPresetId);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? subCategoryId,
    Expression<int>? quantity,
    Expression<double>? price,
    Expression<double>? manualCost,
    Expression<double>? profitMargin,
    Expression<String>? barcode,
    Expression<String>? secondaryBarcode,
    Expression<String>? colorPresetId,
    Expression<String>? measurementPresetId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (subCategoryId != null) 'sub_category_id': subCategoryId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (manualCost != null) 'manual_cost': manualCost,
      if (profitMargin != null) 'profit_margin': profitMargin,
      if (barcode != null) 'barcode': barcode,
      if (secondaryBarcode != null) 'secondary_barcode': secondaryBarcode,
      if (colorPresetId != null) 'color_preset_id': colorPresetId,
      if (measurementPresetId != null)
        'measurement_preset_id': measurementPresetId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? categoryId,
    Value<String?>? subCategoryId,
    Value<int>? quantity,
    Value<double>? price,
    Value<double?>? manualCost,
    Value<double>? profitMargin,
    Value<String>? barcode,
    Value<String?>? secondaryBarcode,
    Value<String>? colorPresetId,
    Value<String>? measurementPresetId,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      manualCost: manualCost ?? this.manualCost,
      profitMargin: profitMargin ?? this.profitMargin,
      barcode: barcode ?? this.barcode,
      secondaryBarcode: secondaryBarcode ?? this.secondaryBarcode,
      colorPresetId: colorPresetId ?? this.colorPresetId,
      measurementPresetId: measurementPresetId ?? this.measurementPresetId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (subCategoryId.present) {
      map['sub_category_id'] = Variable<String>(subCategoryId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (manualCost.present) {
      map['manual_cost'] = Variable<double>(manualCost.value);
    }
    if (profitMargin.present) {
      map['profit_margin'] = Variable<double>(profitMargin.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (secondaryBarcode.present) {
      map['secondary_barcode'] = Variable<String>(secondaryBarcode.value);
    }
    if (colorPresetId.present) {
      map['color_preset_id'] = Variable<String>(colorPresetId.value);
    }
    if (measurementPresetId.present) {
      map['measurement_preset_id'] = Variable<String>(
        measurementPresetId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('subCategoryId: $subCategoryId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('manualCost: $manualCost, ')
          ..write('profitMargin: $profitMargin, ')
          ..write('barcode: $barcode, ')
          ..write('secondaryBarcode: $secondaryBarcode, ')
          ..write('colorPresetId: $colorPresetId, ')
          ..write('measurementPresetId: $measurementPresetId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SubCategoriesTable subCategories = $SubCategoriesTable(this);
  late final $ColorPresetsTable colorPresets = $ColorPresetsTable(this);
  late final $MeasurementPresetsTable measurementPresets =
      $MeasurementPresetsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    subCategories,
    colorPresets,
    measurementPresets,
    products,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      required int iconCodePoint,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> iconCodePoint,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => column,
  );
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> iconCodePoint = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                iconCodePoint: iconCodePoint,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int iconCodePoint,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                iconCodePoint: iconCodePoint,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$SubCategoriesTableCreateCompanionBuilder =
    SubCategoriesCompanion Function({
      required String id,
      required String name,
      required String categoryId,
      Value<int> rowid,
    });
typedef $$SubCategoriesTableUpdateCompanionBuilder =
    SubCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> categoryId,
      Value<int> rowid,
    });

class $$SubCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SubCategoriesTable> {
  $$SubCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubCategoriesTable> {
  $$SubCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubCategoriesTable> {
  $$SubCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );
}

class $$SubCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubCategoriesTable,
          SubCategory,
          $$SubCategoriesTableFilterComposer,
          $$SubCategoriesTableOrderingComposer,
          $$SubCategoriesTableAnnotationComposer,
          $$SubCategoriesTableCreateCompanionBuilder,
          $$SubCategoriesTableUpdateCompanionBuilder,
          (
            SubCategory,
            BaseReferences<_$AppDatabase, $SubCategoriesTable, SubCategory>,
          ),
          SubCategory,
          PrefetchHooks Function()
        > {
  $$SubCategoriesTableTableManager(_$AppDatabase db, $SubCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubCategoriesCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String categoryId,
                Value<int> rowid = const Value.absent(),
              }) => SubCategoriesCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubCategoriesTable,
      SubCategory,
      $$SubCategoriesTableFilterComposer,
      $$SubCategoriesTableOrderingComposer,
      $$SubCategoriesTableAnnotationComposer,
      $$SubCategoriesTableCreateCompanionBuilder,
      $$SubCategoriesTableUpdateCompanionBuilder,
      (
        SubCategory,
        BaseReferences<_$AppDatabase, $SubCategoriesTable, SubCategory>,
      ),
      SubCategory,
      PrefetchHooks Function()
    >;
typedef $$ColorPresetsTableCreateCompanionBuilder =
    ColorPresetsCompanion Function({
      required String id,
      Value<String?> name,
      Value<String?> hexCode,
      Value<int> rowid,
    });
typedef $$ColorPresetsTableUpdateCompanionBuilder =
    ColorPresetsCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String?> hexCode,
      Value<int> rowid,
    });

class $$ColorPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $ColorPresetsTable> {
  $$ColorPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hexCode => $composableBuilder(
    column: $table.hexCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ColorPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ColorPresetsTable> {
  $$ColorPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hexCode => $composableBuilder(
    column: $table.hexCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ColorPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ColorPresetsTable> {
  $$ColorPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get hexCode =>
      $composableBuilder(column: $table.hexCode, builder: (column) => column);
}

class $$ColorPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ColorPresetsTable,
          ColorPreset,
          $$ColorPresetsTableFilterComposer,
          $$ColorPresetsTableOrderingComposer,
          $$ColorPresetsTableAnnotationComposer,
          $$ColorPresetsTableCreateCompanionBuilder,
          $$ColorPresetsTableUpdateCompanionBuilder,
          (
            ColorPreset,
            BaseReferences<_$AppDatabase, $ColorPresetsTable, ColorPreset>,
          ),
          ColorPreset,
          PrefetchHooks Function()
        > {
  $$ColorPresetsTableTableManager(_$AppDatabase db, $ColorPresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ColorPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ColorPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ColorPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> hexCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ColorPresetsCompanion(
                id: id,
                name: name,
                hexCode: hexCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> hexCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ColorPresetsCompanion.insert(
                id: id,
                name: name,
                hexCode: hexCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ColorPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ColorPresetsTable,
      ColorPreset,
      $$ColorPresetsTableFilterComposer,
      $$ColorPresetsTableOrderingComposer,
      $$ColorPresetsTableAnnotationComposer,
      $$ColorPresetsTableCreateCompanionBuilder,
      $$ColorPresetsTableUpdateCompanionBuilder,
      (
        ColorPreset,
        BaseReferences<_$AppDatabase, $ColorPresetsTable, ColorPreset>,
      ),
      ColorPreset,
      PrefetchHooks Function()
    >;
typedef $$MeasurementPresetsTableCreateCompanionBuilder =
    MeasurementPresetsCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$MeasurementPresetsTableUpdateCompanionBuilder =
    MeasurementPresetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$MeasurementPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementPresetsTable> {
  $$MeasurementPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeasurementPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementPresetsTable> {
  $$MeasurementPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasurementPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementPresetsTable> {
  $$MeasurementPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$MeasurementPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementPresetsTable,
          MeasurementPreset,
          $$MeasurementPresetsTableFilterComposer,
          $$MeasurementPresetsTableOrderingComposer,
          $$MeasurementPresetsTableAnnotationComposer,
          $$MeasurementPresetsTableCreateCompanionBuilder,
          $$MeasurementPresetsTableUpdateCompanionBuilder,
          (
            MeasurementPreset,
            BaseReferences<
              _$AppDatabase,
              $MeasurementPresetsTable,
              MeasurementPreset
            >,
          ),
          MeasurementPreset,
          PrefetchHooks Function()
        > {
  $$MeasurementPresetsTableTableManager(
    _$AppDatabase db,
    $MeasurementPresetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurementPresetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  MeasurementPresetsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => MeasurementPresetsCompanion.insert(
                id: id,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MeasurementPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementPresetsTable,
      MeasurementPreset,
      $$MeasurementPresetsTableFilterComposer,
      $$MeasurementPresetsTableOrderingComposer,
      $$MeasurementPresetsTableAnnotationComposer,
      $$MeasurementPresetsTableCreateCompanionBuilder,
      $$MeasurementPresetsTableUpdateCompanionBuilder,
      (
        MeasurementPreset,
        BaseReferences<
          _$AppDatabase,
          $MeasurementPresetsTable,
          MeasurementPreset
        >,
      ),
      MeasurementPreset,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required String categoryId,
      Value<String?> subCategoryId,
      required int quantity,
      required double price,
      Value<double?> manualCost,
      Value<double> profitMargin,
      required String barcode,
      Value<String?> secondaryBarcode,
      required String colorPresetId,
      required String measurementPresetId,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> categoryId,
      Value<String?> subCategoryId,
      Value<int> quantity,
      Value<double> price,
      Value<double?> manualCost,
      Value<double> profitMargin,
      Value<String> barcode,
      Value<String?> secondaryBarcode,
      Value<String> colorPresetId,
      Value<String> measurementPresetId,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCategoryId => $composableBuilder(
    column: $table.subCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get manualCost => $composableBuilder(
    column: $table.manualCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get profitMargin => $composableBuilder(
    column: $table.profitMargin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryBarcode => $composableBuilder(
    column: $table.secondaryBarcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorPresetId => $composableBuilder(
    column: $table.colorPresetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementPresetId => $composableBuilder(
    column: $table.measurementPresetId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCategoryId => $composableBuilder(
    column: $table.subCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get manualCost => $composableBuilder(
    column: $table.manualCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get profitMargin => $composableBuilder(
    column: $table.profitMargin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryBarcode => $composableBuilder(
    column: $table.secondaryBarcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorPresetId => $composableBuilder(
    column: $table.colorPresetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementPresetId => $composableBuilder(
    column: $table.measurementPresetId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subCategoryId => $composableBuilder(
    column: $table.subCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get manualCost => $composableBuilder(
    column: $table.manualCost,
    builder: (column) => column,
  );

  GeneratedColumn<double> get profitMargin => $composableBuilder(
    column: $table.profitMargin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get secondaryBarcode => $composableBuilder(
    column: $table.secondaryBarcode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorPresetId => $composableBuilder(
    column: $table.colorPresetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementPresetId => $composableBuilder(
    column: $table.measurementPresetId,
    builder: (column) => column,
  );
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> subCategoryId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double?> manualCost = const Value.absent(),
                Value<double> profitMargin = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String?> secondaryBarcode = const Value.absent(),
                Value<String> colorPresetId = const Value.absent(),
                Value<String> measurementPresetId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                subCategoryId: subCategoryId,
                quantity: quantity,
                price: price,
                manualCost: manualCost,
                profitMargin: profitMargin,
                barcode: barcode,
                secondaryBarcode: secondaryBarcode,
                colorPresetId: colorPresetId,
                measurementPresetId: measurementPresetId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String categoryId,
                Value<String?> subCategoryId = const Value.absent(),
                required int quantity,
                required double price,
                Value<double?> manualCost = const Value.absent(),
                Value<double> profitMargin = const Value.absent(),
                required String barcode,
                Value<String?> secondaryBarcode = const Value.absent(),
                required String colorPresetId,
                required String measurementPresetId,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                subCategoryId: subCategoryId,
                quantity: quantity,
                price: price,
                manualCost: manualCost,
                profitMargin: profitMargin,
                barcode: barcode,
                secondaryBarcode: secondaryBarcode,
                colorPresetId: colorPresetId,
                measurementPresetId: measurementPresetId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SubCategoriesTableTableManager get subCategories =>
      $$SubCategoriesTableTableManager(_db, _db.subCategories);
  $$ColorPresetsTableTableManager get colorPresets =>
      $$ColorPresetsTableTableManager(_db, _db.colorPresets);
  $$MeasurementPresetsTableTableManager get measurementPresets =>
      $$MeasurementPresetsTableTableManager(_db, _db.measurementPresets);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getDb)
const getDbProvider = GetDbProvider._();

final class GetDbProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  const GetDbProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDbProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDbHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return getDb(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$getDbHash() => r'b00ef3d132ff70ab84fd374f92590a2e732f621f';
