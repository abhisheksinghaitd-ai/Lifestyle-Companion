import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class Showloggingscreen extends StatefulWidget {
  const Showloggingscreen({super.key});

  @override
  State<Showloggingscreen> createState() => _ShowloggingscreenState();
}

class _ShowloggingscreenState extends State<Showloggingscreen> {
  TimeOfDay? _selectedTime; // bedtime
  TimeOfDay? _selectedTime1; // wake-up
  Duration sleepDuration = Duration.zero; // default
  int? _selectedNapHours;

  // Bedtime notes
  bool bedtimeNotes = false;
  bool bedtimeNotesDone = false;
  TextEditingController bedtimeController = TextEditingController();

  // Wake-up notes
  bool wakeupNotes = false;
  bool wakeupNotesDone = false;
  TextEditingController wakeupController = TextEditingController();

  // Nap notes
  bool napNotes = false;
  bool napNotesDone = false;
  TextEditingController napController = TextEditingController();


  final sleepBox = Hive.box('sleep');

  /// Calculate difference between bedtime and wake-up
  Duration calculateSleepDuration(TimeOfDay bedtime, TimeOfDay wakeup) {
    DateTime now = DateTime.now();

    DateTime bedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      bedtime.hour,
      bedtime.minute,
    );

    DateTime wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      wakeup.hour,
      wakeup.minute,
    );

    if (wakeDateTime.isBefore(bedDateTime)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    return wakeDateTime.difference(bedDateTime);
  }

  /// Format duration nicely (e.g., 7h 45m)
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  /// Select bedtime
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      confirmText: 'Select',
      cancelText: "Cancel",
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;

        if (_selectedTime != null && _selectedTime1 != null) {
          sleepDuration = calculateSleepDuration(_selectedTime!, _selectedTime1!);
        }
      });
    }
  }

  /// Select wake-up
  Future<void> _selectTime1(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime1 ?? TimeOfDay.now(),
      confirmText: 'Select',
      cancelText: "Cancel",
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime1 = pickedTime;

        if (_selectedTime != null && _selectedTime1 != null) {
          sleepDuration = calculateSleepDuration(_selectedTime!, _selectedTime1!);
        }
      });
    }
  }


void saveButton() {
  if (_selectedTime == null || _selectedTime1 == null || _selectedNapHours == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please select all fields before saving")),
    );
    return;
  }

  final task = {
    'bedtime': _selectedTime!.format(context),
    'wakeup': _selectedTime1!.format(context),
    'nap': _selectedNapHours,
    'total':formatDuration(sleepDuration)
  };

  sleepBox.add(task);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Sleep data saved successfully")),
  );


  

  
    Navigator.of(context).pop();
 
}

@override
void initState() {
  super.initState();

  if (sleepBox.isNotEmpty) {
    final lastSleep = sleepBox.getAt(sleepBox.length - 1);

    if (lastSleep is Map) {
      // Pre-fill bedtime button
      if (lastSleep['bedtime'] != null) {
        final parts = lastSleep['bedtime'].toString().split(':');
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      }

      // Pre-fill wake-up button
      if (lastSleep['wakeup'] != null) {
        final parts = lastSleep['wakeup'].toString().split(':');
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;
        _selectedTime1 = TimeOfDay(hour: hour, minute: minute);
      }

      // Pre-fill nap hours
      _selectedNapHours = lastSleep['nap'] != null
          ? int.tryParse(lastSleep['nap'].toString())
          : null;

      // Calculate sleep duration
      if (_selectedTime != null && _selectedTime1 != null) {
        sleepDuration = calculateSleepDuration(_selectedTime!, _selectedTime1!);
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.black,
    title: Text('Log Sleep Section',style:GoogleFonts.poppins(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold)),
    leading: 
    IconButton(onPressed: (){
      Navigator.of(context).pop();
    },icon:Icon(Icons.arrow_back,color: Colors.white))),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(

            children: [
              SizedBox(height: 50,),
         
           

              // Bedtime card
              Card(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bedtime',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.alarm, color: Colors.amber),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () => _selectTime(context),
                            label: Text(
                              _selectedTime == null
                                  ? 'Select Time'
                                  : _selectedTime!.format(context),
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      bedtimeNotesDone
                          ? SizedBox(
                              width: double.infinity,
                              child: ListTile(
                                title: Text(
                                  bedtimeController.text,
                                  style: GoogleFonts.poppins(color: Colors.white),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      bedtimeNotesDone = false;
                                    });
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.amber),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: bedtimeNotes
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            style: GoogleFonts.poppins(color: Colors.white),
                                            controller: bedtimeController,
                                            decoration: InputDecoration(
                                              hintText: 'Type Something..',
                                              hintStyle: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal),
                                              fillColor: Colors.grey[900],
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              bedtimeNotesDone = true;
                                            });
                                          },
                                          icon: const Icon(Icons.check, color: Colors.green),
                                        )
                                      ],
                                    )
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                      icon: const Icon(Icons.add, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          bedtimeNotes = !bedtimeNotes;
                                        });
                                      },
                                      label: Text(
                                        'Add Notes',
                                        style: GoogleFonts.poppins(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Wake-up card
              Card(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Wake-Up',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.alarm, color: Colors.amber),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () => _selectTime1(context),
                            label: Text(
                              _selectedTime1 == null
                                  ? 'Select Time'
                                  : _selectedTime1!.format(context),
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      wakeupNotesDone
                          ? SizedBox(
                              width: double.infinity,
                              child: ListTile(
                                title: Text(
                                  wakeupController.text,
                                  style: GoogleFonts.poppins(color: Colors.white),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      wakeupNotesDone = false;
                                    });
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.amber),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: wakeupNotes
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            style: GoogleFonts.poppins(color: Colors.white),
                                            controller: wakeupController,
                                            decoration: InputDecoration(
                                              hintText: 'Type Something..',
                                              hintStyle: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal),
                                              fillColor: Colors.grey[900],
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              wakeupNotesDone = true;
                                            });
                                          },
                                          icon: const Icon(Icons.check, color: Colors.green),
                                        )
                                      ],
                                    )
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                      icon: const Icon(Icons.add, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          wakeupNotes = !wakeupNotes;
                                        });
                                      },
                                      label: Text(
                                        'Add Notes',
                                        style: GoogleFonts.poppins(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nap card
              Card(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nap',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          DropdownButton<int>(
                            dropdownColor: Colors.blueGrey[900],
                            value: _selectedNapHours,
                            hint: Text(
                              "Nap duration",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            items: List.generate(6, (index) => index + 1)
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      "$e hr${e > 1 ? 's' : ''}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedNapHours = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      napNotesDone
                          ? SizedBox(
                              width: double.infinity,
                              child: ListTile(
                                title: Text(
                                  napController.text,
                                  style: GoogleFonts.poppins(color: Colors.white),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      napNotesDone = false;
                                    });
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.amber),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: napNotes
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            style: GoogleFonts.poppins(color: Colors.white),
                                            controller: napController,
                                            decoration: InputDecoration(
                                              hintText: 'Type Something..',
                                              hintStyle: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal),
                                              fillColor: Colors.grey[900],
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              napNotesDone = true;
                                            });
                                          },
                                          icon: const Icon(Icons.check, color: Colors.green),
                                        )
                                      ],
                                    )
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                      icon: const Icon(Icons.add, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          napNotes = !napNotes;
                                        });
                                      },
                                      label: Text(
                                        'Add Notes',
                                        style: GoogleFonts.poppins(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sleep duration display
              Text(
                "Sleep Duration: ${formatDuration(sleepDuration)}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                sleepDuration.inHours < 6
                    ? 'Sleep Hours needs to be increased!'
                    : 'Sleep Hours are fine!',
                style: GoogleFonts.poppins(color: Colors.white),
              ),

              SizedBox(height: 20,),

              ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),onPressed: ()=>
               saveButton()
              ,label: Text('Save',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),icon: Icon(Icons.check,color: Colors.green,),)
            ],
          ),
        ),
      ),
    );
  }
}
