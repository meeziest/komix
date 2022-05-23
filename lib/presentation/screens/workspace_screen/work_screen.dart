import 'package:flutter/material.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/page_list_widget.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({Key? key}) : super(key: key);

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final items = ['1', '2', '3', '4', '5'];
    String? selected;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          color: Colors.deepOrange,
                          child: Text('SCAN'),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: PageList(),
                      ),
                      Expanded(
                          flex: 4,
                          child: InteractiveViewer(
                            minScale: 0.2,
                            child: Container(
                              padding: const EdgeInsets.all(50),
                              color: Colors.white12,
                              child: Image.network(
                                  'https://i.pinimg.com/564x/33/2f/df/332fdf5e093b7a3521592fea4f04c53e.jpg'),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),
                        child: const Text('ReInject'),
                        onPressed: () {},
                      )),
                  TranslationCellsWidget(
                    text1: 'Was I late?',
                    text2: '',
                  ),
                  TranslationCellsWidget(
                    text1: 'You were right in time, Dad?!',
                    text2: '',
                  ),
                  TranslationCellsWidget(
                    text1: 'No..',
                    text2: '',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TranslationCellsWidget extends StatelessWidget {
  const TranslationCellsWidget({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: Colors.white12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.black12)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      controller: TextEditingController(text: text1),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.black12)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      controller: TextEditingController(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              child: MaterialButton(
                onPressed: () {},
                child: const Icon(Icons.translate, color: Colors.blueAccent),
                shape: const CircleBorder(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
