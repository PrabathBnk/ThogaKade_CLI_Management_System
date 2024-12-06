class Vegetable{
  String id;
  String name;
  double price;
  int quantity;
  String category;
  String expiryDate;

  Vegetable(this.id, this.name, this.price, this.quantity, this.category, this.expiryDate);

  Vegetable.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String,
      price = json['price'] as double,
      quantity = json['quantity'] as int,
      category = json['category'] as String,
      expiryDate = json['expiryDate'] as String;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'category': category,
    'expiryDate': expiryDate
  };

  @override
  String toString() {
    return 'Vegetable{id: $id, name: $name, price: $price, quantity: $quantity, category: $category, expiryDate: $expiryDate}';
  }
}