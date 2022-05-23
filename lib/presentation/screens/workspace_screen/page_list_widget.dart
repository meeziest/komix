import 'package:flutter/material.dart';

class PageList extends StatelessWidget {
  const PageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(
                  'https://i.pinimg.com/564x/33/2f/df/332fdf5e093b7a3521592fea4f04c53e.jpg'),
              const Center(
                child: Text(
                  "Page 1",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Image.network(
                  'https://i.pinimg.com/originals/07/df/39/07df39b81ea516d254b56ff8289aea36.jpg'),
              const Center(child: Text("Page 2", style: TextStyle(color: Colors.white))),
              Image.network('https://cm.blazefast.co/08/6d/086d8a3b8052e0ce601edf9534e00708.jpg'),
              const Center(child: Text("Page 3", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    ]);
  }
}
