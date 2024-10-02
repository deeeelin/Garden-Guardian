import 'package:flutter/material.dart';
import 'package:flutter_app/models/appUser.dart';
import 'package:flutter_app/models/plant.dart';
import 'package:flutter_app/models/wiki.dart';
import 'package:flutter_app/repositories/wiki_repo.dart';
import 'package:flutter_app/repositories/appUser_repo.dart';
import 'package:flutter_app/views/plant_family/plant_card_dialog.dart';
import 'package:flutter_app/views/wiki/wiki_detail_page.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final AppUserRepository _appUserRepo = AppUserRepository();
  final WikiRepository wikiRepository = WikiRepository();

  PlantCard({super.key, required this.plant});

  void _showPlantDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlantCardDialog(
          plant: plant,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPlantDetailsDialog(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: const Color.fromARGB(255, 216, 243, 224),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 植物圖片
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  plant.imageUrl,
                  //height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 植物名稱
                  Expanded(
                    child: Center(
                      child: Text(
                        plant.nickName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // 小按鈕
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () async {
                      Wiki? wiki =
                          await wikiRepository.getWikiByName(plant.species);
                      if (wiki != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WikiDetailPage(wiki: wiki),
                          ),
                        );
                      } else {
                        // 顯示錯誤信息或提示
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 5,),
                  // 澆水按鈕
                  Expanded(
                    child: Tooltip(
                      message: 'water +1',//'澆水+1',
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.water_drop,
                          size: 16,
                          color: Color.fromARGB(255, 39, 159, 255),
                        ),
                        label: const FittedBox(
                          fit: BoxFit.none,
                          child: Text(
                            'water',//"澆水",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 39, 159, 255),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 196, 228, 244),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.only(left: 5, right: 5),
                        ),
                        onPressed: () async {
                          try {
                            appUser? currentUser =
                                await _appUserRepo.getCurrentAppUser("test");
                            if (currentUser != null) {
                              String userId = currentUser.id;
                              await _appUserRepo.incrementCntWatering(userId);
                              print('cnt_watering 已成功增加 1');
                            } else {
                              print('用戶未登錄');
                            }
                          } catch (e) {
                            print('增加 cnt_watering 時發生錯誤: $e');
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  // 施肥按鈕
                  Expanded(
                    child: Tooltip(
                      message: "fertilize +1", //"施肥+1",
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.local_florist,
                            size: 16, color: Color.fromARGB(255, 97, 178, 121)),
                        label: FittedBox(
                          fit: BoxFit.none,
                          child: const Text(
                            "fertilize",//"施肥",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 97, 178, 121)),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 196, 229, 202),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.only(left: 5, right: 5),
                        ),
                        onPressed: () {
                          // 按鈕功能待實現
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  // 修剪按鈕
                  Expanded(
                    child: Tooltip(
                      message: "prune +1",//"修剪+1",
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.content_cut,
                            size: 16, color: Color.fromARGB(255, 245, 121, 58)),
                        label: FittedBox(
                          fit: BoxFit.none,
                          child: const Text(
                            "prune",//"修剪",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 245, 121, 58)),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 223, 173),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.only(left: 5, right: 5),
                        ),
                        onPressed: () {
                          // 按鈕功能待實現
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
