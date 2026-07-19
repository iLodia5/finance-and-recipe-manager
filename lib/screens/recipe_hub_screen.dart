import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/services/recipe_service.dart';
import 'package:finance_track/services/recipe_timer_service.dart';
import 'package:finance_track/screens/create_recipe_screen.dart';
import 'package:finance_track/screens/recipe_detail_screen.dart';
import 'package:finance_track/screens/settings_screen.dart';
import 'package:finance_track/screens/onboarding_select_profile_screen.dart';
import 'package:finance_track/l10n/app_translations.dart';

class RecipeHubScreen extends StatefulWidget {
  final String profileName;
  const RecipeHubScreen({super.key, required this.profileName});

  @override
  State<RecipeHubScreen> createState() => _RecipeHubScreenState();
}

class _RecipeHubScreenState extends State<RecipeHubScreen> {
  late Future<List<Recipe>> _recipesFuture;
  bool _isDeleteMode = false;
  bool _isCardView = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      _recipesFuture = RecipeService.getRecipes(widget.profileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          context.tr('recipe_hub'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isCardView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: AppTheme.primary,
            ),
            onPressed: () {
              setState(() {
                _isCardView = !_isCardView;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _isDeleteMode ? Icons.check_circle : Icons.delete,
              color: _isDeleteMode
                  ? AppTheme.primary
                  : AppTheme.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _isDeleteMode = !_isDeleteMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: AppTheme.onSurfaceVariant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: context.tr('search_recipes'),
                prefixIcon: Icon(Icons.search, color: AppTheme.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppTheme.onSurfaceVariant),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppTheme.primary));
                }

                final recipes = snapshot.data ?? [];

                if (recipes.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildRecipeList(recipes);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateRecipeScreen(profileName: widget.profileName),
            ),
          );
          _loadRecipes();
        },
        icon: const Icon(Icons.add),
        label: Text(context.tr('add_recipe')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 64,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              context.tr('your_kitchen_empty'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              context.tr('start_building_cookbook'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '0s';
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    final List<String> parts = [];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');
    return parts.join(' ');
  }

  Widget _buildRecipeList(List<Recipe> allRecipes) {
    final timerService = RecipeTimerService();
    final recipes = allRecipes.where((r) => r.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        if (recipes.isEmpty) {
          return Center(
            child: Text(
              context.tr('your_kitchen_empty'), // Reusing translation for empty search
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            final isTimerRunning = timerService.isTimerRunning(recipe.id);
            final remainingSeconds = timerService.getSecondsRemaining(recipe.id);

            String formatTimer(int totalSeconds) {
              int minutes = totalSeconds ~/ 60;
              int seconds = totalSeconds % 60;
              return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
            }

            if (_isCardView) {
              return _buildLargeCardRecipeItem(recipe, isTimerRunning, remainingSeconds, formatTimer);
            } else {
              return _buildCompactRecipeItem(recipe, isTimerRunning, remainingSeconds, formatTimer);
            }
          },
        );
      },
    );
  }

  Widget _buildCompactRecipeItem(Recipe recipe, bool isTimerRunning, int remainingSeconds, String Function(int) formatTimer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppTheme.warmShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: _isDeleteMode ? null : () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(profileName: widget.profileName, recipe: recipe),
              ),
            );
            _loadRecipes();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    image: recipe.imagePath != null
                        ? DecorationImage(
                            image: kIsWeb 
                                ? NetworkImage(recipe.imagePath!) as ImageProvider
                                : FileImage(File(recipe.imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: recipe.imagePath == null
                      ? Icon(
                          Icons.fastfood,
                          color: AppTheme.primary,
                          size: 32,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: AppTheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(recipe.estimatedTimeSeconds),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppTheme.outline,
                                ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.shopping_basket,
                            size: 16,
                            color: AppTheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.ingredients.length} ${context.tr('items')}',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppTheme.outline,
                                ),
                          ),
                          if (recipe.cookedCount > 0) ...[
                            const SizedBox(width: 16),
                            Icon(
                              Icons.restaurant,
                              size: 16,
                              color: AppTheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe.cookedCount}',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.outline,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isDeleteMode)
                  IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: AppTheme.error,
                      size: 28,
                    ),
                    onPressed: () async {
                      await RecipeService.removeRecipe(widget.profileName, recipe.id);
                      _loadRecipes();
                    },
                  )
                else ...[
                  if (isTimerRunning)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hourglass_bottom, size: 16, color: AppTheme.onErrorContainer),
                          const SizedBox(width: 4),
                          Text(
                            formatTimer(remainingSeconds),
                            style: TextStyle(
                              color: AppTheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppTheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCardRecipeItem(Recipe recipe, bool isTimerRunning, int remainingSeconds, String Function(int) formatTimer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppTheme.warmShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: _isDeleteMode ? null : () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(profileName: widget.profileName, recipe: recipe),
              ),
            );
            _loadRecipes();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Large Image Section
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  image: recipe.imagePath != null
                      ? DecorationImage(
                          image: kIsWeb 
                              ? NetworkImage(recipe.imagePath!) as ImageProvider
                              : FileImage(File(recipe.imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: recipe.imagePath == null
                    ? Icon(
                        Icons.fastfood,
                        color: AppTheme.primary,
                        size: 64,
                      )
                    : null,
              ),
              // Details Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: AppTheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDuration(recipe.estimatedTimeSeconds),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppTheme.outline,
                                    ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.shopping_basket,
                                size: 16,
                                color: AppTheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.ingredients.length} ${context.tr('items')}',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppTheme.outline,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_isDeleteMode)
                      IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: AppTheme.error,
                          size: 28,
                        ),
                        onPressed: () async {
                          await RecipeService.removeRecipe(widget.profileName, recipe.id);
                          _loadRecipes();
                        },
                      )
                    else ...[
                      if (isTimerRunning)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.hourglass_bottom, size: 16, color: AppTheme.onErrorContainer),
                              const SizedBox(width: 4),
                              Text(
                                formatTimer(remainingSeconds),
                                style: TextStyle(
                                  color: AppTheme.onErrorContainer,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
