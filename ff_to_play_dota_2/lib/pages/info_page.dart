import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('О разработчике'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Neumorphic(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              style: NeumorphicStyle(
                lightSource: LightSource.top,
                depth: -5,
                color: NeumorphicTheme.variantColor(context),
              ),
              child: const Text(
                'Wuether',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 180),
          Expanded(
            child: Neumorphic(
              style: NeumorphicStyle(
                lightSource: LightSource.top,
                depth: 5,
                color: NeumorphicTheme.variantColor(context),
                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(30))),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text(
                        'by Михаил Тимофеев',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Версия 19.3'),
                      Text('от 17 октября 2021'),
                    ],
                  ),
                  const Text(
                    '2021',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}