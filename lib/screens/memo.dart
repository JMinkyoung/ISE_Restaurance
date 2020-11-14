class Memo {
  final String id;
  final String enterTime;
  final String price;
  final String createTime;
  final String prepTime;

  Memo({this.id, this.enterTime, this.price, this.createTime, this.prepTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterTime': enterTime,
      'price': price,
      'createTime': createTime,
      'prepTime': prepTime,
    };
  }

  @override
  String toString() {
    return 'Memo{id: $id, enterTime: $enterTime, price: $price, createTime: $createTime, prepTime: $prepTime}';
  }
}
