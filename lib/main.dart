import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Recipes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonString = await rootBundle.loadString('assets/data/mobile-apps-portfolio-03-recipes.json');
    setState(() {
      _data = jsonDecode(jsonString);
    });
  }

  Set<String> _getCategories() {
    return _data['recipes'].map<String>((recipe) => recipe['category'] as String).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: _getCategories().map<Widget>((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeScreen(category: category, data: _data),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RecipeScreen extends StatelessWidget {
  final String category;
  final Map<String, dynamic> data;

  const RecipeScreen({super.key, required this.category, required this.data});

Set<Map<String, dynamic>> _getRecipesOfCategory() {
  return Set<Map<String, dynamic>>.from(data['recipes'].where((recipe) => recipe['category'] == category));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView(
        children: _getRecipesOfCategory().map<Widget>((recipe) {
          return ListTile(
            title: Text(recipe['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsScreen(recipe: recipe),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  List<String> _getIngredients() {
    return (recipe['ingredients'] as List).cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
      ),
      body: ListView(
        children: _getIngredients().map<Widget>((ingredient) {
          return ListTile(
            title: Text(ingredient),
          );
        }).toList(),
      ),
    );
  }
}
