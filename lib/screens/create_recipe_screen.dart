import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/services/recipe_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:finance_track/l10n/app_translations.dart';

class CreateRecipeScreen extends StatefulWidget {
  final String profileName;
  final Recipe? existingRecipe;
  const CreateRecipeScreen({super.key, required this.profileName, this.existingRecipe});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _titleController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final _instructionController = TextEditingController();

  final List<Ingredient> _ingredients = [];
  final List<String> _instructions = [];
  Duration _selectedDuration = Duration.zero;

  bool _isAddingInstruction = false;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.existingRecipe != null) {
      _titleController.text = widget.existingRecipe!.title;
      _selectedDuration = Duration(seconds: widget.existingRecipe!.estimatedTimeSeconds);
      _ingredients.addAll(widget.existingRecipe!.ingredients);
      _instructions.addAll(widget.existingRecipe!.instructions);
      _selectedImagePath = widget.existingRecipe!.imagePath;
    }
  }

  void _saveRecipe() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final recipe = Recipe(
      id: widget.existingRecipe?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      estimatedTimeMinutes: _selectedDuration.inMinutes,
      estimatedTimeSeconds: _selectedDuration.inSeconds,
      ingredients: _ingredients,
      instructions: _instructions,
      imagePath: _selectedImagePath,
    );

    await RecipeService.saveRecipe(widget.profileName, recipe);
    if (mounted) {
      Navigator.pop(context, recipe);
    }
  }

  void _addIngredient() {
    final text = _ingredientController.text.trim();
    final quantity = _ingredientQuantityController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _ingredients.add(Ingredient(name: text, quantity: quantity));
        _ingredientController.clear();
        _ingredientQuantityController.clear();
      });
    }
  }

  void _addInstruction() {
    final text = _instructionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _instructions.add(text);
        _instructionController.clear();
        _isAddingInstruction = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppTheme.primary),
                title: Text('Take Photo', style: TextStyle(color: AppTheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppTheme.primary),
                title: Text('Choose from Gallery', style: TextStyle(color: AppTheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImagePath != null) ...[
                const Divider(),
                ListTile(
                  leading: Icon(Icons.delete, color: AppTheme.error),
                  title: Text('Remove Image', style: TextStyle(color: AppTheme.error)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImagePath = null;
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientController.dispose();
    _ingredientQuantityController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    final List<String> parts = [];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');
    return parts.join(' ');
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 320,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('select_cooking_duration'),
                      style: TextStyle(
                        color: AppTheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        context.tr('done'),
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: AppTheme.isDark ? Brightness.dark : Brightness.light,
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 20,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hms,
                    initialTimerDuration: _selectedDuration,
                    onTimerDurationChanged: (Duration newDuration) {
                      setState(() {
                        _selectedDuration = newDuration;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppTheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('create_recipe'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: Text(
              context.tr('save_recipe'),
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Upload Section
              GestureDetector(
                onTap: _showImageSourceBottomSheet,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.outlineVariant,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    image: _selectedImagePath != null
                        ? DecorationImage(
                            image: kIsWeb
                                ? NetworkImage(_selectedImagePath!) as ImageProvider
                                : FileImage(File(_selectedImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImagePath == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: AppTheme.warmShadow,
                              ),
                              child: Icon(
                                Icons.photo_camera,
                                color: AppTheme.onPrimaryContainer,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.tr('add_cover_photo'),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),


  // Basic Info Section
              Text(
                context.tr('recipe_title'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.onSurface,
                    ),
                decoration: InputDecoration(
                  hintText: context.tr('e_g_pancakes'),
                  hintStyle: TextStyle(color: AppTheme.outline),
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                context.tr('estimated_time'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showTimePicker,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: AppTheme.outline),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDuration == Duration.zero
                              ? context.tr('tap_to_select_duration')
                              : _formatDuration(_selectedDuration),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: _selectedDuration == Duration.zero
                                    ? AppTheme.outline
                                    : AppTheme.onSurface,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Ingredients Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.warmShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_basket, color: AppTheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          context.tr('ingredients'),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Divider(height: 32, color: AppTheme.surfaceContainerHigh),
                    ..._ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryContainer,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (ingredient.quantity.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                                      child: Text(
                                        ingredient.quantity,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      ingredient.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppTheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppTheme.error, size: 20),
                              onPressed: () {
                                setState(() {
                                  _ingredients.remove(ingredient);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _ingredientQuantityController,
                            decoration: InputDecoration(
                              hintText: context.tr('quantity_hint'),
                              hintStyle: TextStyle(color: AppTheme.outline),
                              filled: true,
                              fillColor: AppTheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _ingredientController,
                            decoration: InputDecoration(
                              hintText: context.tr('add_ingredient'),
                              hintStyle: TextStyle(color: AppTheme.outline),
                              filled: true,
                              fillColor: AppTheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            onSubmitted: (_) => _addIngredient(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                          onPressed: _addIngredient,
                          child: Text(context.tr('add_button'), style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Instructions Section
              Row(
                children: [
                  Icon(Icons.restaurant_menu, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('instructions'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ..._instructions.asMap().entries.map((entry) {
                int index = entry.key;
                String instruction = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.warmShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.outlineVariant,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          instruction,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: AppTheme.outline, size: 20),
                        onPressed: () {
                          setState(() {
                            _instructions.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              if (_isAddingInstruction)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_instructions.length + 1}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextField(
                              controller: _instructionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: context.tr('describe_this_step'),
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryContainer,
                                foregroundColor: AppTheme.onPrimaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              onPressed: _addInstruction,
                              child: Text(context.tr('done'), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isAddingInstruction = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.onSurfaceVariant,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    side: BorderSide(color: AppTheme.outlineVariant, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline),
                      const SizedBox(width: 8),
                      Text(context.tr('add_another_step'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
