import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json['name'] ?? '',
        quantity: json['quantity'] ?? '',
      );
}

class Recipe {
  final String id;
  final String title;
  final int estimatedTimeMinutes;
  final int estimatedTimeSeconds;
  final int cookedCount;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final String? imagePath;

  Recipe({
    required this.id,
    required this.title,
    required this.estimatedTimeMinutes,
    required this.estimatedTimeSeconds,
    this.cookedCount = 0,
    required this.ingredients,
    required this.instructions,
    this.imagePath,
  });

  Recipe copyWith({
    String? id,
    String? title,
    int? estimatedTimeMinutes,
    int? estimatedTimeSeconds,
    int? cookedCount,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    String? imagePath,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
      estimatedTimeSeconds: estimatedTimeSeconds ?? this.estimatedTimeSeconds,
      cookedCount: cookedCount ?? this.cookedCount,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'estimatedTimeMinutes': estimatedTimeMinutes,
        'estimatedTimeSeconds': estimatedTimeSeconds,
        'cookedCount': cookedCount,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'instructions': instructions,
        'imagePath': imagePath,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final minutes = json['estimatedTimeMinutes'] ?? 0;
    final seconds = json['estimatedTimeSeconds'] ?? (minutes * 60);
    final count = json['cookedCount'] ?? 0;
    return Recipe(
      id: json['id'],
      title: json['title'],
      estimatedTimeMinutes: minutes,
      estimatedTimeSeconds: seconds,
      cookedCount: count,
      ingredients: _parseIngredients(json['ingredients']),
      instructions: List<String>.from(json['instructions'] ?? []),
      imagePath: json['imagePath'],
    );
  }

  static List<Ingredient> _parseIngredients(dynamic ingredientsJson) {
    if (ingredientsJson == null) return [];
    if (ingredientsJson is List) {
      return ingredientsJson.map((item) {
        if (item is String) {
          return Ingredient(name: item, quantity: '');
        } else if (item is Map<String, dynamic>) {
          return Ingredient.fromJson(item);
        }
        return Ingredient(name: 'Unknown', quantity: '');
      }).toList();
    }
    return [];
  }
}

class RecipeService {
  static Future<List<Recipe>> getRecipes(String profileName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('recipes_$profileName');
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveRecipe(String profileName, Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = await getRecipes(profileName);
    
    // Update if exists, else add
    final index = recipes.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      recipes[index] = recipe;
    } else {
      recipes.add(recipe);
    }
    
    final String jsonString = jsonEncode(
      recipes.map((r) => r.toJson()).toList(),
    );
    await prefs.setString('recipes_$profileName', jsonString);
  }

  static Future<void> removeRecipe(String profileName, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = await getRecipes(profileName);
    
    recipes.removeWhere((r) => r.id == id);
    
    final String jsonString = jsonEncode(
      recipes.map((r) => r.toJson()).toList(),
    );
    await prefs.setString('recipes_$profileName', jsonString);
  }
}
