import 'package:flutter/material.dart';
import 'package:flutter_app/views/search_bar.dart';
import 'package:flutter_app/views/plant_family/plant_card.dart';
import 'package:flutter_app/models/plant.dart';
import 'package:flutter_app/repositories/location_repo.dart';
import 'package:flutter_app/repositories/plant_repo.dart';
import 'package:flutter_app/views/wiki/wiki_list_page.dart';

class PlantFamilyPage extends StatefulWidget {
  const PlantFamilyPage({Key? key}) : super(key: key);

  @override
  State<PlantFamilyPage> createState() => _PlantFamilyPageState();
}

class _PlantFamilyPageState extends State<PlantFamilyPage> {
  final LocationRepository _locationRepo = LocationRepository();
  final PlantRepository _plantRepo = PlantRepository();

  String searchVal = '';
  List<Plant> searchResults = [];
  String selectedLocation = '';
  int currentPage = 0;
  PageController _pageController = PageController();

  void _searchPlants(String query) {
    setState(() {
      searchVal = query;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    if (_locationRepo.getLocations().isNotEmpty) {
      selectedLocation = _locationRepo.getLocations().first.name;
    }
  }

  void _initializeData() {
    _locationRepo.addLocation("living room");
    _locationRepo.addLocation("balcony");   //"陽台"
    _locationRepo.addLocation("yard"); //"臥房陽台"
  }

  void _addLocation(String location) {
    setState(() {
      _locationRepo.addLocation(location);
      if (selectedLocation.isEmpty) {
        selectedLocation = location;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 93, 176, 117),
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const SizedBox(height: 10),
              SearchAppBar(
                hintLabel: "Search",
                onSubmitted: (value) {
                  setState(() {
                    searchVal = value;
                  });
                  _searchPlants(value);
                },
              ),
              const SizedBox(height: 10),
              _buildLocationTabs(),
              StreamBuilder<List<Plant>>(
                stream: _plantRepo.streamAllPlants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No plants available');
                  } else {
                    List<Plant> allPlants = snapshot.data!;
                    List<Plant> filteredPlants = searchVal.isEmpty
                        ? allPlants
                        : allPlants
                            .where((plant) => plant.nickName!
                                .toLowerCase()
                                .startsWith(searchVal.toLowerCase()))
                            .toList();
                    return _buildPlantGrid(filteredPlants);
                  }
                },
              ),
              _buildPageIndicator(),
              SizedBox(height: 25)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ..._locationRepo.getLocations().map((location) => Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
                child: ChoiceChip(
                  label: Text(location.name),
                  backgroundColor: const Color.fromARGB(255, 93, 176, 117),
                  selectedColor: Colors.white,
                  labelStyle: TextStyle(
                      color: selectedLocation == location.name
                          ? const Color.fromARGB(255, 93, 176, 117)
                          : Colors.white,
                      fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        width: 2,
                        color: selectedLocation == location.name
                            ? Colors.transparent
                            : Colors.white,
                      )),
                  selected: selectedLocation == location.name,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedLocation = location.name;
                      currentPage = 0;
                      _pageController.jumpToPage(0);
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPlantGrid(List<Plant> plants) {
    List<Plant> locationPlants =
        plants.where((plant) => plant.locationId == selectedLocation).toList();
    int pageCount = (locationPlants.length / 4).ceil();

    return Expanded(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            if (currentPage < pageCount) {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          } else if (details.primaryVelocity! > 0) {
            if (currentPage > 0) {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: pageCount,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemBuilder: (context, pageIndex) {
            int startIndex = pageIndex * 4;
            int endIndex = (startIndex + 4).clamp(0, locationPlants.length);
            List<Plant> pagePlants =
                locationPlants.sublist(startIndex, endIndex);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: pagePlants.length,
                itemBuilder: (context, index) {
                  return PlantCard(plant: pagePlants[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return StreamBuilder<List<Plant>>(
      stream: _plantRepo.streamAllPlants(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        List<Plant> plants = snapshot.data!;
        List<Plant> locationPlants = plants
            .where((plant) => plant.locationId == selectedLocation)
            .toList();
        int pageCount = (locationPlants.length / 4).ceil();
        bool needsExtraPage = locationPlants.length % 4 == 0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount + (needsExtraPage ? 1 : 0),
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? Colors.white
                    : const Color.fromARGB(255, 216, 243, 224),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 93, 176, 117),
      centerTitle: true,
      title: const Text("My Plants", style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,)),
      actions: [
        InkWell(
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0, top: 8.0),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  Text('wiki', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WikiListPage(),
                ),
              );
            }),
      ],
    );
  }

  void _showAddPlantDialog() {
    String newPlantName = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("新增植物"),
          content: TextField(
            onChanged: (value) {
              newPlantName = value;
            },
            decoration: const InputDecoration(hintText: "植物名稱"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                if (newPlantName.isNotEmpty) {
                  // TODO: Add the logic to create a new plant
                }
                Navigator.of(context).pop();
              },
              child: const Text("確認"),
            ),
          ],
        );
      },
    );
  }
}
