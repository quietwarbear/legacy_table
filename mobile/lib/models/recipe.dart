class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String? story;
  final List<String>? photos;
  final int? cookingTime;
  final int? servings;
  final String? category;
  final String? difficulty;
  final String authorId;
  final String? authorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.story,
    this.photos,
    this.cookingTime,
    this.servings,
    this.category,
    this.difficulty,
    required this.authorId,
    this.authorName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] ?? '',
      story: json['story'],
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : null,
      cookingTime: json['cooking_time'] ?? json['cookingTime'],
      servings: json['servings'],
      category: json['category'],
      difficulty: json['difficulty'],
      authorId: json['author_id'] ?? json['authorId'] ?? '',
      authorName: json['author_name'] ?? json['authorName'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      if (story != null) 'story': story,
      if (photos != null) 'photos': photos,
      if (cookingTime != null) 'cooking_time': cookingTime,
      if (servings != null) 'servings': servings,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }
}

class CreateRecipeRequest {
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String? story;
  final List<String>? photos;
  final int? cookingTime;
  final int? servings;
  final String? category;
  final String? difficulty;

  CreateRecipeRequest({
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.story,
    this.photos,
    this.cookingTime,
    this.servings,
    this.category,
    this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      if (story != null) 'story': story,
      if (photos != null) 'photos': photos ?? [],
      if (cookingTime != null) 'cooking_time': cookingTime,
      if (servings != null) 'servings': servings,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }
}

class UpdateRecipeRequest {
  final String? title;
  final List<String>? ingredients;
  final String? instructions;
  final String? story;
  final List<String>? photos;
  final int? cookingTime;
  final int? servings;
  final String? category;
  final String? difficulty;

  UpdateRecipeRequest({
    this.title,
    this.ingredients,
    this.instructions,
    this.story,
    this.photos,
    this.cookingTime,
    this.servings,
    this.category,
    this.difficulty,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (title != null) json['title'] = title;
    if (ingredients != null) json['ingredients'] = ingredients;
    if (instructions != null) json['instructions'] = instructions;
    if (story != null) json['story'] = story;
    if (photos != null) json['photos'] = photos;
    if (cookingTime != null) json['cooking_time'] = cookingTime;
    if (servings != null) json['servings'] = servings;
    if (category != null) json['category'] = category;
    if (difficulty != null) json['difficulty'] = difficulty;
    return json;
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
