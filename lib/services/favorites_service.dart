import 'package:flutter/foundation.dart';
import '../models/meal.dart';

class FavoritesService extends ChangeNotifier {
  final Map<String, Meal> _favorites = {};

  List<Meal> get favorites => _favorites.values.toList(growable: false);

  bool isFavorite(Meal meal) => _favorites.containsKey(meal.id);

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal)) {
      _favorites.remove(meal.id);
    } else {
      _favorites[meal.id] = meal;
    }
    notifyListeners();
  }
}