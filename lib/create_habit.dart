import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateHabitWidget extends StatefulWidget {
  const CreateHabitWidget({super.key});

  @override
  State<CreateHabitWidget> createState() => _CreateHabitWidgetState();
}

class _CreateHabitWidgetState extends State<CreateHabitWidget> {

  final Box taskBox = Hive.box('habit');
  List<TimeOfDay> reminderTimes = [];
  bool daily = false;
  bool weekly = false;
  bool monthly = false;
  bool custom = false;
    bool healthFitness = false;
  bool selfCareWellness = false;
  bool productivityWork = false;
  bool learningGrowth = false;
  bool financialMoney = false;
  bool relationshipsSocial = false;
  bool homeEnvironment = false;
  bool mindsetSpirituality = false;
  bool creativity = false;
  bool customcategory = false;


  bool monday = false;
bool tuesday = false;
bool wednesday = false;
bool thursday = false;
bool friday = false;
bool saturday = false;
bool sunday = false;

bool timepicked = false;


bool freqisSelected = false;
bool categoryisSelected = false;
bool dayisSelected = false;
String freq = '';
String category = '';
String reminder = '';

final Box savehabit = Hive.box('savehabit');

String formatTimeOfDay(TimeOfDay tod) {
  final hour = tod.hour.toString().padLeft(2, '0');
  final minute = tod.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

List<String> convertTimes(List<TimeOfDay> times) {
  return times.map((t) => formatTimeOfDay(t)).toList();
}



  Future<void> _pickTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null && !reminderTimes.contains(picked)) {
    setState(() {
      reminderTimes.add(picked);
      timepicked=true;
    });
  }
}

  
  
  @override
  Widget build(BuildContext context) {
    final task = taskBox.getAt(taskBox.length-1) as Map;
    final habit = task['habitText'] ?? '';

    return Scaffold(floatingActionButton: FloatingActionButton.extended(backgroundColor: Colors.grey[900],icon: Icon(Icons.save,color: Colors.green,),label: Text('Save!',style: GoogleFonts.poppins(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 18),),onPressed: (){
      freq = daily
    ? "Daily"
    : weekly
        ? "Weekly"
        : monthly
            ? "Monthly"
            : custom
                ? "Custom"
                : "";

           if (daily || weekly || monthly || custom){
            setState(() {
              freqisSelected = true;

            });
           }

           category = healthFitness
    ? "Health & Fitness"
    : selfCareWellness
        ? "Self Care & Wellness"
        : productivityWork
            ? "Productivity & Work"
            : learningGrowth
                ? "Learning & Growth"
                : financialMoney
                    ? "Financial & Money"
                    : relationshipsSocial
                        ? "Relationships & Social"
                        : homeEnvironment
                            ? "Home & Environment"
                            : mindsetSpirituality
                                ? "Mindset & Spirituality"
                                : creativity
                                    ? "Creativity"
                                    : customcategory
                                        ? "Custom"
                                        : "";

           if (healthFitness ||
    selfCareWellness ||
    productivityWork ||
    learningGrowth ||
    financialMoney ||
    relationshipsSocial ||
    homeEnvironment ||
    mindsetSpirituality ||
    creativity ||
    customcategory){
      setState(() {
        categoryisSelected = true;
      });
      
    }

    reminder = monday
    ? "Monday"
    : tuesday
        ? "Tuesday"
        : wednesday
            ? "Wednesday"
            : thursday
                ? "Thursday"
                : friday
                    ? "Friday"
                    : saturday
                        ? "Saturday"
                        : sunday
                            ? "Sunday"
                            : "";

    if (monday ||
    tuesday ||
    wednesday ||
    thursday ||
    friday ||
    saturday ||
    sunday){
      setState(() {
        dayisSelected = true;
      });
      
    }

   
   if(freqisSelected && categoryisSelected && dayisSelected){

    savehabit.add({'freq':freq,'category':category,'reminder':reminder, 'time':convertTimes(reminderTimes)});
    
    Navigator.of(context).pop();

        
   }else{
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title:  Text('Alert!',style: GoogleFonts.poppins(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),content: Text("Please select required fields!",style: GoogleFonts.poppins(color: Colors.black,fontSize:16),),actions: [
        TextButton(onPressed: (){
            Navigator.pop(context);
        }, child: Text('Cancel'))
      ],);
    });
   }

        
    },),appBar: AppBar(leading: IconButton(onPressed: (){
      Navigator.of(context).pop();
    }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),backgroundColor: Colors.black,title: Text('Edit Habit',style: GoogleFonts.poppins(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),),backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
             Card(color: Colors.black,child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$habit',style: GoogleFonts.poppins(color:Colors.blue,fontWeight: FontWeight.bold,fontSize: 24),),
                  SizedBox(height: 20,),
        
                  Card(color: Colors.black,child: 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Text('Select Frequency',style: GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                    SizedBox(height: 10,),
                    Wrap(spacing: 8,runSpacing: 8,
                      children: [
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                              setState(() {
                                daily = true;
                                weekly = false;
                                monthly = false;
                                custom = false;
                              });
                          },
                          child: Text(
                            'Daily',
                            style: GoogleFonts.poppins(
                              color: daily?Colors.blue:Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                           ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            setState(() {
                               daily = false;
                                weekly = true;
                                monthly = false;
                                custom = false;
                                                          });
                          },
                          child: Text(
                            'Weekly',
                            style: GoogleFonts.poppins(
                              color: weekly?Colors.blue:Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                           ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            setState(() {
                                    daily = false;
                                weekly = false;
                                monthly = true;
                                custom = false;
                            });
                     
                          },
                          child: Text(
                            'Monthly',
                            style: GoogleFonts.poppins(
                              color: monthly?Colors.blue:Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                           ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            setState(() {
                                 daily = false;
                                weekly = false;
                                monthly = false;
                                custom = true;
                            });
                        
                          },
                          child: Text(
                            'Custom',
                            style: GoogleFonts.poppins(
                              color: custom?Colors.blue:Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
        
        
                    
                    
                    
                    ],),
        
                  ),),
        
        
                ],
               ),
             ),),
        
             Card(color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                     Text('Category' ,style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),),
                              SizedBox(height: 20,),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                healthFitness = true;
                              
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
                              
                            },
                            child: Text(
                              'Health & Fitness',
                              style: GoogleFonts.poppins(
                                color: healthFitness?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                             ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                                       healthFitness = false;
selfCareWellness = true;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
    
                            },
                            child: Text(
                              'Self Care & Wellness',
                              style: GoogleFonts.poppins(
                                color: selfCareWellness? Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                             ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                              healthFitness = false;
selfCareWellness = false;
productivityWork = true;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
             
                            },
                            child: Text(
                              'Productivity & Work',
                              style: GoogleFonts.poppins(
                                color:productivityWork?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                             ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                                    healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = true;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
       
                            },
                            child: Text(
                              'Learning & Growth',
                              style: GoogleFonts.poppins(
                                color:learningGrowth?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                               healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = true;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
            
                            },
                            child: Text(
                              'Financial & Money',
                              style: GoogleFonts.poppins(
                                color:financialMoney? Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                                 healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = true;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
          
                            },
                            child: Text(
                              'Relationsips and Social',
                              style: GoogleFonts.poppins(
                                color:relationshipsSocial? Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                           healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = true;
mindsetSpirituality = false;
creativity = false;
customcategory = false;
                              });
                
                            },
                            child: Text(
                              'Home & Environment',
                              style: GoogleFonts.poppins(
                                color: homeEnvironment?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                              healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = true;
creativity = false;
customcategory = false;
                              });
             
                            },
                            child: Text(
                              'Mindset & Spirituality',
                              style: GoogleFonts.poppins(
                                color:mindsetSpirituality?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                           healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = true;
customcategory= false;
                              });
                

                            },
                            child: Text(
                              'Creativity',
                              style: GoogleFonts.poppins(
                                color:creativity?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                               healthFitness = false;
selfCareWellness = false;
productivityWork = false;
learningGrowth = false;
financialMoney = false;
relationshipsSocial = false;
homeEnvironment = false;
mindsetSpirituality = false;
creativity = false;
customcategory = true;
                              });
            
                            },
                            child: Text(
                              'Custom',
                              style: GoogleFonts.poppins(
                                color: customcategory?Colors.blue: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ],
                              )
                  ],
                ),
              ),
             ),
             Card(color: Colors.black,child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                children: [
                      Text('Reminder',style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),),
                                SizedBox(height: 20,),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                  Text('Select Day',style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),),
                              SizedBox(height: 20,),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                             setState(() {
                               monday = true;
tuesday = false;
wednesday = false;
thursday = false;
friday = false;
saturday = false;
sunday = false;
                             });
                            },
                            child: Text(
                              'Mon',
                              style: GoogleFonts.poppins(
                                color: monday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                             ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                            setState(() {
                              monday = false;
tuesday = true;
wednesday = false;
thursday = false;
friday = false;
saturday = false;
sunday = false;
                            });
                            },
                            child: Text(
                              'Tue',
                              style: GoogleFonts.poppins(
                                color: tuesday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                             ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                monday = false;
tuesday = false;
wednesday = true;
thursday = false;
friday = false;
saturday = false;
sunday = false;
                              });
                            },
                            child: Text(
                              'Wed',
                              style: GoogleFonts.poppins(
                                color: wednesday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                             ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                monday = false;
tuesday = false;
wednesday = false;
thursday = true;
friday = false;
saturday = false;
sunday = false;
                              });
                            },
                            child: Text(
                              'Thus',
                              style: GoogleFonts.poppins(
                                color: thursday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                monday = false;
tuesday = false;
wednesday = false;
thursday = false;
friday = true;
saturday = false;
sunday = false;
                              });
                            },
                            child: Text(
                              'Fri',
                              style: GoogleFonts.poppins(
                                color: friday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                monday = false;
tuesday = false;
wednesday = false;
thursday = false;
friday = false;
saturday = true;
sunday = false;
                              });
                            },
                            child: Text(
                              'Sat',
                              style: GoogleFonts.poppins(
                                color: saturday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                             setState(() {
                               monday = false;
tuesday = false;
wednesday = false;
thursday = false;
friday = false;
saturday = false;
sunday = true;
                             });
                            },
                            child: Text(
                              'Sun',
                              style: GoogleFonts.poppins(
                                color: sunday?Colors.blue:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                                
                                ],
                              )
                                ],),
                                Column(children: [
                                  Text('Select Time',style: GoogleFonts.poppins(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  Wrap(spacing:8,children: reminderTimes.map((time){
                                    return Chip(
              label: Text(
                time.format(context),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.blueGrey,
              deleteIcon: Icon(Icons.close, color: Colors.white),
              onDeleted: () {
                setState(() {
                  reminderTimes.remove(time);
                  if(reminderTimes.isEmpty){
                    timepicked = false;
                  }
                });
              },
            );
                                  }).toList(),
                                  
                                  ),

                                  Visibility(visible: timepicked,child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.black),label: Text('Remind Me!',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),onPressed: (){}, icon: Icon(Icons.notification_add,color: Colors.white,))),

                                  ElevatedButton.icon(
          onPressed: () => _pickTime(context),
          icon: Icon(Icons.add,color: Colors.white,),
          label: Text("Add Time",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
                                ],)
                ],
               ),
             ),),
             





        
        
        
          ],
        ),
      ),
    );
  }
}