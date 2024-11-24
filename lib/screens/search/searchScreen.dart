import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:TerraViva/screens/home/subCategory/CategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_skoleton/appSkoleton.dart';
import '../../controller/categoryController.dart';
import '../../controller/searchController2.dart';
import '../../models/Category.dart';
// import '../../models/Object3d.dart';
import '../../network/Endpoints.dart';
import '../../provider/dataCenter.dart';
import '../../service/serviceLocator.dart';
import '../home/objects/ObjectViewScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final homeController = getIt<SearchController2>();
  SearchType searchType = SearchType.category;
  Future<List<dynamic>>? future;
  final controller = getIt<SearchController2>().searchController;
  final categoryController = getIt<CategoryController>();
  @override
  void initState() {
    controller.clear();
    // TODO: implement initState
    super.initState();
  }

  void search(String c) {
    if (searchType == SearchType.tous) {
      setState(() {
        future = homeController.getAllResult();
      });
    } else if (searchType == SearchType.category) {
      setState(() {
        future = homeController.getAllCategorys();
      });
    } else if (searchType == SearchType.object3d) {
      setState(() {
        future = homeController.getAllObject3d();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // handle the press
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      // appBar: AppBar(
      //   title: Text('Search'),
      //   centerTitle: true,
      // ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: MediaQuery.of(context).size.height / 18,
                            child: TextField(
                              controller: controller,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              onChanged: search,
                              autofocus: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 242, 242, 242),
                                  contentPadding: const EdgeInsets.all(10),
                                  suffixIcon: const Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 144, 144, 144),
                                    size: 24,
                                    textDirection: TextDirection.ltr,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  hintText: "search",
                                  hintStyle: const TextStyle(
                                      letterSpacing: .5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color:
                                          Color.fromARGB(255, 144, 144, 144))),
                            ),
                          )
                        ]),
                    getCategoryUI(),
                  ],
                )),
            controller.text.isNotEmpty
                ? searchResult()
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
    // callback: widget.callBack,
  }

  Widget searchResult() {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 12,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (ctx, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: size.width / 1.5,
                            height: size.height / 9,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSkoleton(
                                      width: size.width / 4,
                                      height: 13,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      radius: BorderRadius.circular(15)),
                                  AppSkoleton(
                                      width: size.width / 2,
                                      height: 10,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      radius: BorderRadius.circular(15)),
                                ])),
                        const Spacer(),
                        AppSkoleton(
                            width: size.width / 5.5,
                            height: size.height / 10,
                            margin:
                                const EdgeInsets.only(bottom: 15, right: 15),
                            radius: BorderRadius.circular(5))
                      ],
                    );
                  }));
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          return Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 20, right: 15, left: 15, top: 64),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/error.png"),
                                fit: BoxFit.cover)),
                      )),
                      Flexible(
                          child: Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, bottom: 16),
                        child: const Text(
                          "Essayons a nouveau de charger votre données",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )),
                      Flexible(
                          child: Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: const Text(
                          "An error occurred while loading your data. Press Retry to load your data again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                      Flexible(
                          child: Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                      Flexible(
                          child: SizedBox(
                              width: 120,
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color.fromARGB(255, 0, 87, 209)),
                                ),
                                onPressed: () {
                                  search("");
                                },
                                child: const Text("Réessayer",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              )))
                    ],
                  );
                }),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 1,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 8, top: 84),
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no-results.png"),
                                    fit: BoxFit.cover)),
                          ),
                          const Text(
                            'No results found.',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          )
                        ],
                      );
                    }));
          }
          return Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (ctx, index) {
                    if (searchType == SearchType.tous) {
                      return allList(snapshot.data![index], size, index);
                    } else if (searchType == SearchType.category) {
                      return categoryList(snapshot.data![index], size);
                    } else if (searchType == SearchType.object3d) {
                      return object3dList(snapshot.data![index], size);
                    }
                    return null;
                  }));
        }
        return Container();
      },
    );
  }

  Widget categoryList(Category category, Size size) {
    var categoryInfo = Provider.of<DataCenter>(context, listen: false);
    return InkWell(
        onTap: () {
          categoryInfo.setCurretntCategory(category);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryScreen()),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Color.fromARGB(64, 201, 194, 194)),
          )),
          padding: const EdgeInsets.only(left: 0, right: 15, top: 4, bottom: 4),
          margin: const EdgeInsets.only(left: 25),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        category.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
                      width: size.width / 1.5,
                      child: Text(
                        category.description,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                    FutureBuilder<int>(
                      future: categoryController.getCategoryCount(category.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: AppSkoleton(
                              width: 80,
                              height: 20,
                              margin: const EdgeInsets.only(
                                  bottom: 8, right: 5, left: 5),
                              radius: BorderRadius.circular(5),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            //TODO: objetc count
                            child: Text(
                              '${snapshot.data} objects',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                    // Divider(
                    //   height: 8,
                    //   color: Colors.grey,
                    //   indent : 35,
                    //   endIndent: 35,)
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: size.width / 5.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image(
                  image: NetworkImage(
                      '${Endpoints.baseUrl}/files/download/${category.image}'),
                ),
              ),
            ],
          ),
        ));
  }

  Widget object3dList(ThreeDObject object3d, Size size) {
    var coursInfo = Provider.of<DataCenter>(context, listen: false);
    return InkWell(
        onTap: () {
          coursInfo.setCurretntObject3d(object3d);
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => ObjectViewScreen(
                        object3d: object3d,
                      )));
        },
        child: Container(
          decoration: const BoxDecoration(),
          padding: const EdgeInsets.only(left: 0, right: 15, top: 4, bottom: 4),
          margin: const EdgeInsets.only(left: 25),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        object3d.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
                      width: size.width / 1.5,
                      child: Text(
                        object3d.description,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image(
                  image: NetworkImage(
                      '${Endpoints.baseUrl}/files/download/${object3d.image}'),
                ),
              ),
            ],
          ),
        ));
  }

  Widget allList(List list, Size size, int index) {
    if (index == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, bottom: 8),
            child: const Text(
              "Categories",
              style: TextStyle(
                  color: Color.fromARGB(255, 75, 138, 220),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3),
            ),
          ),
          list.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (ctx, index) {
                    return categoryList(list[index], size);
                  })
              : Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: const Text("(No results found.)"))
        ],
      );
    } else if (index == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, top: 15, bottom: 8),
            child: const Text("3d Objects",
                style: TextStyle(
                    color: Color.fromARGB(255, 75, 138, 220),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3)),
          ),
          list.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (ctx, index) {
                    return object3dList(list[index], size);
                  })
              : Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: const Text("(No results found.)"))
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 16,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: <Widget>[
                  getButtonUI(
                      SearchType.category, searchType == SearchType.category),
                  const SizedBox(
                    width: 16,
                  ),
                  getButtonUI(
                      SearchType.object3d, searchType == SearchType.object3d),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget getButtonUI(SearchType searchTypeData, bool isSelected) {
    String txt = '';
    if (SearchType.tous == searchTypeData) {
      txt = 'All';
    } else if (SearchType.category == searchTypeData) {
      txt = 'Category';
    } else if (SearchType.object3d == searchTypeData) {
      txt = '3d Object';
    }
    return Container(
      decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 75, 138, 220)
              : const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(color: const Color.fromARGB(255, 75, 138, 220))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            setState(() {
              searchType = searchTypeData;
              if (!isSelected && controller.text.isNotEmpty) {
                if (searchType == SearchType.tous) {
                  setState(() {
                    future = homeController.getAllResult();
                  });
                } else if (searchType == SearchType.category) {
                  setState(() {
                    future = homeController.getAllCategorys();
                  });
                } else if (searchType == SearchType.object3d) {
                  setState(() {
                    future = homeController.getAllObject3d();
                  });
                }
              }
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            child: Center(
              child: Text(
                txt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color: isSelected
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromARGB(255, 75, 138, 220),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum SearchType { tous, category, object3d }
