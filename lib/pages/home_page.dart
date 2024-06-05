import 'package:flutter/material.dart';
import 'package:food_repo/constants/assets.dart';
import 'package:food_repo/entities/food_recipe.dart';
import 'package:food_repo/entities/user.dart';
import 'package:food_repo/pages/profile_page.dart';
import 'package:food_repo/database/database_helper.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  List<FoodRecipe> _popularRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadPopularRecipes();
  }

  Future<void> _loadPopularRecipes() async {
    final recipes = await dbHelper.getAllFoodRecipes();
    setState(() {
      _popularRecipes =
          recipes.where((food) => food.isPopular == true).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange, // Turuncu arkaplan
        title: const Text(
          'FoodRepo',
          style: TextStyle(
            color: Colors.white,
            fontFamily: chocolate,
            fontStyle: FontStyle.italic,
          ), // Beyaz yazı
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user)),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome ${widget.user.username}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Popüler Tarifler',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RecipeList(recipes: _popularRecipes),
          ),
        ],
      ),
    );
  }
}

class RecipeList extends StatelessWidget {
  final List<FoodRecipe> recipes;

  const RecipeList({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(recipe.imagePath),
            ),
            title: Text(recipe.recipeName),
            subtitle: Text(recipe.recipeDescription),
          ),
        );
      },
    );
  }
}
