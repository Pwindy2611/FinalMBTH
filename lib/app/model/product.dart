class Product {
  int id;
  String name;
  int idCategory;
  String linkImage;
  String description;
  int price;

  Product({
    required this.id,
    required this.name,
    required this.idCategory,
    required this.linkImage,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      idCategory: json['idCategory'],
      linkImage: json['linkImage'],
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'idCategory': idCategory,
      'linkImage': linkImage,
      'description': description,
      'price': price,
    };
  }
}