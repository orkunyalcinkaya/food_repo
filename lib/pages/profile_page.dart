import 'package:flutter/material.dart';
import 'package:food_repo/entities/food_recipe.dart';
import 'package:food_repo/entities/user.dart';
import 'package:food_repo/database/database_helper.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper.instance;
  List<FoodRecipe> _userRecipes = [];
  final String defaultUserImgUrl =
      "https://as2.ftcdn.net/v2/jpg/00/78/63/55/1000_F_78635516_6zc2RB4GV4Pq7j0bUvCZG56iFbA4axUW.jpg"; // Static URL

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
  }

  Future<void> _loadUserRecipes() async {
    final recipes = await dbHelper.getFoodRecipesByUserId(widget.user.id!);
    setState(() {
      _userRecipes = recipes;
    });
  }

  void _addRecipe() async {
    final TextEditingController recipeNameController = TextEditingController();
    final TextEditingController recipeDescriptionController =
        TextEditingController();
    final TextEditingController imagePathController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Recipe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: recipeNameController,
                decoration: const InputDecoration(hintText: "Recipe Name"),
              ),
              TextField(
                controller: recipeDescriptionController,
                decoration:
                    const InputDecoration(hintText: "Recipe Description"),
              ),
              TextField(
                controller: imagePathController,
                decoration: const InputDecoration(hintText: "Image URL"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                final newRecipe = FoodRecipe(
                  userId: widget.user.id!,
                  recipeName: recipeNameController.text,
                  recipeDescription: recipeDescriptionController.text,
                  imagePath: imagePathController.text,
                  isPopular: true,
                );

                await dbHelper.insertFoodRecipe(newRecipe);
                _loadUserRecipes();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addRecipe,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(defaultUserImgUrl), // Static URL
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome ${widget.user.username}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tariflerim',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RecipeList(recipes: _userRecipes),
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
            // Diğer özellikleri buraya ekleyebilirsiniz
          ),
        );
      },
    );
  }
}
