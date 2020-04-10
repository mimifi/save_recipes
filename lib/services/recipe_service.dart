import 'package:saverecipes/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'recipeTable';
final String id = 'id';
final String recipeName = 'name';
final String photoUrl = 'photoUrl';

class RecipeService {
  Database db;
  Future init;

  RecipeService() {
    init = initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "my_db.db"),
        onCreate: (db, version) {
          return db.execute('''CREATE TABLE $tableName (
        $id	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
            $recipeName	TEXT NOT NULL,
            $photoUrl	TEXT NOT NULL
        )''');
        }, version: 1);
  }

  Future<void> insertRecipe(RecipeModel recipe) async {
    await init;
    try{
      db.insert(tableName, recipe.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch(_) {
      print(_);
    }
  }

  Future<List<RecipeModel>> getAllRecipes () async {
    await init;
    final List<Map<String, dynamic>> recipes = await db.query(tableName);

    return List.generate(recipes.length, (i){
      return RecipeModel(
        recipeName: recipes[i][recipeName],
        photoUrl: recipes[i][photoUrl],
      );
    });
  }
}
