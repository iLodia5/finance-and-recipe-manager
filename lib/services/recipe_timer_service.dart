import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finance_track/services/recipe_service.dart';
import 'package:finance_track/l10n/app_translations.dart';

class RunningTimer {
  final String profileName;
  final String recipeId;
  final String recipeTitle;
  int secondsRemaining;
  Timer? timer;

  RunningTimer({
    required this.profileName,
    required this.recipeId,
    required this.recipeTitle,
    required this.secondsRemaining,
    this.timer,
  });
}

class RecipeTimerService extends ChangeNotifier {
  static final RecipeTimerService _instance = RecipeTimerService._internal();
  factory RecipeTimerService() => _instance;
  RecipeTimerService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Map<String, RunningTimer> _activeTimers = {};
  final Map<String, Set<int>> _checkedIngredients = {};
  String? activeRecipeId;

  Map<String, RunningTimer> get activeTimers => _activeTimers;

  Set<int> getCheckedIngredients(String recipeId) {
    return _checkedIngredients[recipeId] ??= {};
  }

  void toggleIngredientChecked(String recipeId, int index, bool checked) {
    final set = getCheckedIngredients(recipeId);
    if (checked) {
      set.add(index);
    } else {
      set.remove(index);
    }
    notifyListeners();
  }

  bool isTimerRunning(String recipeId) {
    return _activeTimers.containsKey(recipeId);
  }

  int getSecondsRemaining(String recipeId) {
    return _activeTimers[recipeId]?.secondsRemaining ?? 0;
  }

  RunningTimer? getLowestActiveTimer() {
    if (_activeTimers.isEmpty) return null;
    RunningTimer? lowest;
    for (var timer in _activeTimers.values) {
      if (lowest == null || timer.secondsRemaining < lowest.secondsRemaining) {
        lowest = timer;
      }
    }
    return lowest;
  }

  void startTimer(String profileName, String recipeId, String title, int durationSeconds, Function() onComplete) {
    cancelTimer(recipeId);

    final runningTimer = RunningTimer(
      profileName: profileName,
      recipeId: recipeId,
      recipeTitle: title,
      secondsRemaining: durationSeconds,
    );

    runningTimer.timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (runningTimer.secondsRemaining > 0) {
        runningTimer.secondsRemaining--;
        notifyListeners();
      } else {
        t.cancel();
        _activeTimers.remove(recipeId);
        _checkedIngredients[recipeId]?.clear();
        _incrementRecipeCookedCount(runningTimer.profileName, recipeId);
        notifyListeners();
        _showGlobalTimerCompleteDialog(runningTimer.recipeTitle);
        onComplete();
      }
    });

    _activeTimers[recipeId] = runningTimer;
    notifyListeners();
  }

  Future<void> _incrementRecipeCookedCount(String profileName, String recipeId) async {
    try {
      final recipes = await RecipeService.getRecipes(profileName);
      final index = recipes.indexWhere((r) => r.id == recipeId);
      if (index >= 0) {
        final updatedRecipe = recipes[index].copyWith(
          cookedCount: recipes[index].cookedCount + 1,
        );
        await RecipeService.saveRecipe(profileName, updatedRecipe);
      }
    } catch (e) {
      // ignore
    }
  }

  void cancelTimer(String recipeId) {
    if (_activeTimers.containsKey(recipeId)) {
      _activeTimers[recipeId]?.timer?.cancel();
      _activeTimers.remove(recipeId);
      notifyListeners();
    }
  }

  void _showGlobalTimerCompleteDialog(String recipeTitle) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.restaurant, color: isDark ? const Color(0xFFFFB59B) : const Color(0xFF9F4122)),
              const SizedBox(width: 8),
              Text(
                context.tr('meal_is_ready'),
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF2C160E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            '${context.tr('timer_finished_1')}$recipeTitle${context.tr('timer_finished_2')}',
            style: TextStyle(
              color: isDark ? const Color(0xFFFBECE8) : const Color(0xFF2C160E),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr('awesome'),
                style: TextStyle(
                  color: isDark ? const Color(0xFFFFB59B) : const Color(0xFF9F4122),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    for (var runningTimer in _activeTimers.values) {
      runningTimer.timer?.cancel();
    }
    _activeTimers.clear();
    super.dispose();
  }
}
