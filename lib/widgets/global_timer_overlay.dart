import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/services/recipe_timer_service.dart';
import 'package:finance_track/services/recipe_service.dart';
import 'package:finance_track/screens/recipe_detail_screen.dart';

class GlobalTimerOverlay extends StatelessWidget {
  const GlobalTimerOverlay({super.key});

  String _formatTimer(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timerService = RecipeTimerService();

    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        final lowestTimer = timerService.getLowestActiveTimer();
        if (lowestTimer == null) return const SizedBox.shrink();

        // Don't show overlay if we are currently on the detail screen of this specific recipe
        if (timerService.activeRecipeId == lowestTimer.recipeId) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  // Find the recipe and navigate back to detail screen
                  final recipes = await RecipeService.getRecipes(lowestTimer.profileName);
                  final recipe = recipes.firstWhere(
                    (r) => r.id == lowestTimer.recipeId,
                    orElse: () => Recipe(
                      id: lowestTimer.recipeId,
                      title: lowestTimer.recipeTitle,
                      estimatedTimeMinutes: lowestTimer.secondsRemaining ~/ 60,
                      estimatedTimeSeconds: lowestTimer.secondsRemaining,
                      ingredients: [],
                      instructions: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(profileName: lowestTimer.profileName, recipe: recipe),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          lowestTimer.recipeTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 16,
                        color: AppTheme.primary.withOpacity(0.3),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimer(lowestTimer.secondsRemaining),
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          timerService.cancelTimer(lowestTimer.recipeId);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: AppTheme.onPrimaryContainer.withOpacity(0.6),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
