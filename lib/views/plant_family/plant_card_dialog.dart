import 'package:flutter/material.dart';
import 'package:flutter_app/models/plant.dart';
import 'package:flutter_app/models/wiki.dart';
import 'package:flutter_app/repositories/wiki_repo.dart';
import 'package:flutter_app/views/wiki/wiki_detail_page.dart';
import 'package:flutter_app/views/growth_log/growth_log_list_page.dart';
import 'package:intl/intl.dart';

class PlantCardDialog extends StatelessWidget {
  final Plant plant;
  final WikiRepository wikiRepository = WikiRepository();

  PlantCardDialog({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  plant.imageUrl,
                  height: 350,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: IconButton.filled(
                  icon: Icon(Icons.highlight_off),
                  color: Color.fromARGB(141, 0, 0, 0),
                  style: IconButton.styleFrom(
                      backgroundColor: const Color.fromARGB(68, 255, 255, 255)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              /*Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  color: Color.fromARGB(141, 0, 0, 0),
                  style: IconButton.styleFrom(backgroundColor: const Color.fromARGB(68, 255, 255, 255)),
                  onPressed: () {
                    // 相機功能待實現
                  },
                ),
              ),*/
              /*Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.book_outlined),
                  color: Color.fromARGB(141, 0, 0, 0),
                  style: IconButton.styleFrom(backgroundColor: const Color.fromARGB(68, 255, 255, 255)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GrowthLogListPage(),
                      ),
                    );
                  }
                ),
              ),*/
            ],
          ),
          Container(
            width: 400,
            height: 230,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                color: Color.fromARGB(255, 216, 243, 224)),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plant.nickName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromARGB(255, 37, 67, 45),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 22, top: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 216, 243, 224),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: 45,
                              child: Row(
                                children: [
                                  Container(
                                    height: 20,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      plant.species,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 18),
                                ],
                              ),
                            ),
                            Positioned(
                              right: -2,
                              top: -5,
                              child: IconButton(
                                icon: Icon(Icons.info, size: 14),
                                color: Color.fromARGB(255, 74, 142, 93),
                                onPressed: () async {
                                  Wiki? wiki = await wikiRepository
                                      .getWikiByName(plant.species);
                                  if (wiki != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WikiDetailPage(wiki: wiki),
                                      ),
                                    );
                                  } else {
                                    // 顯示錯誤信息或提示
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.bookmarks),
                          color: Color.fromARGB(151, 0, 0, 0),
                          iconSize: 22,
                          //style: IconButton.styleFrom(backgroundColor: const Color.fromARGB(68, 255, 255, 255)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GrowthLogListPage(
                                  plantID: plant.id ?? 'fail to load plant id',
                                ),
                              ),
                            );
                          }),
                      /*IconButton(
                        icon: const Icon(Icons.border_color_rounded),
                        color: const Color.fromARGB(131, 0, 0, 0),
                        iconSize: 20,
                        onPressed: () {
                          // 書寫按鈕功能待實現
                        },
                      ),*/
                    ],
                  ),
                  SizedBox(height: 16),
                  buildInfoRow('入住時間', plant.plantingDate, context),
                  SizedBox(height: 8),
                  buildInfoRow('下次澆水', plant.nextWateringDate, context),
                  SizedBox(height: 8),
                  buildInfoRow('下次施肥', plant.nextFertilizationDate, context),
                  SizedBox(height: 8),
                  buildInfoRow('下次修剪', plant.nextPruningDate, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, DateTime? date, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          height: 30,
          decoration: const BoxDecoration(
            color: const Color.fromARGB(255, 93, 176, 117),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
