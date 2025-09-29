import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class StepsWidget extends StatefulWidget {
  const StepsWidget({super.key});

  @override
  State<StepsWidget> createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  bool bgday = false;
  bool bgweak = false;
  bool bgmonth = false;
  final DateTime date = DateTime.now();
  DateTime get date7daysago => date.subtract(const Duration(days: 7));
  DateTime get date30daysago => date.subtract(const Duration(days:30));
  @override
  void initState(){
    super.initState();
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[900],
      appBar: AppBar(leading: Icon(Icons.arrow_back_ios,color: Colors.white,),title:  Text('Steps',style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),actions: [
                                IconButton(onPressed: (){
                                  Navigator.pop(context);
                                }, icon: Icon(Icons.settings,color: Colors.white,))
                              ],backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Column(children: [
         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: const Size(4, 4),backgroundColor:bgday? Colors.white : const Color.fromARGB(255, 77, 77, 77)),onPressed: (){
               setState(() {
                 bgday = true;
                 bgweak = false;
                 bgmonth = false;
               });
            },label: Text('Day',style: GoogleFonts.poppins(color: bgday? Colors.black : Colors.white),),),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: const Size(4, 4),backgroundColor: bgweak? Colors.white: const Color.fromARGB(255, 77, 77, 77)),onPressed: (){
              setState(() {
                  bgmonth = false;
               bgday = false;
               bgweak = true;
              });
             
            },label: Text('Weak',style: GoogleFonts.poppins(color: bgweak? Colors.black : Colors.white),),),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: const Size(4, 4),backgroundColor: bgmonth? Colors.white: const Color.fromARGB(255, 77, 77, 77)),onPressed: (){
              setState(() {
                  bgmonth = true;
               bgday = false;
               bgweak = false;
              });
             
            },label: Text('Month',style: GoogleFonts.poppins(color: bgmonth? Colors.black : Colors.white),),)
          ],
         ),
         Card(color: Colors.black,elevation: 8,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // ⬅️ Increase this value
          ),
          child: 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(bgweak?'${DateFormat.MMMd().format(date7daysago)} - ${DateFormat.MMMd().format(DateTime.now())}':(bgmonth?'${DateFormat.MMMd().format(date30daysago)} - ${DateFormat.MMMd().format(DateTime.now())}':DateFormat.MMMd().format(DateTime.now())),style: GoogleFonts.poppins(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                  ],
                ),
                Row(mainAxisAlignment: bgday?MainAxisAlignment.center:MainAxisAlignment.spaceEvenly,children: [
                  Visibility(visible: !bgday,child: Text(bgweak?'8373':(bgmonth?'8634':'5120'),style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
                  Visibility(visible: !bgday,child: Spacer()),
                  Text('33020',style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                ],),
                Row(mainAxisAlignment: bgday?MainAxisAlignment.center:MainAxisAlignment.spaceEvenly,children: [
                  Visibility(visible: !bgday,child: Text('Avg',style: GoogleFonts.poppins(color: Colors.grey),)),
                  Visibility(visible: !bgday,child: Spacer()),
                  Visibility(visible: !bgday,child: Text('Total',style: GoogleFonts.poppins(color: Colors.grey),)),
                  Visibility(visible: bgday,child: Text('Total',style: GoogleFonts.poppins(color: Colors.grey),)),
        
                ],)
              ],
            ),
          )
         ),
        
        Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
        height: 300,
        width: double.infinity,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 35000, // 👈 matches your largest value
            minX: 1,
            maxX: bgmonth?30:7,
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 60,
                  showTitles: true,
                  interval: 5000, // 👈 step on Y-axis
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: bgmonth?5:1, // 👈 step of 1 on X-axis
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: [
                FlSpot(1, bgweak ? 6170 : 0),
          FlSpot(2, bgweak ? 8170 : 0),
          FlSpot(3, bgweak ? 8400 : 0),
          const FlSpot(4, 0),
          const FlSpot(5, 0),
          const FlSpot(6, 0),
          const FlSpot(7, 33020),
               
                  
        
                ],
                isCurved: true,
                barWidth: 3,
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.2),
                ),
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
            ),
          ),
        ),
        
     Card(
  color: Colors.black,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_graph, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              'Statistics',
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        /// Row for the two expanded cards
        Row(
  children: [
    Expanded(
      child: Card(
        color: Colors.blueGrey[900],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.medal, color: Colors.amber, size: 14),
                  SizedBox(width: 6),
                  Flexible(   // 👈 prevents text from overflowing
                    child: Text(
                      'Most Active Day',
                      overflow: TextOverflow.ellipsis, // 👈 ensures no overflow
                      style: GoogleFonts.poppins(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                '33020 Steps',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Sept 7',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    SizedBox(width: 10), // spacing between cards
    Expanded(
      child: Card(
        color: Colors.blueGrey[900],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.fire, color: Colors.red, size: 14),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Longest Streak',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                '14 Days',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aug 20 - Sept 2',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
   
  ],
),

    Row(
      children: [
        Expanded(
          child: Card(color: Colors.blueGrey[900],child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(children: [
                  Icon(FontAwesomeIcons.couch,color: Colors.amber,),
                  SizedBox(width: 10,),
                  Text('Most Relaxing Day',style:GoogleFonts.poppins(color: Colors.amber,fontWeight: FontWeight.bold,fontSize: 10))
                ],),
                SizedBox(height:10),
                Row(children: [
                  Text('638 Steps',style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18))
                ],),
                SizedBox(height: 10,),
                Row(children: [
                  Text('Sept 8',style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15))
                ],)
                
              ],),
            )),
        ),
        Expanded(
          child: Card(color: Colors.blueGrey[900],child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(children: [
                  Icon(FontAwesomeIcons.bullseye,color: Colors.red,),
                  SizedBox(width: 5,),
                  Text('Goal Achieved',style:GoogleFonts.poppins(color: Colors.amber,fontWeight: FontWeight.bold,fontSize: 12))
                ],),
                 SizedBox(height:10),
                Row(children: [
                Text('2 Days',style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18))
                ],),
                SizedBox(height: 10,),
                Row(children: [
                  Text('Sept 8',style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15))
                ],)
                
              ],),
            )),
        ),
      ],
    ),
    

      ],
    ),
  ),
)

        
        
        
        ],),
      ),
    );
  }
}