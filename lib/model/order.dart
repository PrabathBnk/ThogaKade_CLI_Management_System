class Order{
  String id;
  Map<String, int> items;
  double totalAmount;
  String timestamp;

  Order(this.id, this.items, this.totalAmount, this.timestamp);

  Order.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      //Convert Map<String, dynamic> to Map<String, int>
      items = json['items'].map<String, int>((key, value) => MapEntry<String, int>(key, value)),
      totalAmount = json['totalAmount'] as double,
      timestamp = json['timestamp'] as String;

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items,
    'totalAmount': totalAmount,
    'timestamp': timestamp
  };

  @override
  String toString() {
    return 'Order{id: $id, items: $items, totalAmount: $totalAmount, timestamp: $timestamp}';
  }
}