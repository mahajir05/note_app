class BaseListResp<T> {
  final List<T>? data;

  BaseListResp({
    this.data,
  });

  BaseListResp.fromJson(dynamic data, Function fromJsonModel)
      : data = data != null
            ? List<T>.from(data.cast<Map<String, dynamic>>().map((itemsJson) => fromJsonModel(itemsJson)))
            : null;
}
