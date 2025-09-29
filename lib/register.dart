import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
   TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.3,),
            
            Text('Register',style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
            SizedBox(height: 40,),
            
             TextFormField(controller: nameController,decoration: InputDecoration(hintText: 'Enter your name',hintStyle: GoogleFonts.poppins(color: Colors.black),border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),// WHEN NOT FOCUSED
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey,width: 2)))),
            SizedBox(height: 20,),
            TextFormField(controller: emailController,inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9@._-]")),
            ],decoration: InputDecoration(hintText: 'Enter Your Email Address',hintStyle: GoogleFonts.poppins(color: Colors.black),border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),// WHEN NOT FOCUSED
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey,width: 2)))),
            SizedBox(height: 20,),
             TextFormField(controller: passwordController,decoration: InputDecoration(hintText: 'Choose a Strong Password',hintStyle: GoogleFonts.poppins(color: Colors.black),border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),// WHEN NOT FOCUSED
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey,width: 2)))),
            
            SizedBox(height: 40,),
            ElevatedButton.icon(onPressed: (){}, label: Text('Register',style: GoogleFonts.poppins(color: Colors.white,fontSize: 22),),icon: Icon(Icons.check_circle,size: 20,),style: ElevatedButton.styleFrom(iconColor: Colors.green,textStyle: TextStyle(color: Colors.black,),backgroundColor: Colors.black,),),
           
        
          ],
        ),
      ),
    );
  }
}