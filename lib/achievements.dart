import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:gif/gif.dart';
import 'package:lottie/lottie.dart';



class AchievementsWidget extends StatefulWidget {
  const AchievementsWidget({super.key});

  @override
  State<AchievementsWidget> createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {

  late GifController controller;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Card(color: Colors.grey.shade900,child: 
          Column(children: [
           
               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                Card(color: const Color(0xFFFAE0D4),child: 
                Column(
                  children: [
                    Icon(BoxIcons.bxs_trophy,color: Color(0xFFCD7F32),size: 80,
),
Text(
      "5,000 Steps",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.5,
      ),
    ),
    const SizedBox(height: 6),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // subtle badge background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "🥉 Pathfinder",
        style: GoogleFonts.poppins(
          color: Color(0xFFCD7F32), // bronze accent
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),

                  ],
                ),),
                Card(
                  color: const Color(0xFFF2F2F2),
                  child: Column(
                    children: [
                      Icon(BoxIcons.bxs_trophy,color: Color(0xFFC0C0C0),size: 80,
                  ),
                    ],
                  ),
                )
              ],),
            
          ],),)
        ],),
      ),
    );
  }
}