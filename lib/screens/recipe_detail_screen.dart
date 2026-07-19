import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/services/recipe_service.dart';
import 'package:finance_track/services/recipe_timer_service.dart';
import 'package:finance_track/screens/create_recipe_screen.dart';
import 'package:finance_track/l10n/app_translations.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String profileName;
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.profileName, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;
  int _selectedTabIndex = 0;
  Set<int> get _checkedIngredients => RecipeTimerService().getCheckedIngredients(_recipe.id);

  late ScrollController _scrollController;
  bool _showCollapsedTitle = false;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    RecipeTimerService().activeRecipeId = _recipe.id;
    RecipeTimerService().addListener(_onTimerServiceUpdate);
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    RecipeTimerService().removeListener(_onTimerServiceUpdate);
    _scrollController.dispose();
    if (RecipeTimerService().activeRecipeId == _recipe.id) {
      RecipeTimerService().activeRecipeId = null;
    }
    super.dispose();
  }

  void _onTimerServiceUpdate() async {
    if (mounted) {
      final recipes = await RecipeService.getRecipes(widget.profileName);
      final latest = recipes.firstWhere((r) => r.id == _recipe.id, orElse: () => _recipe);
      if (mounted) {
        setState(() {
          _recipe = latest;
        });
      }
    }
  }

  void _scrollListener() {
    if (!mounted) return;
    final expandedHeight = MediaQuery.of(context).size.height * 0.45;
    final collapsedHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    
    if (_scrollController.hasClients && _scrollController.offset > (expandedHeight - collapsedHeight - 48)) {
      if (!_showCollapsedTitle) {
        setState(() {
          _showCollapsedTitle = true;
        });
      }
    } else {
      if (_showCollapsedTitle) {
        setState(() {
          _showCollapsedTitle = false;
        });
      }
    }
  }

  void _startTimer() {
    if (_recipe.estimatedTimeSeconds <= 0) return;
    RecipeTimerService().startTimer(widget.profileName, _recipe.id, _recipe.title, _recipe.estimatedTimeSeconds, () {});
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

  void _cancelTimer() {
    RecipeTimerService().cancelTimer(_recipe.id);
  }

  String get _formattedTimer {
    final remaining = RecipeTimerService().getSecondsRemaining(_recipe.id);
    int minutes = remaining ~/ 60;
    int seconds = remaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _allIngredientsChecked => _checkedIngredients.length == _recipe.ingredients.length && _recipe.ingredients.isNotEmpty;

  Widget _buildFab() {
    final isTimerRunning = RecipeTimerService().isTimerRunning(_recipe.id);
    if (isTimerRunning) {
      return FloatingActionButton.extended(
        backgroundColor: AppTheme.error,
        foregroundColor: AppTheme.onError,
        onPressed: _cancelTimer,
        icon: const Icon(Icons.stop),
        label: Text(_formattedTimer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'monospace')),
      );
    }

    if (!_allIngredientsChecked) {
      return FloatingActionButton.extended(
        backgroundColor: AppTheme.surfaceContainerHighest,
        foregroundColor: AppTheme.onSurfaceVariant,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('gather_ingredients_first')),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.onSurface,
            ),
          );
        },
        icon: const Icon(Icons.shopping_basket),
        label: Text(context.tr('gather_ingredients'), style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    return FloatingActionButton.extended(
      backgroundColor: AppTheme.primary,
      foregroundColor: AppTheme.onPrimary,
      onPressed: _startTimer,
      icon: const Icon(Icons.restaurant),
      label: Text(context.tr('start_cooking')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildMainContent(context),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.45,
      pinned: true,
      backgroundColor: AppTheme.surface,
      elevation: 0,
      title: _showCollapsedTitle
          ? Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                _recipe.title,
                style: TextStyle(
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
          : null,
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.edit, color: RecipeTimerService().isTimerRunning(_recipe.id) ? AppTheme.outline : AppTheme.primary),
              onPressed: RecipeTimerService().isTimerRunning(_recipe.id)
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.tr('cannot_edit_timer_running')),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.error,
                      ),
                    );
                  }
                : () async {
                final updatedRecipe = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRecipeScreen(profileName: widget.profileName, existingRecipe: _recipe)),
                );
                if (updatedRecipe != null && updatedRecipe is Recipe) {
                  setState(() {
                    _recipe = updatedRecipe;
                  });
                }
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero Image
            _recipe.imagePath != null
                ? (kIsWeb
                    ? Image.network(
                        _recipe.imagePath!,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_recipe.imagePath!),
                        fit: BoxFit.cover,
                      ))
                : Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuD8VxZ0yWexXEr8HYeBIr1guJfGm4e54ObTQdeDukvxx0cQXysVbFMyxW8MMznhT2lImi8zLb09cEwNoJeTZtkDO1iMv3yHf-cnSAXlbAjX-XkMBscQyYB4M_yxDBm8uhCng_64NhpdRvHP1HeZeuJ-3QqoKTnd0CN02WJ8OilSAKw4txxUhEIRP3zZi4nrYg1NgH6qIG7_Yaj0i8ehtdosDP00Ml3bBNt637W55DdKsnn1mGr2l-lpK7UZ4t3AWrnB9PwQL_kTtnIi',
                    fit: BoxFit.cover,
                  ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            // Title Card Overlaid at Bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: const Offset(0, 48), // Push it halfway down
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Tags
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryContainer.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'RECIPE',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _recipe.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_recipe.cookedCount > 0) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryContainer.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${context.tr('cooked')}${_recipe.cookedCount} ${_recipe.cookedCount == 1 ? context.tr('time') : context.tr('times')}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, size: 20, color: AppTheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              _formatDuration(_recipe.estimatedTimeSeconds),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.outlineVariant)),
                            const SizedBox(width: 16),
                            Icon(Icons.local_fire_department, size: 20, color: AppTheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              context.tr('easy'),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 80), // Spacer for overlapping card
          // Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 0 ? AppTheme.surface : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedTabIndex == 0
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                            : null,
                      ),
                      child: Text(
                        context.tr('ingredients'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedTabIndex == 0 ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 1 ? AppTheme.surface : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedTabIndex == 1
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                            : null,
                      ),
                      child: Text(
                        context.tr('instructions'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedTabIndex == 1 ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Content Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppTheme.surfaceContainerHighest.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 40,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: _selectedTabIndex == 0 ? _buildIngredientsList() : _buildInstructionsList(),
          ),
          const SizedBox(height: 120), // Spacer for FAB
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              context.tr('gather_these_items'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_recipe.ingredients.length} ${context.tr('items')}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        if (_recipe.ingredients.isEmpty)
          Text(context.tr('no_ingredients'), style: TextStyle(color: AppTheme.onSurfaceVariant))
        else
          ..._recipe.ingredients.asMap().entries.map((entry) {
            int index = entry.key;
            Ingredient ingredient = entry.value;
            bool isChecked = _checkedIngredients.contains(index);

            final isTimerRunning = RecipeTimerService().isTimerRunning(_recipe.id);

             return InkWell(
              onTap: isTimerRunning
                  ? null
                  : () {
                      RecipeTimerService().toggleIngredientChecked(_recipe.id, index, !isChecked);
                    },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: isTimerRunning
                            ? null
                            : (val) {
                                RecipeTimerService().toggleIngredientChecked(_recipe.id, index, val == true);
                              },
                        activeColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: BorderSide(color: AppTheme.outline, width: 2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ingredient.quantity.isNotEmpty)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 16.0),
                              child: Text(
                                ingredient.quantity,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: isChecked ? AppTheme.onSurface.withOpacity(0.5) : AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              ingredient.name,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isChecked ? AppTheme.onSurface.withOpacity(0.5) : AppTheme.onSurface,
                                decoration: isChecked ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildInstructionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('follow_these_steps'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        if (_recipe.instructions.isEmpty)
          Text(context.tr('no_instructions'), style: TextStyle(color: AppTheme.onSurfaceVariant))
        else
          ..._recipe.instructions.asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      step,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
