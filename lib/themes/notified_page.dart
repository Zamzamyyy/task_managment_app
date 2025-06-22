import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotifiedPage extends StatelessWidget {
  const NotifiedPage({super.key, required this.label});
  final String? label;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode?Colors.grey[600]:Colors.white,
        leading: IconButton(onPressed: ()=>Get.back(),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(this.label.toString().split("|")[0],
        style: TextStyle(
          color: Colors.black
        ),),

        centerTitle: true,
      ),
      body: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Get.isDarkMode?Colors.white:Colors.green[600]
    ),
        child: Center(
          child: Text(this.label.toString().split("|")[0],
              style: TextStyle(
              color: Get.isDarkMode?Colors.black:Colors.white,
    fontSize: 30
                ),
              ),
        )));  }
}
