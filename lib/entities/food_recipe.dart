class FoodRecipe {
  int? id;
  int userId;
  String recipeName;
  String recipeDescription;
  String imagePath;
  bool isPopular;

  FoodRecipe({
    this.id,
    required this.userId,
    required this.recipeName,
    required this.recipeDescription,
    required this.imagePath,
    required this.isPopular,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'recipe_name': recipeName,
      'recipe_description': recipeDescription,
      'image_path': imagePath,
      'is_popular': isPopular
          ? 1
          : 0, // SQLite bool değerini saklamak için 1 veya 0 kullanır
    };
  }

  factory FoodRecipe.fromMap(Map<String, dynamic> map) {
    return FoodRecipe(
      id: map['id'],
      userId: map['user_id'],
      recipeName: map['recipe_name'],
      recipeDescription: map['recipe_description'],
      imagePath: map['image_path'],
      isPopular: map['is_popular'] == 1,
    );
  }
}
