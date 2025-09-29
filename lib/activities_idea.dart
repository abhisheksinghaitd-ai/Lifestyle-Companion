import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lifestyle_companion/WorkoutExercise.dart';
import 'package:lifestyle_companion/wgerservice.dart';

class ActivitiesIdeaWidget extends StatefulWidget {
  const ActivitiesIdeaWidget({super.key});

  @override
  State<ActivitiesIdeaWidget> createState() => _ActivitiesIdeaWidgetState();
}

class _ActivitiesIdeaWidgetState extends State<ActivitiesIdeaWidget> {

  bool isExpanded = false;
  double val = 0;

  final List<String> activities = [
    "Weightlifting",
    "Running",
    "Cycling",
    "Swimming",
    "Boxing",
    "Yoga",
    "Rowing",
    "Cricket",
    "Basketball",
    "Volleyball",
    "Football",
    "Badminton",
  ];


  double calculateCalories({
  required String activity,
  required double weightKg,
  required int durationMinutes,
  String intensity = "Moderate",
}) {
  const activityMET = {
    "Running": 8.3,
    "Cycling": 7.5,
    "Swimming": 6.0,
    "Boxing": 9.0,
    "Yoga": 3.0,
    "Rowing": 7.0,
    "Cricket": 5.0,
    "Basketball": 6.5,
    "Volleyball": 4.0,
    "Football": 7.0,
    "Badminton": 6.0,
    "Weightlifting": 3.5,
  };

  const intensityMultiplier = {
    "Light": 0.75,
    "Moderate": 1.0,
    "Intense": 1.25,
  };

  final met = activityMET[activity] ?? 5.0;
  final multiplier = intensityMultiplier[intensity] ?? 1.0;
  final hours = durationMinutes / 60.0;

  return met * weightKg * hours * multiplier;
}
  TextEditingController controller = TextEditingController();
  TextEditingController durattioncontroller = TextEditingController();
  TextEditingController activitycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(leading: Icon(Icons.arrow_back_ios,color: Colors.white,),backgroundColor: Colors.black,title: Text('Activity Details',style: GoogleFonts.poppins(color: Colors.white),),),backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(children:[
            val != 0
    ? Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        shadowColor: Colors.blueGrey[900],
        color: Colors.blueGrey[900],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Calories Burned",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Value
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    val.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 40,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Subtitle / Info
              Text(
                "based on your activity & duration",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),

              const Divider(height: 20),

              // Extra info row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.timer, color: Colors.blue),
                      Text("${durattioncontroller.text} Minutes",style: GoogleFonts.poppins(color: Colors.white),),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.fitness_center, color: Colors.green),
                      Text("Moderate",style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.red),
                      Text("Healthy ❤️",style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20,),
              Column(
                children: [

                  Text('Achievements',style:GoogleFonts.poppins(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),

                  SizedBox(height: 10,),
                  
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Column(
                        children: [
                          Row(children: [
                            Stack(alignment: Alignment.center,children: [
                              SizedBox(width: 60,height: 60,child: CircularProgressIndicator(value: val/500,color: val>=500? Color(0xFFCD7F32):Colors.grey,strokeWidth: 8,)),
                             
                             Icon(FontAwesome.award_solid,color: val>=500?Colors.amberAccent:Colors.grey,size:30)
                            ],)
                          ],),

                           SizedBox(height: 10,),
                      Text('500 kcal in a day',style: GoogleFonts.poppins(color: val>=500?Colors.amberAccent:Colors.grey,fontSize: 10,fontWeight: FontWeight.bold),),

                        ],
                      ),
                                       
                      
                             Column(
                               children: [
                                 Row(children: [
                                                         Stack(alignment: Alignment.center,children: [
                                                           SizedBox(width: 60,height: 60,child: CircularProgressIndicator(value: val/1000,color: val>=1000? Color(0xFFC0C0C0):Colors.grey,strokeWidth: 8,)),
                                                           
                                                          Icon(FontAwesome.award_solid,color: val>=1000?Color(0xFFC0C0C0):Colors.grey,size:30)
                                                         ],)
                                                       ],),
                                                        SizedBox(height: 10,),
                      Text('1000 kcal in a day',style: GoogleFonts.poppins(color: val>=1000?Color(0xFFC0C0C0):Colors.grey,fontSize: 10,fontWeight: FontWeight.bold),),
                               ],
                             ),
                                       
                      
                      
                       Column(
                         children: [
                           Row(children: [
                            Stack(alignment: Alignment.center,children: [
                              SizedBox(width: 60,height: 60,child: CircularProgressIndicator(value: val/2000,color: val>=2000? Color(0xFFFFD700):Colors.grey,strokeWidth: 8,)),
                              
                             Icon(FontAwesome.award_solid,color: val>=2000?Color(0xFFFFD700):Colors.grey,size:30)
                            ],),
                             
                                                 ],),
                                                 SizedBox(height: 10,),
                      Text('2000 kcal in a day',style: GoogleFonts.poppins(color: val>=1000?Color(0xFFFFD700):Colors.grey,fontSize: 10,fontWeight: FontWeight.bold),),
                         ],
                       ),
                                       
                      
                      
                      
                    ],
                  ),
                  


                ],
              )
            ],
          ),
        ),
      )
    
:
              Card(color:Colors.blueGrey[900],
                child: 
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(children: [
                        Text('Activity',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24)),
                         SizedBox(width: 5,),
                         Icon(Icons.directions_run,color: Colors.white,)
                        
                      ],),
                  
                      SizedBox(height: 20,),
                  
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text('Calculate Calories Burn',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                            SizedBox(width: 5,),
                            Icon(Icons.local_fire_department,color: Colors.deepOrange,)
                            
                          ],
                        ),
                      ),
                  
                     
                  
                      TextFormField(style: GoogleFonts.poppins(color: Colors.white),controller: controller ,decoration: InputDecoration(filled: true,fillColor: Colors.black,border:OutlineInputBorder(borderRadius: BorderRadius.circular(16)),hintText: "Enter Weight in Kg",
                      hintStyle: GoogleFonts.poppins(color: Colors.white)),),
                      SizedBox(height: 10,),
                      TextFormField(style: GoogleFonts.poppins(color: Colors.white),controller: durattioncontroller ,decoration: InputDecoration(filled: true,fillColor: Colors.black,border:OutlineInputBorder(borderRadius: BorderRadius.circular(16)),hintText: "Enter Duration in minutes",
                      hintStyle: GoogleFonts.poppins(color: Colors.white)),),
                      SizedBox(height: 10,),
                      TextFormField(onTap: (){
                        setState(() {
                          isExpanded=!isExpanded;
                        });
                      },readOnly:true,style: GoogleFonts.poppins(color: Colors.white),controller: activitycontroller ,decoration: InputDecoration(filled: true,fillColor: Colors.black,border:OutlineInputBorder(borderRadius: BorderRadius.circular(16)),hintText: "Choose Activity",
                      hintStyle: GoogleFonts.poppins(color: Colors.white),suffixIcon: isExpanded?Icon(Icons.arrow_drop_up,color: Colors.white,):Icon(Icons.arrow_drop_down,color: Colors.white,)),),
        
                      SizedBox(height: 20,),
                      ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.black),icon: Icon(Icons.calculate,color: Colors.pink,),onPressed: (){
                             setState(() {
                               
                                     val = calculateCalories(activity: activitycontroller.text, weightKg: double.parse(controller.text), durationMinutes: int.parse(durattioncontroller.text));
                             });
                      }, label: Text('Calculate',style: GoogleFonts.poppins(color:Colors.white),),),
            
                      
            
                   if (isExpanded)
            Container(
              constraints: const BoxConstraints(
                maxHeight: 200, // ~3 items, then scroll
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      activities[index],
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    onTap: () {
                      activitycontroller.text = activities[index];
                      setState(() {
                        isExpanded = false; // close after select
                      });
                    },
                  );
                },
              ),
            ),
                  
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
