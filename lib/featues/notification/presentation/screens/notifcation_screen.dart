import 'package:flutter/material.dart';
import 'package:spendly/featues/dashboard/presentation/widgets/my_topbar.dart';

class NotifcationScreen extends StatefulWidget {
  const NotifcationScreen({super.key});

  @override
  State<NotifcationScreen> createState() => _NotifcationsState();
}

class _NotifcationsState extends State<NotifcationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Column(children: [
        SizedBox(height: 10,),
        Expanded(child: _whiteBody() )
      ],)),
    );
  }

  Container _whiteBody() {
    return Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                MyTopbar(pageName: "Notifications"),
                SizedBox(height: 20),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          );
  }
}