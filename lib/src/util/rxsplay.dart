import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// `GetX`-reactive [SplayTreeMap].
///
/// Behaves like a wrapper around [SplayTreeMap].
class RxSplayTreeMap<K, V> extends SplayTreeMap<K, V>
    with NotifyManager<SplayTreeMap<K, V>>, RxObjectMixin<SplayTreeMap<K, V>>
    implements RxInterface<SplayTreeMap<K, V>> {
  /// Creates a new [SplayTreeMap] with the provided [initial] keys and values.
  RxSplayTreeMap([Map<K, V> initial = const {}])
      : _value = SplayTreeMap.from(initial);

  /// Creates a new [SplayTreeMap] with the same keys and values as [other].
  factory RxSplayTreeMap.from(Map<K, V> other) =>
      RxSplayTreeMap(Map.from(other));

  /// Creates a new [SplayTreeMap] with the same keys and values as [other].
  factory RxSplayTreeMap.of(Map<K, V> other) => RxSplayTreeMap(Map.of(other));

  /// Creates an unmodifiable hash based map containing the entries of [other].
  factory RxSplayTreeMap.unmodifiable(Map<dynamic, dynamic> other) =>
      RxSplayTreeMap(Map.unmodifiable(other));

  /// Creates a new [SplayTreeMap] instance in which the keys and values are
  /// computed from the provided [iterable].
  factory RxSplayTreeMap.fromIterable(
    Iterable iterable, {
    K Function(dynamic element)? key,
    V Function(dynamic element)? value,
  }) =>
      RxSplayTreeMap(Map<K, V>.fromIterable(iterable, key: key, value: value));

  /// Creates a new [SplayTreeMap] associating the given [keys] to the given
  /// [values].
  factory RxSplayTreeMap.fromIterables(Iterable<K> keys, Iterable<V> values) =>
      RxSplayTreeMap(Map<K, V>.fromIterables(keys, values));

  /// Creates a new [SplayTreeMap] and adds all the provided [entries] to it.
  factory RxSplayTreeMap.fromEntries(Iterable<MapEntry<K, V>> entries) =>
      RxSplayTreeMap(Map<K, V>.fromEntries(entries));

  /// Internal actual value of the [SplayTreeMap] this [RxSplayTreeMap] holds.
  late SplayTreeMap<K, V> _value;

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  int get length => _value.length;

  @override
  Iterable<K> get keys => _value.keys;

  @override
  Iterable<V> get values => _value.values;

  @override
  Iterable<MapEntry<K, V>> get entries => _value.entries;

  @override
  V? operator [](Object? key) => _value[key];

  @override
  V? remove(Object? key) {
    V? result = _value.remove(key);
    refresh();
    return result;
  }

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    refresh();
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    V result = _value.putIfAbsent(key, ifAbsent);
    refresh();
    return result;
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    V result = _value.update(key, update, ifAbsent: ifAbsent);
    refresh();
    return result;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _value.updateAll(update);
    refresh();
  }

  @override
  void addAll(Map<K, V> other) {
    other.forEach((K key, V value) {
      this[key] = value;
    });
  }

  @override
  void forEach(void Function(K key, V value) f) {
    _value.forEach(f);
    refresh();
  }

  @override
  void clear() {
    _value.clear();
    refresh();
  }

  @override
  bool containsKey(Object? key) => _value.containsKey(key);

  @override
  bool containsValue(Object? value) => _value.containsValue(value);

  @override
  K? firstKey() => _value.firstKey();

  @override
  K? lastKey() => _value.lastKey();

  @override
  K? lastKeyBefore(K key) => _value.lastKeyBefore(key);

  @override
  K? firstKeyAfter(K key) => _value.firstKeyAfter(key);

  @override
  SplayTreeMap<K, V> get value {
    RxInterface.proxy?.addListener(subject);
    return _value;
  }
}
