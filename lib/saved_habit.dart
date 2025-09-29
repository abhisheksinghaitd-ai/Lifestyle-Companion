import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavedHabitWidget extends StatefulWidget {
  const SavedHabitWidget({super.key});

  @override
  State<SavedHabitWidget> createState() => _SavedHabitWidgetState();
}

class _SavedHabitWidgetState extends State<SavedHabitWidget> {
  final savedHabit = Hive.box('savehabit');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(leading: IconButton(onPressed: (){

    }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),backgroundColor: Colors.black,
      title: Text('Saved Habit',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
    ),backgroundColor: Colors.grey[900],
      body: Column(
        children: [
         Card(
  color: Colors.blueGrey[900],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: ValueListenableBuilder(
      valueListenable: savedHabit.listenable(),
      builder: (context, value, child) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: savedHabit.length,
          itemBuilder: (context, index) {
            final task = savedHabit.getAt(index) as Map? ?? {};
            final freq = task['freq'] ?? '';
            final category = task['category'] ?? '';
            final reminder = task['reminder'] ?? '';
            final time = task['time'] ?? [];

            return Card(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category title
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Frequency
                    Row(
                      children: [
                        Icon(Icons.repeat, color: Colors.blueAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Frequency: $freq",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[300],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Time
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.tealAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Time: ${time.join(", ")}",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[300],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Reminder
                    Row(
                      children: [
                        Icon(Icons.event, color: Colors.orangeAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Reminder: $reminder",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[300],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  ),
)

        ],
      ),
    );
  }
}