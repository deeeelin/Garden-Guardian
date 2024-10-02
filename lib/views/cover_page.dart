import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/navigation.dart';

class CoverPage extends StatelessWidget {
  const CoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/cover.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.black,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Garden Guardian',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none),
                    ),
                  ), //Icon(Icons.task_alt)
                  SizedBox(height: 60.0),
                  SizedBox(
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✔     Green Thumb AI: Your personal AI plant care assistant!',
                              //'✔     綠指智能：您的專屬AI植物照護助手！',
                              style: TextStyle(
                                  color: Color.fromARGB(232, 255, 255, 255),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '✔     Care Schedule: Auto reminders based on plant status.',
                              //'✔     照護排程：依據植物狀態，自動提醒照護排程',
                              style: TextStyle(
                                  color: Color.fromARGB(232, 255, 255, 255),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '✔     Image Recognition: Identify plant species with a photo.',
                              //'✔     圖像辨識：只需一張照片，識別植物種類',
                              style: TextStyle(
                                  color: Color.fromARGB(232, 255, 255, 255),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '✔     Healing and Growth: Grow with your plants.',
                              //'✔     身心療癒與成長：和您的植物一起成長',
                              style: TextStyle(
                                  color: Color.fromARGB(232, 255, 255, 255),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 20),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
              child: Container(
                color: Colors.black,
              ),
            ),
            Container(
              width: screenWidth,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () =>
                      Provider.of<NavigationService>(context, listen: false)
                          .goAuth(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 93, 176, 117),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle:
                        const TextStyle(fontSize: 20.0, color: Colors.white),
                    minimumSize: Size(screenWidth * 0.6, 48), // 按鈕寬度為螢幕寬度的80%
                  ),
                  child: const Center(
                      child: Text(
                    'I love it!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: (screenHeight - 370 < 0) ? 0 : screenHeight - 370,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
