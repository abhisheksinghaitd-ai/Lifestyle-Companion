import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lifestyle_companion/item.dart';
import 'package:hive/hive.dart';

class SelectPref extends StatefulWidget {
  const SelectPref({super.key});

  @override
  State<SelectPref> createState() => _SelectPrefState();
}

class _SelectPrefState extends State<SelectPref> {
  // Options
  final List<String> allergyOptions = [
    'No allergies',
    'Peanuts',
    'Tree nuts (almonds, walnuts, etc.)',
    'Milk / Dairy',
    'Eggs',
    'Wheat / Gluten',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
    'Mustard',
    'Sulfites',
    'Corn',
    'Other'
  ];

  final List<String> dietaryPreferences = [
    'No preference',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Lacto-Ovo Vegetarian',
    'Ketogenic (Keto)',
    'Low-Carb',
    'Paleo',
    'Mediterranean',
    'Gluten-Free',
    'Dairy-Free',
    'Halal',
    'Kosher',
    'Other'
  ];

  final List<String> healthGoals = [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
    'Build Muscle',
    'Improve Endurance',
    'Improve Overall Health',
    'Other'
  ];

  final List<String> activityLevels = [
    'Sedentary (little or no exercise)',
    'Lightly active (1–3 days/week)',
    'Moderately active (3–5 days/week)',
    'Very active (6–7 days/week)',
    'Extra active (hard physical job or training)'
  ];

  // Selected values
  String? selectedDietary;
  String? selectedAllergy;
  String? selectedGoal;
  String? selectedActivity;

  final box = Hive.box('pref');


  void save() {
  if (selectedDietary == null ||
      selectedAllergy == null ||
      selectedGoal == null ||
      selectedActivity == null) {
    return;
  }

  box.put("diet", selectedDietary);
  box.put("allergies", selectedAllergy);
  box.put("health", selectedGoal);       // save user’s choice
  box.put("activity", selectedActivity); // fixed typo + correct value

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => ItemWidget()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
        title: Text(
          'Select Preferences',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shadowColor: Colors.blueGrey[900],
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Dietary Preferences
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Dietary Preferences',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(FontAwesome.utensils_solid, color: Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedDietary,
                      hint: Text(
                        'Select an Option',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dropdownColor: const Color(0xFF2C2C2C),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDietary = newValue;
                        });
                      },
                      items: dietaryPreferences.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
                 
                    const SizedBox(height: 16),

                    // 🔹 Allergies
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Allergies',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(FontAwesome.pepper_hot_solid, color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedAllergy,
                      hint: Text(
                        'Select an Option',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dropdownColor: const Color(0xFF2C2C2C),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAllergy = newValue;
                        });
                      },
                      items: allergyOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
                    
                    const SizedBox(height: 16),

                    // 🔹 Health Goals
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Health Goals',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(FontAwesome.bullseye_solid, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedGoal,
                      hint: Text(
                        'Select an Option',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dropdownColor: const Color(0xFF2C2C2C),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGoal = newValue;
                        });
                      },
                      items: healthGoals.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
                    
                    const SizedBox(height: 16),

                    // 🔹 Activity Level
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Activity Level',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(FontAwesome.person_running_solid, color: Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedActivity,
                      hint: Text(
                        'Select an Option',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dropdownColor: const Color(0xFF2C2C2C),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedActivity = newValue;
                        });
                      },
                      items: activityLevels.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 20,),
                    ElevatedButton.icon(icon: Icon(Icons.arrow_forward_ios,color: Colors.white,),style: ElevatedButton.styleFrom(backgroundColor: Colors.black),onPressed:() => 
                         save()
                    , label: Text('Proceed',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
