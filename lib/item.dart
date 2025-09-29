import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lifestyle_companion/ui.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  // Hive boxes (make sure you've opened them in main())
  final Box prefBox = Hive.box('pref');
  final Box itemsBox = Hive.box('items');

  // ----------------------
  // MASTER (immutable) data
  // ----------------------
  // masterItems etc. represent the complete unfiltered dataset and
  // should be considered the source of truth.
  late List<String> masterItems;
  late List<String> masterNutritionalValues;
  late List<int> masterCounter; // counters are stored per master index
  late List<int> masterKcalList;
  late List<int> masterProteinList;
  late List<double> masterFatList;

  // ----------------------
  // WORKING (filtered) data
  // ----------------------
  // These are built from the master lists using filteredIndexes.
  List<int> filteredIndexes = []; // indices into master lists
  List<String> filteredItems = [];
  List<String> workingNutritionalValues = [];
  List<int> workingCounter = [];
  List<int> workingKcalList = [];
  List<int> workingProteinList = [];
  List<double> workingFatList = [];


  // Parallel icon list for dietary classification
List<IconData> itemIcons = [
  // Proteins
  Icons.no_meals, // Chicken Breast (Non-Veg)
  Icons.egg,      // Eggs (Eggetarian)
  Icons.egg,      // Egg Whites (Eggetarian)
  Icons.no_meals, // Turkey Breast (Non-Veg)
  Icons.no_meals, // Salmon (Non-Veg - Fish)
  Icons.no_meals, // Tuna (Non-Veg - Fish)
  Icons.no_meals, // Tilapia (Non-Veg - Fish)
  Icons.no_meals, // Shrimp (Non-Veg - Seafood)
  Icons.no_meals, // Lean Beef (Non-Veg)
  Icons.no_meals, // Ground Turkey (Non-Veg)
  Icons.eco,      // Cottage Cheese (Veg)
  Icons.eco,      // Greek Yogurt (Veg)
  Icons.eco,      // Whey Protein (Veg)
  Icons.eco,      // Casein Protein (Veg)
  Icons.eco,      // Tempeh (Veg)
  Icons.eco,      // Tofu (Veg)
  Icons.eco,      // Lentils (Veg)
  Icons.eco,      // Chickpeas (Veg)
  Icons.eco,      // Kidney Beans (Veg)
  Icons.eco,      // Black Beans (Veg)

  // Carbs
  Icons.eco,      // Brown Rice (Veg)
  Icons.eco,      // White Rice (Veg)
  Icons.eco,      // Quinoa (Veg)
  Icons.eco,      // Oats (Veg)
  Icons.eco,      // Sweet Potato (Veg)
  Icons.eco,      // Whole Wheat Bread (Veg)
  Icons.eco,      // Whole Wheat Pasta (Veg)
  Icons.eco,      // Barley (Veg)
  Icons.eco,      // Buckwheat (Veg)
  Icons.eco,      // Potatoes (Veg)
  Icons.eco,      // Corn (Veg)
  Icons.eco,      // Ezekiel Bread (Veg)
  Icons.eco,      // Rice Cakes (Veg)

  // Healthy Fats
  Icons.eco,      // Avocado (Veg)
  Icons.eco,      // Almonds (Veg)
  Icons.eco,      // Walnuts (Veg)
  Icons.eco,      // Peanut Butter (Veg)
  Icons.eco,      // Olive Oil (Veg)
  Icons.eco,      // Chia Seeds (Veg)
  Icons.eco,      // Flax Seeds (Veg)
  Icons.eco,      // Pumpkin Seeds (Veg)
  Icons.eco,      // Cashews (Veg)
  Icons.eco,      // Sunflower Seeds (Veg)

  // Vegetables
  Icons.eco,      // Spinach (Veg)
  Icons.eco,      // Broccoli (Veg)
  Icons.eco,      // Kale (Veg)
  Icons.eco,      // Zucchini (Veg)
  Icons.eco,      // Asparagus (Veg)
  Icons.eco,      // Brussels Sprouts (Veg)
  Icons.eco,      // Bell Peppers (Veg)
  Icons.eco,      // Green Beans (Veg)

  // Snacks / Extras
  Icons.eco,      // Protein Bar (Veg - usually whey/soy)
  Icons.eco,      // Hummus (Veg)
  Icons.eco,      // Dark Chocolate (Veg)
];


  // Current UI state
  String currentQuery = '';
  String? selectedDiet; // e.g., 'Vegan', 'Vegetarian', 'Pescatarian'

  // ---------------------------------
  // Raw original data (as in your code)
  // ---------------------------------
  List<String> allItems = [
    // Proteins
    "Chicken Breast",
    "Eggs",
    "Egg Whites",
    "Turkey Breast",
    "Salmon",
    "Tuna",
    "Tilapia",
    "Shrimp",
    "Lean Beef",
    "Ground Turkey",
    "Cottage Cheese",
    "Greek Yogurt",
    "Whey Protein",
    "Casein Protein",
    "Tempeh",
    "Tofu",
    "Lentils",
    "Chickpeas",
    "Kidney Beans",
    "Black Beans",

    // Carbs
    "Brown Rice",
    "White Rice",
    "Quinoa",
    "Oats",
    "Sweet Potato",
    "Whole Wheat Bread",
    "Whole Wheat Pasta",
    "Barley",
    "Buckwheat",
    "Potatoes",
    "Corn",
    "Ezekiel Bread",
    "Rice Cakes",

    // Healthy Fats
    "Avocado",
    "Almonds",
    "Walnuts",
    "Peanut Butter",
    "Olive Oil",
    "Chia Seeds",
    "Flax Seeds",
    "Pumpkin Seeds",
    "Cashews",
    "Sunflower Seeds",

    // Vegetables
    "Spinach",
    "Broccoli",
    "Kale",
    "Zucchini",
    "Asparagus",
    "Brussels Sprouts",
    "Bell Peppers",
    "Green Beans",

    // Snacks / Extras
    "Protein Bar",
    "Hummus",
    "Dark Chocolate (85%)"
  ];

  List<String> nutritionalValues = [
    // Proteins
    "165 kcal, 31g protein, 3.6g fat per 100g",
    "155 kcal, 13g protein, 11g fat per 100g",
    "52 kcal, 11g protein, 0g fat per 100g",
    "135 kcal, 30g protein, 1g fat per 100g",
    "208 kcal, 20g protein, 13g fat per 100g",
    "132 kcal, 28g protein, 1g fat per 100g",
    "96 kcal, 20g protein, 2g fat per 100g",
    "99 kcal, 24g protein, 0.3g fat per 100g",
    "250 kcal, 26g protein, 15g fat per 100g",
    "170 kcal, 22g protein, 9g fat per 100g",
    "98 kcal, 11g protein, 4g fat per 100g",
    "59 kcal, 10g protein, 0.4g fat per 100g",
    "~120 kcal, 24g protein, 1g fat per scoop (30g)",
    "~110 kcal, 23g protein, 1g fat per scoop (30g)",
    "195 kcal, 19g protein, 11g fat per 100g",
    "76 kcal, 8g protein, 4g fat per 100g",
    "116 kcal, 9g protein, 0.4g fat, 20g carbs per 100g (cooked)",
    "164 kcal, 9g protein, 3g fat, 27g carbs per 100g (cooked)",
    "127 kcal, 9g protein, 0.5g fat, 22g carbs per 100g (cooked)",
    "132 kcal, 9g protein, 0.5g fat, 24g carbs per 100g (cooked)",

    // Carbs
    "111 kcal, 2.6g protein, 0.9g fat, 23g carbs per 100g (cooked)",
    "130 kcal, 2.7g protein, 0.3g fat, 28g carbs per 100g (cooked)",
    "120 kcal, 4g protein, 2g fat, 21g carbs per 100g (cooked)",
    "389 kcal, 17g protein, 7g fat, 66g carbs per 100g (dry)",
    "86 kcal, 1.6g protein, 0.1g fat, 20g carbs per 100g",
    "247 kcal, 13g protein, 4g fat, 41g carbs per 100g",
    "124 kcal, 5g protein, 0.9g fat, 27g carbs per 100g (cooked)",
    "123 kcal, 2.3g protein, 0.4g fat, 28g carbs per 100g (cooked)",
    "92 kcal, 3.4g protein, 0.6g fat, 20g carbs per 100g (cooked)",
    "77 kcal, 2g protein, 0.1g fat, 17g carbs per 100g",
    "86 kcal, 3.2g protein, 1.2g fat, 19g carbs per 100g",
    "80 kcal, 4g protein, 0.5g fat, 15g carbs per slice",
    "35 kcal, 0.7g protein, 0.3g fat, 7.3g carbs per cake",

    // Healthy Fats
    "160 kcal, 2g protein, 15g fat, 9g carbs per 100g",
    "576 kcal, 21g protein, 49g fat, 22g carbs per 100g",
    "654 kcal, 15g protein, 65g fat, 14g carbs per 100g",
    "588 kcal, 25g protein, 50g fat, 20g carbs per 100g",
    "884 kcal, 0g protein, 100g fat, 0g carbs per 100ml",
    "486 kcal, 17g protein, 31g fat, 42g carbs per 100g",
    "534 kcal, 18g protein, 42g fat, 29g carbs per 100g",
    "559 kcal, 30g protein, 49g fat, 11g carbs per 100g",
    "553 kcal, 18g protein, 44g fat, 30g carbs per 100g",
    "584 kcal, 21g protein, 51g fat, 20g carbs per 100g",

    // Vegetables
    "23 kcal, 2.9g protein, 0.4g fat, 3.6g carbs per 100g",
    "34 kcal, 2.8g protein, 0.4g fat, 7g carbs per 100g",
    "49 kcal, 4.3g protein, 0.9g fat, 9g carbs per 100g",
    "17 kcal, 1.2g protein, 0.3g fat, 3.1g carbs per 100g",
    "20 kcal, 2.2g protein, 0.1g fat, 3.9g carbs per 100g",
    "43 kcal, 3.4g protein, 0.3g fat, 9g carbs per 100g",
    "31 kcal, 1g protein, 0.3g fat, 6g carbs per 100g",
    "31 kcal, 1.8g protein, 0.1g fat, 7g carbs per 100g",

    // Snacks / Extras
    "~200 kcal, 20g protein, 7g fat, 20g carbs (per bar)",
    "166 kcal, 8g protein, 9.6g fat, 14g carbs per 100g",
    "600 kcal, 7.9g protein, 43g fat, 46g carbs per 100g",
  ];

  // Temporary parsed lists — these are parsed by buildNutritionalLists()
  List<int> kcalList = [];
  List<int> proteinList = [];
  List<double> fatList = [];

  // -----------------------
  // LIFECYCLE & UTILITIES
  // -----------------------
  @override
  void initState() {
    super.initState();

    // Parse the nutritional strings into numeric lists
    buildNutritionalLists();

    // Build master lists (types must match)
    masterItems = List<String>.from(allItems);
    masterNutritionalValues = List<String>.from(nutritionalValues);
    masterCounter = List<int>.filled(masterItems.length, 0);

    masterKcalList = List<int>.from(kcalList);
    masterProteinList = List<int>.from(proteinList);
    masterFatList = List<double>.from(fatList);

    // load saved preference (use key 'diet' from your SelectPref widget)
    selectedDiet = prefBox.get('diet') as String?;

    // Build the initial filtered/working lists (no setState in initState)
    _updateWorkingLists(notify: false);
  }

  // Parse your nutritionalValues strings into numeric lists.
  void buildNutritionalLists() {
    kcalList = [];
    proteinList = [];
    fatList = [];

    for (var entry in nutritionalValues) {
      // default
      int kcal = 0;
      int protein = 0;
      double fat = 0.0;

      final parts = entry.split(',');
      for (var part in parts) {
        final p = part.trim().toLowerCase();
        if (p.contains('kcal')) {
          // find first number in string
          final numStr = RegExp(r'[\d]+').firstMatch(p)?.group(0);
          kcal = int.tryParse(numStr ?? '') ?? 0;
        } else if (p.contains('protein')) {
          final match = RegExp(r'[\d]+').firstMatch(p);
          protein = int.tryParse(match?.group(0) ?? '') ?? 0;
        } else if (p.contains('fat')) {
          final match = RegExp(r'[\d]+(\.[\d]+)?').firstMatch(p);
          fat = double.tryParse(match?.group(0) ?? '') ?? 0.0;
        }
      }

      kcalList.add(kcal);
      proteinList.add(protein);
      fatList.add(fat);
    }
  }

  // Rebuild working (filtered) lists from master lists using filters.
  // If notify==true, calls setState(); otherwise just rebuilds silently (useful in initState).
  void _updateWorkingLists({bool notify = true}) {
    // compute keep indexes based on diet
    final keep = <int>[];
    for (int i = 0; i < masterItems.length; i++) {
      final item = masterItems[i];
      bool remove = false;

      if (selectedDiet != null && selectedDiet != 'No preference') {
        if (selectedDiet == "Vegetarian" &&
            (item.contains("Chicken") ||
                item.contains("Turkey") ||
                item.contains("Beef") ||
                item.contains("Salmon") ||
                item.contains("Tuna") ||
                item.contains("Tilapia") ||
                item.contains("Shrimp"))) {
          remove = true;
        }

        if (selectedDiet == "Vegan" &&
            (item.contains("Chicken") ||
                item.contains("Turkey") ||
                item.contains("Beef") ||
                item.contains("Salmon") ||
                item.contains("Tuna") ||
                item.contains("Tilapia") ||
                item.contains("Shrimp") ||
                item.contains("Egg") ||
                item.contains("Cottage Cheese") ||
                item.contains("Yogurt") ||
                item.contains("Whey Protein") ||
                item.contains("Casein Protein"))) {
          remove = true;
        }

        if (selectedDiet == "Pescatarian" &&
            (item.contains("Chicken") ||
                item.contains("Turkey") ||
                item.contains("Beef"))) {
          remove = true;
        }
      }

      if (!remove) keep.add(i);
    }

    // apply search query filter on top of the diet filter
    List<int> finalIndexes = keep;
    if (currentQuery.isNotEmpty) {
      final q = currentQuery.toLowerCase();
      finalIndexes = keep.where((i) => masterItems[i].toLowerCase().contains(q)).toList();
    }

    // Build working lists from finalIndexes
    filteredIndexes = finalIndexes;
    filteredItems = filteredIndexes.map((i) => masterItems[i]).toList();
    workingNutritionalValues = filteredIndexes.map((i) => masterNutritionalValues[i]).toList();
    workingCounter = filteredIndexes.map((i) => masterCounter[i]).toList();
    workingKcalList = filteredIndexes.map((i) => masterKcalList[i]).toList();
    workingProteinList = filteredIndexes.map((i) => masterProteinList[i]).toList();
    workingFatList = filteredIndexes.map((i) => masterFatList[i]).toList();

    if (notify) setState(() {});
  }

  // Public calls to change filters:
  void applyDietFilter(String? diet) {
    selectedDiet = diet;
    prefBox.put('diet', diet); // persist choice
    _updateWorkingLists();
  }

  void _filterItems(String query) {
    currentQuery = query;
    _updateWorkingLists();
  }

  // Adds one quantity to the item at the displayed index (index into filteredItems).
  void _incrementAt(int displayedIndex) {
    final masterIndex = filteredIndexes[displayedIndex];

    // update master counter
    masterCounter[masterIndex] = masterCounter[masterIndex] + 1;

    // update Hive items box keyed by item name
    final name = masterItems[masterIndex];
    final kcalPerItem = masterKcalList[masterIndex];
    final proteinPerItem = masterProteinList[masterIndex];
    final fatPerItem = masterFatList[masterIndex];

    if (itemsBox.containsKey(name)) {
      final existing = Map<String, dynamic>.from(itemsBox.get(name) as Map);
      final newCount = (existing['counter'] ?? 0) + 1;
      existing['counter'] = newCount;
      existing['kcal'] = kcalPerItem * newCount;
      existing['protein'] = proteinPerItem * newCount;
      existing['fat'] = fatPerItem * newCount;
      itemsBox.put(name, existing);
    } else {
      itemsBox.put(name, {
        "counter": 1,
        "filteredItem": name,
        "nutritionalValues": masterNutritionalValues[masterIndex],
        "kcal": kcalPerItem,
        "protein": proteinPerItem,
        "fat": fatPerItem,
      });
    }

    // refresh UI
    _updateWorkingLists();
  }

  // Remove one quantity from item at displayedIndex
  void _decrementAt(int displayedIndex) {
    final masterIndex = filteredIndexes[displayedIndex];
    final name = masterItems[masterIndex];

    if (masterCounter[masterIndex] > 0) {
      masterCounter[masterIndex] = masterCounter[masterIndex] - 1;

      if (itemsBox.containsKey(name)) {
        final existing = Map<String, dynamic>.from(itemsBox.get(name) as Map);
        final newCount = (existing['counter'] ?? 0) - 1;
        if (newCount <= 0) {
          itemsBox.delete(name);
        } else {
          final kcalPerItem = masterKcalList[masterIndex];
          final proteinPerItem = masterProteinList[masterIndex];
          final fatPerItem = masterFatList[masterIndex];

          existing['counter'] = newCount;
          existing['kcal'] = kcalPerItem * newCount;
          existing['protein'] = proteinPerItem * newCount;
          existing['fat'] = fatPerItem * newCount;
          itemsBox.put(name, existing);
        }
      }
    }

    _updateWorkingLists();
  }

  // -----------------------
  // UI
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.black,
        child: Icon(Icons.check, color: Colors.green),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UiWidget()));
        },
      ),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Select Items', style: GoogleFonts.poppins(color: Colors.white)),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: GoogleFonts.poppins(backgroundColor: Colors.black, color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintStyle: GoogleFonts.poppins(color: Colors.white),
                hintText: 'Search...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.black,
              ),
              onChanged: _filterItems,
            ),
          ),

          // Diet toggle row (quick example to change diet within this screen)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Text('Diet:', style: GoogleFonts.poppins(color: Colors.white)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF2C2C2C),
                  value: selectedDiet ?? 'No preference',
                  items: <String>[
                    'No preference',
                    'Vegetarian',
                    'Vegan',
                    'Pescatarian'
                  ].map((v) => DropdownMenuItem(value: v, child: Text(v, style: GoogleFonts.poppins(color: Colors.white)))).toList(),
                  onChanged: (v) {
                    // normalize 'No preference' -> null for easier logic
                    applyDietFilter(v == 'No preference' ? null : v);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final name = filteredItems[index];
                final nutrition = workingNutritionalValues[index];
                final count = workingCounter[index];
                final kcalPerItem = workingKcalList[index];
                final proteinPerItem = workingProteinList[index];
                final fatPerItem = workingFatList[index];

                return Card(
                  color: Colors.black,
                  child: ListTile(
                    leading: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      icon: Icon(Icons.add, color: Colors.blue),
                      label: Text(count > 0 ? '$count' : '', style: GoogleFonts.poppins(color: Colors.white)),
                      onPressed: () => _incrementAt(index),
                    ),
                    title: Text(name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(nutrition, style: GoogleFonts.poppins(color: Colors.white)),
                    trailing: count > 0
                        ? IconButton(
                            onPressed: () => _decrementAt(index),
                            icon: Icon(Icons.remove, color: Colors.red),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
