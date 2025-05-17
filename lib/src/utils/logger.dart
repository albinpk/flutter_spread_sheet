import 'dart:developer';

extension Ext<T> on T {
  @Deprecated('')
  T logger([Object? name]) {
    log(toString(), name: name?.toString() ?? 'log');
    return this;
  }
}
