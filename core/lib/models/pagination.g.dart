// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Pagination> _$paginationSerializer = new _$PaginationSerializer();

class _$PaginationSerializer implements StructuredSerializer<Pagination> {
  @override
  final Iterable<Type> types = const [Pagination, _$Pagination];
  @override
  final String wireName = 'Pagination';

  @override
  Iterable serialize(Serializers serializers, Pagination object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.total != null) {
      result
        ..add('total')
        ..add(serializers.serialize(object.total,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Pagination deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaginationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Pagination extends Pagination {
  @override
  final int total;

  factory _$Pagination([void Function(PaginationBuilder) updates]) =>
      (new PaginationBuilder()..update(updates)).build();

  _$Pagination._({this.total}) : super._();

  @override
  Pagination rebuild(void Function(PaginationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginationBuilder toBuilder() => new PaginationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Pagination && total == other.total;
  }

  @override
  int get hashCode {
    return $jf($jc(0, total.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Pagination')..add('total', total))
        .toString();
  }
}

class PaginationBuilder implements Builder<Pagination, PaginationBuilder> {
  _$Pagination _$v;

  int _total;
  int get total => _$this._total;
  set total(int total) => _$this._total = total;

  PaginationBuilder();

  PaginationBuilder get _$this {
    if (_$v != null) {
      _total = _$v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Pagination other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Pagination;
  }

  @override
  void update(void Function(PaginationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Pagination build() {
    final _$result = _$v ?? new _$Pagination._(total: total);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
