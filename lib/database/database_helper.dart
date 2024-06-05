import 'dart:async';
import 'dart:io';
import 'package:food_repo/entities/food_recipe.dart';
import 'package:food_repo/entities/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "food_repo.db");
    return await openDatabase(path,
        version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE FoodRecipe (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        recipe_name TEXT NOT NULL,
        recipe_description TEXT NOT NULL,
        image_path TEXT NOT NULL,
        is_popular INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES User (id) ON DELETE CASCADE
      )
    ''');

    await db.insert('User', {
      'username': 'user1',
      'password': 'password1',
      'email': 'user1@example.com'
    });
    await db.insert('User', {
      'username': 'user2',
      'password': 'password2',
      'email': 'user2@example.com'
    });
    await db.insert('User', {
      'username': 'user3',
      'password': 'password3',
      'email': 'user3@example.com'
    });

    // Kullanıcıların ID'lerini alın
    List<Map<String, dynamic>> users = await db.query('User');
    for (var user in users) {
      int userId = user['id'];

      // Örnek tarifleri ekleyin
      await db.insert('FoodRecipe', {
        'user_id': userId,
        'recipe_name': 'Recipe 1 for ${user['username']}',
        'recipe_description': 'Delicious recipe 1',
        'image_path':
            'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        'is_popular': 1
      });
      await db.insert('FoodRecipe', {
        'user_id': userId,
        'recipe_name': 'Recipe 2 for ${user['username']}',
        'recipe_description': 'Delicious recipe 2',
        'image_path':
            'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        'is_popular': 1
      });
      await db.insert('FoodRecipe', {
        'user_id': userId,
        'recipe_name': 'Recipe 3 for ${user['username']}',
        'recipe_description': 'Delicious recipe 3',
        'image_path':
            'https://images.pexels.com/photos/1752506/pexels-photo-1752506.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        'is_popular': 1
      });
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.delete('User');
      await db.delete('FoodRecipe');
      // Örnek kullanıcıları ekleyin
      await db.insert('User', {
        'username': 'user1',
        'password': 'password1',
        'email': 'user1@example.com'
      });
      await db.insert('User', {
        'username': 'user2',
        'password': 'password2',
        'email': 'user2@example.com'
      });
      await db.insert('User', {
        'username': 'user3',
        'password': 'password3',
        'email': 'user3@example.com'
      });

      // Kullanıcıların ID'lerini alın
      List<Map<String, dynamic>> users = await db.query('User');
      for (var user in users) {
        int userId = user['id'];

        // Örnek tarifleri ekleyin
        await db.insert('FoodRecipe', {
          'user_id': userId,
          'recipe_name': 'Recipe 1 for ${user['username']}',
          'recipe_description': 'Delicious recipe 1',
          'image_path':
              'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'is_popular': 1
        });
        await db.insert('FoodRecipe', {
          'user_id': userId,
          'recipe_name': 'Recipe 2 for ${user['username']}',
          'recipe_description': 'Delicious recipe 2',
          'image_path':
              'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'is_popular': 1
        });
        await db.insert('FoodRecipe', {
          'user_id': userId,
          'recipe_name': 'Recipe 3 for ${user['username']}',
          'recipe_description': 'Delicious recipe 3',
          'image_path':
              'https://images.pexels.com/photos/1752506/pexels-photo-1752506.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          'is_popular': 1
        });
      }
    }
  }

  Future<int> insertUser(User user) async {
    Database db = await _instance.database;
    return await db.insert('User', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> results =
        await db.query('User', where: 'username = ?', whereArgs: [username]);
    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> results =
        await db.query('User', where: 'email = ?', whereArgs: [email]);
    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  Future<int> insertFoodRecipe(FoodRecipe recipe) async {
    Database db = await _instance.database;
    return await db.insert('FoodRecipe', recipe.toMap());
  }

  Future<List<FoodRecipe>> getAllFoodRecipes() async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> results = await db.query('FoodRecipe');
    return results.map((recipe) => FoodRecipe.fromMap(recipe)).toList();
  }

  Future<List<FoodRecipe>> getFoodRecipesByUserId(int userId) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> results =
        await db.query('FoodRecipe', where: 'user_id = ?', whereArgs: [userId]);
    return results.map((recipe) => FoodRecipe.fromMap(recipe)).toList();
  }

  Future<int> updateUser(User user) async {
    Database db = await _instance.database;
    return await db.update(
      'User',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static final DatabaseHelper instance = DatabaseHelper._internal();
}
