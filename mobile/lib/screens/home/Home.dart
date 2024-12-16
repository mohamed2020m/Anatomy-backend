import 'package:TerraViva/components/ErrorDialog.dart';
import 'package:TerraViva/controller/objectsParCategoryController.dart';
import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:TerraViva/screens/home/LatestObjectsComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/Category.dart';
import '../../app_skoleton/appSkoleton.dart';
import '../../controller/categoryController.dart';
import '../../provider/dataCenter.dart';
import '../../service/serviceLocator.dart';
import 'CategoryComponent.dart';
import 'appBar.dart';
import 'objects/ObjectViewScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  void initState() {
    getCollection();
    super.initState();
  }

  Future getCollection() async {
    setState(() {});
  }

  final categoryController = getIt<CategoryController>();
  final object3dController = getIt<ObjectsParCategoryController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );

    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => getCollection(),
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  CustomAppBar(
                    size: size,
                  ),

                  FutureBuilder<List<ThreeDObject>>(
                    future: object3dController.getLatestObject3D(),
                    builder: (context, objectsSnapshot) {
                      if (objectsSnapshot.hasData &&
                          objectsSnapshot.data!.isNotEmpty) {
                        return LatestObjectsComponent(
                          objects: objectsSnapshot.data!,
                          onTapObject: (object) {
                            var categoryProvider =
                                Provider.of<DataCenter>(context, listen: false);
                            categoryProvider.setCurretntObject3d(object);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ObjectViewScreen(object3d: object),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // list categories:
                  FutureBuilder<List<Category>>(
                    future: categoryController.getAllCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 60),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 100,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  const Spacer(),
                                  AppSkoleton(
                                    width: 50,
                                    height: 12,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                height: size.height / 4.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 238, 238, 238),
                                        width: 2)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 156,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(18),
                                            bottomLeft: Radius.circular(18),
                                          )),
                                    ),
                                    AppSkoleton(
                                        width: size.width - 34 - 156,
                                        height: size.height / 4.5,
                                        radius: const BorderRadius.only(
                                          topRight: Radius.circular(18),
                                          bottomRight: Radius.circular(18),
                                        ),
                                        margin: EdgeInsets.zero)
                                  ],
                                )),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 30),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 120,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  const Spacer(),
                                  AppSkoleton(
                                    width: 50,
                                    height: 12,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              height: size.height / 7,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 8,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return AppSkoleton(
                                      width: size.width / 4,
                                      height: size.height / 7,
                                      margin: const EdgeInsets.only(
                                          bottom: 8, right: 5, left: 5),
                                      radius: BorderRadius.circular(8),
                                    );
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 30),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 80,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  const Spacer(),
                                  AppSkoleton(
                                    width: 40,
                                    height: 12,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              height: size.height / 5.5,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 8,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return AppSkoleton(
                                      width: size.width / 2,
                                      height: size.height / 5.5,
                                      margin: const EdgeInsets.only(
                                          bottom: 8, right: 5, left: 5),
                                      radius: BorderRadius.circular(8),
                                    );
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 30),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 80,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  const Spacer(),
                                  AppSkoleton(
                                    width: 40,
                                    height: 12,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              height: size.height / 5.5,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 8,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return AppSkoleton(
                                      width: size.width / 2,
                                      height: size.height / 5.5,
                                      margin: const EdgeInsets.only(
                                          bottom: 8, right: 5, left: 5),
                                      radius: BorderRadius.circular(8),
                                    );
                                  }),
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        final error = snapshot.error;
                        return SingleChildScrollView(
                            child: Container(
                          margin: EdgeInsets.only(top: size.height / 6),
                          child: ErrorDialog(
                            onRetry: () {
                              setState(() {});
                            },
                          ),
                        ));
                      } else if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/empty-folder.png"),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                width: 250,
                                child: Text(
                                  'Nothing to show here',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          );
                        }
                        return SizedBox(
                            width: size.width,
                            child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 10, left: 10),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return CategoryComponent(
                                            category:
                                                snapshot.data!.elementAt(index),
                                          );
                                        },
                                      )
                                    ])));
                      }
                      return Container();
                    },
                  )
                ]))));
  }
}
