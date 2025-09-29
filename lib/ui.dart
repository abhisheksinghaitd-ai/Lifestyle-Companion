import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:lifestyle_companion/ShowLoggingScreen.dart';
import 'package:lifestyle_companion/SleepEntry.dart';
import 'package:lifestyle_companion/SleepNotifier.dart';
import 'package:lifestyle_companion/achievements.dart';
import 'package:lifestyle_companion/activities_idea.dart';
import 'package:lifestyle_companion/create_habit.dart';
import 'package:lifestyle_companion/exercise.dart';
import 'package:lifestyle_companion/item.dart';
import 'package:lifestyle_companion/mistral_service.dart';
import 'package:lifestyle_companion/saved_habit.dart';
import 'package:lifestyle_companion/select_pref.dart';
import 'package:lifestyle_companion/steps_ui.dart';

import 'package:replog_icons/replog_icons.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';   // Font Awesome solid
import 'package:iconify_flutter/icons/fa6_regular.dart'; // Font Awesome regular
import 'package:iconify_flutter/icons/mdi.dart'; 
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:pedometer/pedometer.dart';
import 'exercise.dart';
import 'exercise_api.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:health/health.dart';
import 'package:daily_pedometer/daily_pedometer.dart';


class UiWidget extends StatefulWidget {
  const UiWidget({super.key});

  @override
  State<UiWidget> createState() => _UiWidgetState();
}

class _UiWidgetState extends State<UiWidget> {
  String result = ""; // store calculation result
  String target = "";
  TextEditingController controller = TextEditingController();
  TextEditingController controllerheight = TextEditingController();
  TextEditingController calburn = TextEditingController();
  TextEditingController habit = TextEditingController();
  bool isCalculate = false;

  double waterval = 0;
  String bedtimeText = '';
  String wakeupText = '';
   String napText = '';
  String totalSleepText = '';


  final boxItem = Hive.box('items');
  final habitBox = Hive.box('habit');
  final savedHabit = Hive.box('savehabit');
  final prefBox = Hive.box('pref');
  final sleepBox = Hive.box('sleep');

  

  late Future<List<Exercise>> _futureExercises;

  // starting point
  int stepsToday = 0;
  bool showList = false;
  bool expand = false;

  final box = Hive.box('waterintake');

  void preference(){
    if(prefBox.isNotEmpty){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ItemWidget()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SelectPref()));
    }
  }

  Widget _buildSleepButton(
    IconData icon,String text,Color color, Color textColor,double size
  ){
    return ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: color,shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),side: BorderSide(color:color.withOpacity(0.5))
    )),icon: Icon(icon,color: Colors.white,),onPressed: (){
      
    }, label: Text(textAlign: TextAlign.center,text,style: GoogleFonts.poppins(color: textColor,fontSize: size,fontWeight: FontWeight.bold),),
    );
  }




 




  


  String calculate(String weight) {
    int w = int.tryParse(weight) ?? 0;
    int calories = w * 24; // simple formula

    return "$calories";


  }
  String averageCaloriesBurnedString(String stepsStr, {double avgWeight = 70}) {
  // Convert steps safely
  double steps = double.tryParse(stepsStr) ?? 0.0;

  // Calories burned using average weight
  double caloriesBurned = steps * avgWeight * 0.0005;

  // Round to 1 decimal place and format as string
  return caloriesBurned.toStringAsFixed(1);
}

double burnedFractionDynamicDaily({
  required String weightStr,  // weight in kg
  required String stepsStr,   // steps walked
}) {
  // Convert strings safely
  double weight = double.tryParse(weightStr) ?? 0.0;
  double steps = double.tryParse(stepsStr) ?? 0.0;

  // Calculate dynamic daily average calories for this weight
  double dailyAverage = weight * 24;

  // Calculate calories burned from steps
  double caloriesBurned = steps * weight * 0.0005;

 double fraction = (caloriesBurned / dailyAverage).clamp(0.0, 1.0);

  // Round to 1 decimal place
  return double.parse(fraction.toStringAsFixed(2));
}

double cpiValue(int calories){
   double cpi = calories/2000;

   return cpi;
}

String cpiValuestring(int calories){
   double cpi = calories/200;
   

   return cpi.toString();
}


double calcin(String weight) {
  double w = double.tryParse(weight) ?? 0.0;
  double calories = w * 24; // simple formula

  return calories;
}

Stream<StepCount>? _stepCountStream;
int _steps = 0;
int _stepsAtReset = 0;   // manual reset offset
        // daily baseline
bool pausePressed = false;
 int? _baseline;
 int _stepsx = 0;

  bool _firstTimeDialogShown = false;

  List<String> parts = [];
  int hour = 0;
  int minutes = 0;

    List<String> parts1 = [];
  int hour1 = 0;
  int minutes1 = 0;

     List<String> parts2 = [];
  int hour2 = 0;
  int minutes2 = 0;

  int hour3 = 0;
  int minutes3 = 0;

  String finalMinutes = '';


 

@override
void initState() {
  super.initState();
 
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_firstTimeDialogShown) {
        _firstTimeDialogShown = true;
        _showFirstTimeDialog();
      }
    });
  habit.addListener(() {
    setState(() {});
  });
  _futureExercises = ExerciseApi.fetchExerciseByBodyPart("chest");


  final saved = box.get("water", defaultValue: 0.0);
  waterval = saved;

  _updateSleepData();





  _loadBaseline();
}

/// Update local variables whenever sleepBox changes
void _updateSleepData() {
  if (sleepBox.isNotEmpty) {
    final lastSleep = sleepBox.getAt(sleepBox.length - 1);

    if (lastSleep is Map) {
      setState(() {
        bedtimeText = (lastSleep['bedtime'] ?? '').toString();
        wakeupText = (lastSleep['wakeup'] ?? '').toString();
        napText = (lastSleep['nap'] ?? '').toString();
        totalSleepText = (lastSleep['total'] ?? '').toString();

        // Parse hours and minutes
        parts = bedtimeText.split(':');
        hour = int.tryParse(parts[0]) ?? 0;
        minutes = int.tryParse(parts[1]) ?? 0;

        parts1 = wakeupText.split(':');
        hour1 = int.tryParse(parts1[0]) ?? 0;
        minutes1 = int.tryParse(parts1[1]) ?? 0;

        hour2 = int.tryParse(napText) ?? 0;

        final parts2 = totalSleepText.split('h');
        hour3 = int.tryParse(parts2[0]) ?? 0;
        finalMinutes = parts2.length > 1 ? parts2[1] : '0';
      });
    }
  }
}


@override
void dispose(){
  sleepBox.listenable().removeListener(_updateSleepData);
  super.dispose();
}



Future<void> _loadBaseline() async {
  final box = Hive.box('stepsBox');
  final today = DateTime.now().toIso8601String().split('T').first;

  _baseline = box.get('baselineSteps');
  final lastSavedDate = box.get('baselineDate', defaultValue: '');

  if (lastSavedDate != today) {
    _baseline = null; // reset baseline for new day
  }

  _initPedometer(today);
}

void _initPedometer(String today) {
  _stepCountStream = Pedometer.stepCountStream;

  _stepCountStream!.listen((StepCount event) async {
    final box = Hive.box('stepsBox');

    if (_baseline == null) {
      // first reading of the day → store baseline
      _baseline = event.steps;
      await box.put('baselineSteps', _baseline);
      await box.put('baselineDate', today);
    }

    setState(() {
      // subtract daily baseline + manual reset offset
      _steps = event.steps - (_baseline ?? 0) - _stepsAtReset;
      if (_steps < 0) _steps = 0;
    });
  }, onError: (error) {
    print("⚠️ Step Count Error: $error");
  });
}

void _resetSteps() async {
  final event = await _stepCountStream!.first;

  setState(() {
    // calculate offset relative to current baseline
    _stepsAtReset = event.steps - (_baseline ?? 0);
    _steps = 0;
  });

  print("✅ Steps reset at sensor value: $_stepsAtReset");
}



  
   void _showFirstTimeDialog() {
   showDialog(
  context: context,
  builder: (context) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Rounded corners
    ),
    child: ConstrainedBox(
      // Constrain the width of the dialog to expand horizontally
      constraints: BoxConstraints(
        maxWidth: 400, // You can adjust this value for wider screens
        minWidth: 300, // Ensures minimum width for small devices
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content vertically
          children: [
            // Icon at the top
            Icon(Icons.bedtime, size: 60, color: Colors.blueAccent),
            SizedBox(height: 15),

            // Title text
            Text(
              'Sleep Tracker (New Launches!)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            // Description text
            Text(
              'Log your bedtime and wake-up time to see your sleep patterns and get helpful insights.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),

            // Buttons in a column to make them full width
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Expand buttons horizontally
              children: [
                // "Maybe Later" TextButton
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16), // Increase tap area
                  ),
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
               
                
                SizedBox(height: 10), // Space between buttons

                // "Log My First Sleep" ElevatedButton
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 16), // Increase tap area
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Showloggingscreen()),
                    );
                    _updateSleepData();
                  },
                  child: Text(
                    'Log My First Sleep',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);

  }







final sleepProvider =
    StateNotifierProvider<SleepNotifier, List<SleepEntry>>((ref) {
  return SleepNotifier();
});


  @override
  Widget build(BuildContext context) {

  

    
  


     
    return Scaffold(
      
      backgroundColor: const Color(0xFF121212), // dark background to see cards
      body: SingleChildScrollView(
        child: Column(
          children: [

             

             const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              
              child: Row(
  children: [
    // Title
    Text(
      'Achievements',
      style: GoogleFonts.poppins(
        color: Color(0xFFE6BE8A), // Softer champagne gold
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(width: 10),

    // Award Icon
    Icon(
      FontAwesome.award_solid,
      color: Color(0xFFE6BE8A), // Match gold tone
      size: 22,
    ),

    const Spacer(),

    // Arrow Button
    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AchievementsWidget(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1, 0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      icon: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFFB0BEC5), // Soft gray for balance
        size: 18,
      ),
    ),
  ],
)
,
            ),
           
            GestureDetector(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 800),pageBuilder: (context,animation,secondaryAnimation)=> StepsWidget(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation,child: child,);
                },));
              },
              child: Card(
  elevation: 8,
  color: const Color(0xFF1E1E1E), // dark gray background
  shadowColor: Colors.grey[900],   // softer shadow
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.directions_walk_rounded, color: Colors.redAccent),
            SizedBox(width: 5),
            Text(
              'Steps',
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: pausePressed?3:0,sigmaY: pausePressed?3:0),
              child: Text(
                "4234",
                style: GoogleFonts.poppins(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  pausePressed = !pausePressed;
                });
              },
              icon: pausePressed
                  ? Icon(Icons.play_circle, color: Colors.white)
                  : Icon(Icons.pause, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.pending, color: Colors.white),
            ),
          ],
        ),
        Text(
          pausePressed?"Paused":
          '/6000',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: pausePressed?Colors.deepOrange: Color(0xFFB0B0B0), // muted gray
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Spacer(),
            Text(
              'Daily Average: 6234',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFFB0B0B0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: 4234 / 6000,
          color: Colors.redAccent,
          backgroundColor: const Color(0xFF2A2A2A), // track color
          borderRadius: BorderRadius.circular(16),
          minHeight: 10,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 4234/6000,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'W',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 0,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'T',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 0,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'F',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 0,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'S',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 0,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'S',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 0,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'M',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 5,
                  value: 0,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
                SizedBox(height: 5),
                Text(
                  'T',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
          ],
        ),
      ],
    ),
  ),
),



            ),

            Visibility(visible:sleepBox.isNotEmpty,
              child: Card( color: const Color(0xFF1E1E1E),
                child: 
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bedtime,color: Colors.redAccent,),
                          SizedBox(width: 5,),
                          Text('Sleep Log',style: GoogleFonts.poppins(color:Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 24),)
                        ],
                      ),
                      SizedBox(height: 20,),
              
     
   


    Card(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () async {
              await Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 800),pageBuilder: (context,animation,secondaryAnimation)=>
                           Showloggingscreen(),
                           transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1, 0);
                            const end = Offset.zero;
                            const curve= Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation,child: child,);
                           },
                        ));

                         _updateSleepData();
          },
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.bed, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Sleep Schedule',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Spacer(),
                  Icon(Icons.edit, color: Colors.white),
                ],
              ),
              SizedBox(height: 13),
              GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3,
                children: [
                  _buildSleepButton(
                    Icons.bedtime,
                    hour >= 12
                        ? 'Bedtime $bedtimeText PM'
                        : 'Bedtime $bedtimeText AM',
                    Colors.grey[900]!,
                    Colors.white,
                    12,
                  ),
                  _buildSleepButton(
                    Icons.bedtime_off,
                    hour1 >= 12
                        ? 'Wake-Up Time $wakeupText PM'
                        : 'Wake-Up Time $wakeupText AM',
                    Colors.grey[900]!,
                    Colors.white,
                    10,
                  ),
                  _buildSleepButton(
                    Icons.bedtime_outlined,
                    'Nap Duration $napText hrs',
                    Colors.grey[900]!,
                    Colors.white,
                    10,
                  ),
                  _buildSleepButton(
                    Icons.bed_rounded,
                    'Sleep Duration ${hour2 + hour3}h $finalMinutes',
                    Colors.grey[900]!,
                    Colors.white,
                    9,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),

                      SizedBox(height: 10,),
                      GestureDetector(onTap: () async {
                       await Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 800),pageBuilder: (context,animation,secondaryAnimation)=>
                           Showloggingscreen(),
                           transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1, 0);
                            const end = Offset.zero;
                            const curve= Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation,child: child,);
                           },
                        ));

                        _updateSleepData();
                      },
                        child: Row(children: [
                          Icon(Icons.add,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text('Log Sleep Schedule',style: GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios,color: Colors.white,)
                        ],),
                      ),
                     
                   
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
           Card(
  elevation: 8,
  color: const Color(0xFF1E1E1E), // dark gray background
  shadowColor: Colors.grey[900],   // softer shadow
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_run,
              color: Colors.deepOrange, // accent icon
            ),
            SizedBox(width: 5),
            Text(
              'Exercise',
              style: GoogleFonts.poppins(
                color: Colors.deepOrange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  averageCaloriesBurnedString('2000'),
                  style: GoogleFonts.poppins(
                    color: Colors.orangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Kcal',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '0h 0m',
                  style: GoogleFonts.poppins(
                    color: Colors.orangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Min',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '4.58',
                  style: GoogleFonts.poppins(
                    color: Colors.orangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Km',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ),
),

            const SizedBox(height: 5,),
            Card(
  elevation: 8,
  color: const Color(0xFF1E1E1E), // dark gray background
  shadowColor: Colors.grey[900],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Iconify(Fa6Solid.dumbbell, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(
              'Activities',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                   Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 800),pageBuilder: (context,animation,secondaryAnimation)=> ActivitiesIdeaWidget(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation,child: child,);
                },));
              },
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Row 1
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Strength
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(220),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Fa6Solid.dumbbell, color: Colors.white, size: 24),
                  ],
                ),
                Text(
                  '220 Kcal',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Running
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(600),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Fa6Solid.person_running,
                        color: Colors.white, size: 24),
                  ],
                ),
                Text(
                  '600 Kcal',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Cycling
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(500),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.bicycle, color: Colors.white, size: 24),
                  ],
                ),
                Text(
                  '500 Kcal',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Swimming
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(500),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.swim, color: Colors.white, size: 28),
                  ],
                ),
                Text(
                  '500 Kcal',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Row 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(700),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.mixed_martial_arts,
                        color: Colors.white, size: 28),
                  ],
                ),
                Text('700 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(240),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.yoga, color: Colors.white, size: 28),
                  ],
                ),
                Text('240 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(550),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.boxing_gloves,
                        color: Colors.white, size: 28),
                  ],
                ),
                Text('550 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(400),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.cricket, color: Colors.white, size: 28),
                  ],
                ),
                Text('400 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Row 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(650),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.basketball, color: Colors.white, size: 28),
                  ],
                ),
                Text('650 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(450),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.volleyball, color: Colors.white, size: 28),
                  ],
                ),
                Text('450 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(700),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.football_pitch, color: Colors.white, size: 28),
                  ],
                ),
                Text('700 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: cpiValue(600),
                      color: Colors.redAccent,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    Iconify(Mdi.tennis, color: Colors.white, size: 28),
                  ],
                ),
                Text('600 Kcal',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),
        Text(
          '*Average Calories burn per hr',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: const Color(0xFFB0B0B0), // muted gray
          ),
        ),
      ],
    ),
  ),
),

            Card(color: const Color(0xFF1E1E1E),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Calories and Nutrition',style: GoogleFonts.poppins(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                      Text('Calories Consumed',style: GoogleFonts.poppins(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold)),
                      
                      
                      ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor:const Color(0xFF1E1E1E)),onPressed: ()
                      => preference()
                      , label: Text('Add Item',style: GoogleFonts.poppins(fontSize: 16,color: Colors.blue, fontWeight: FontWeight.bold)))
                    ],),
                    Row(children: [
                      Text('Added Items:',style: GoogleFonts.poppins(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold)),
                     
                    ],),

 ValueListenableBuilder(
  valueListenable: boxItem.listenable(),
  builder: (context, Box box, _) {
    if (box.isEmpty) {
      return Center(child: Text("No items yet", style: GoogleFonts.poppins(color: Colors.white)));
    }

    // 🔹 Compute cumulative totals
    int totalKcal = 0;
    int totalProtein = 0;
    double totalFat = 0.0;

    for (int i = 0; i < box.length; i++) {
      final task = box.getAt(i) as Map? ?? {};

      totalKcal += (task['kcal'] ?? 0) as int;
      totalProtein += (task['protein'] ?? 0) as int;
      totalFat += (task['fat'] ?? 0.0) as double;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Summary section
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Daily Totals", style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(totalKcal>2000?"Calories: $totalKcal kcal 🔼":"Calories: $totalKcal kcal 🔻", style: GoogleFonts.poppins(color: Colors.white)),
                      Text(totalProtein>60?"Protein: $totalProtein g 🔼":"Protein: $totalProtein g 🔻", style: GoogleFonts.poppins(color: Colors.white)),
                      Text(totalFat<65?"Fat: ${totalFat.toStringAsFixed(1)} g 🔻":"Fat: ${totalFat.toStringAsFixed(1)} g 🔼", style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                ),
              ),
                   Card(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                   
                    children: [
                     
                  Icon(totalKcal>2000 && totalProtein>60 && totalFat>65?Icons.emoji_emotions:Icons.sentiment_dissatisfied,color: Colors.yellow,size: 70,),
                  Text(totalKcal>2000 && totalProtein>60 && totalFat>65?'Excellent Choice':'Poor Choice',style: GoogleFonts.poppins(color: Colors.white,),)
                    ],
                  ),
                ),
              ),

              

            ],

          ),
          

          Card(color: Colors.grey[900],child: 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
             Text(
              (totalKcal > 2000 && totalProtein > 60 && totalFat > 65)
                  ? "Feedback: No need for any alterations"
                  : (totalKcal > 2000 && totalProtein > 60 && totalFat < 65)
            ? "Feedback: Include foods which are healthy fat rich."
            : (totalKcal > 2000 && totalProtein < 60 && totalFat > 65)
                ? "Feedback: Include foods which are protein rich."
                : (totalKcal < 2000 && totalProtein > 60 && totalFat > 65)
                    ? "Feedback: Increase the amount of calories in your diet."
                    : (totalKcal < 2000 && totalProtein < 60 && totalFat > 65)
                        ? "Feedback: Include food which are calories rich and protein rich."
                        : (totalKcal < 2000 && totalProtein > 60 && totalFat < 65)
                            ? "Feedback: Include foods which are calorie and fat rich."
                            : (totalKcal < 2000 && totalProtein < 60 && totalFat < 65)
                                ? "Feedback: Include foods rich in calories, protein, and fats."
                                : "Feedback: Check your diet values.",style: GoogleFonts.poppins(color: Colors.green,fontWeight: FontWeight.bold),
            )
            
            ],),
          ),),

          ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),icon: Icon(Icons.arrow_drop_down,color: Colors.red,),onPressed: (){
            setState(() {
              showList=!showList;
            });
          },label: Text(showList?'Hide Diet':'Show Saved Diet',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold),),),

          // 🔹 List of items
          if(showList)
          ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, value, child) {
              return ListView.builder(
                padding:EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final task = box.getAt(index) as Map? ?? {};
                  final counter = task['counter'] ?? '';
                  final filtItem = task['filteredItem'] ?? '';
                  final nutri = task['nutritionalValues'] ?? '';
              
                  return Card(
                    color: Colors.black,
                    child: ListTile(
                      
                      title: Text(
                        '$counter × $filtItem',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        nutri,
                        style: GoogleFonts.poppins(color: Colors.blue),
                      ),
                      trailing: IconButton(icon: Icon(Icons.delete,color: Colors.red,
                      ), onPressed: () { 
                        box.deleteAt(index);
                       },),
                    ),
                  );
                },
              );
            }
          ),
          
        ],
      ),
    );
  },
)

,
                  

                
                  ],
                ),
              ),
            ),
          
          
          
    Card(
  color: Color(0xFF1E1E1E),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Habit Tracker',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Spacer(),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),onPressed: (){
                   Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 800),pageBuilder: (context,animation,secondaryAnimation)=> SavedHabitWidget(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation,child: child,);
                },));
            }, child: Text('Saved Diet',style: GoogleFonts.poppins(color: Colors.blue,fontWeight: FontWeight.bold),))
          ],
        ),
        Card(
          color: Color(0xFF2A2A2A),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Habit',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedContainer(duration: Duration(milliseconds: 2000),
                width: habit.text.isEmpty?300:280,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(style: GoogleFonts.poppins(color: Colors.white),
                          controller: habit,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width:10),
                      Visibility(visible: habit.text.isNotEmpty,
                        child: IconButton(onPressed: () async {
                          await habitBox.clear(); // wipe old String entries
                          habitBox.add({'habitText': habit.text}); // now only Maps
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateHabitWidget()));
                        }, icon: Icon(Icons.add,color: Colors.blue,)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // 🔥 Use Wrap instead of Row
                Wrap(
                  spacing: 8, // horizontal gap
                  runSpacing: 8, // vertical gap
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          habit.text = 'Drink 8 glasses of water';
                        });
                      },
                      child: Text(
                        'Drink 8 glasses of water',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Do yoga';
                        });
                      },
                      child: Text(
                        'Do yoga',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Sleep 7-8 hrs';
                        });
                      },
                      child: Text(
                        'Sleep 7-8 hrs',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Wake up early';
                        });
                      },
                      child: Text(
                        'Wake up early',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                     Visibility(visible: !expand,
                       child: IconButton(onPressed: (){
                       setState(() {
                         expand=!expand;
                       });
                                          }, icon: Icon(Icons.keyboard_arrow_down,color: Colors.blue,)),
                     ),
                   if(expand)
                     ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Meditate';
                        });
                      },
                      child: Text(
                        'Meditate',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Eat Fruits';
                        });
                      },
                      child: Text(
                        'Eat Fruits',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Eat Vegetables';
                        });
                      },
                      child: Text(
                        'Eat Vegetables',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Limit Sugar';
                        });
                      },
                      child: Text(
                        'Limit Sugar',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                     ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Limit Caffeine';
                        });
                      },
                      child: Text(
                        'Limit Caffeine',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Cook at home';
                        });
                      },
                      child: Text(
                        'Cook at home',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'No junk food today';
                        });
                      },
                      child: Text(
                        'No junk food today',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if(expand)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                          setState(() {
                          habit.text = 'Take medicine';
                        });
                      },
                      child: Text(
                        'Take medicine',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Visibility(visible: expand,
                      child: IconButton(onPressed: (){
                          setState(() {
                            expand=!expand;
                          });
                      }, icon: Icon(Icons.keyboard_arrow_up,color: Colors.blue,)),
                    )
                  
                  ],
                ),
              ],
            ),
          ),
        ),
        
       
      ],
    ),
  ),
),

Card(
  color: const Color(0xFF1E1E1E), // softer dark background
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.drop_fill,
              color: const Color(0xFF3399FF), // water blue accent
              size: 32,
            ),
            SizedBox(width: 5),
            Text(
              'Water Intake',
              style: GoogleFonts.poppins(
                color: const Color(0xFF3399FF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        color: const Color(0xFF3399FF),
                        value: waterval,
                        backgroundColor: const Color(0xFF2A2A2A),
                      ),
                    ),
                    Column(
                      children: [
                        Icon(Icons.water_drop, color: const Color(0xFF3399FF)),
                        Text(
                          '${(waterval * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: (waterval * 60).toStringAsFixed(0),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'fl oz',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '(UK)',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '/',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '60',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'fl oz',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '(UK)',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A2A2A),
                        ),
                        label: Text(
                          '6fl oz',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            waterval += 0.1;
                          box.put("water",waterval);
                          });
                        },
                        icon: Icon(Icons.add, color: const Color(0xFF3399FF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Weekday progress indicators (unchanged, just styled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: waterval,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'W',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: 1,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'T',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: 1,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'F',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: 1,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'S',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: 1,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'S',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: 1,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'M',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF3399FF),
                      strokeWidth: 5,
                      value: 1,
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'T',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ],
    ),
  ),
)


],
        ),
      ),
    );
  }
}
