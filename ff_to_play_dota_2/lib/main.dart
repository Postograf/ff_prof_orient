import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _temperature = -17;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SlidingUpPanel(
          minHeight: 230,
          maxHeight: 350,
          panel: Column(children: [
            const Padding(padding: EdgeInsets.only(top: 5)),
            Container(
              height: 7,
              width: 70,
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
            Row(
              children: [
                ListView.builder(itemBuilder: (itemBuilder))
              ]
            )
          ]),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/1afcdb77-a170-43b2-8df1-5580cbb59302.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                          iconSize: 40,
                          color: Colors.white),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _temperature++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("$_temperature°C",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            fontFamily: 'Begas'
                        )
                    ),
                  ],
                ),
              ])),
        ),
      );
}

// SlidingUpPanel(
//
// ),
// ),
// )
