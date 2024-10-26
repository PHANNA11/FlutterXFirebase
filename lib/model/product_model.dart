class ProductModel {
  int? id;
  String? name;
  double? price;
  double? discount;
  String? discountLabel;
  double? sellPrice;
  String? discription;
  String? image;
  ProductModel(
      {this.id,
      this.name,
      this.price,
      this.discount,
      this.discountLabel,
      this.sellPrice,
      this.discription,
      this.image});
  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  ProductModel.fromFireBase(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        price = double.parse(map['price'].toString());
}
