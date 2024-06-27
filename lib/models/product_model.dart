

class ProductModel {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;
  bool isFavorite;
  bool isCart;
  int quantity;
  bool isCheckout;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.isFavorite = false,
    this.isCart = false,
    this.quantity = 1,
    this.isCheckout = false,
  });

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
    bool? isFavorite,
    bool? isCart,
    int? quantity,
    bool? isCheckout,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isCart: isCart ?? this.isCart,
      quantity: quantity ?? this.quantity,
      isCheckout: isCheckout ?? this.isCheckout,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating_rate': rating.rate,
      'rating_count': rating.count,
      'isFavorite': isFavorite,
      'isCart': isCart,
      'quantity': quantity,
      'isCheckout': isCheckout,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      description: map['description'],
      category: map['category'],
      image: map['image'],
      rating: Rating(
        rate: map['rating_rate'],
        count: map['rating_count'],
      ),
      isFavorite: map['isFavorite'] == 1 ? true : false,
      isCart: map['isCart'] == 1 ? true : false,
      quantity: map['quantity'],
      isCheckout: map['isCheckout'] == 1 ? true : false,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        price: json["price"].toDouble(),
        description: json["description"],
        category: json["category"],
        image: json["image"],
        rating: Rating.fromJson(json["rating"]),
      );
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}
