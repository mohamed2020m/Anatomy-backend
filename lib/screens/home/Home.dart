import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Category.dart';
import '../../app_skoleton/appSkoleton.dart';
import '../../controller/categoryController.dart';

import '../../models/Object3d.dart';
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => getCollection(),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  CustomAppBar(
                    size: size,
                  ),

                  /// AppBar
                  FutureBuilder<List<Category>>(
                    future: categoryController.getAllCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 60),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 100,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  Spacer(),
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
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                height: size.height / 4.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 238, 238, 238),
                                        width: 2)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 156,
                                      decoration: BoxDecoration(
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
                                        radius: BorderRadius.only(
                                          topRight: Radius.circular(18),
                                          bottomRight: Radius.circular(18),
                                        ),
                                        margin: EdgeInsets.zero)
                                  ],
                                )),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 30),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 120,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  Spacer(),
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
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 10),
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
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 30),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 80,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  Spacer(),
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
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 10),
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
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 30),
                              child: Row(
                                children: [
                                  AppSkoleton(
                                    width: 80,
                                    height: 15,
                                    margin: const EdgeInsets.only(
                                        bottom: 8, right: 5, left: 5),
                                    radius: BorderRadius.circular(5),
                                  ),
                                  Spacer(),
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
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 10),
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
                          margin: EdgeInsets.only(top: size.height / 4),
                          child: AlertDialog(
                            alignment: Alignment.center,
                            insetPadding: EdgeInsets.symmetric(horizontal: 70),
                            buttonPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            contentPadding:
                                const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8),
                                  child: Text(
                                    "impossible de charger les données",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 16),
                                  child: Text(
                                    "Veuillez recommencer",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      onTap: () {
                                        //TODO:
                                        //newCourses.setError(false);
                                        // var categoryProvider = Provider.of<DataCenter>(context, listen: false);
                                        // Object3d object3d = Object3d(id: 1,name:"lorem ipsum",description:"bla bla bla",image: "",data:"");
                                        // categoryProvider.setCurretntObject3d(object3d);
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectViewScreen(object3d:object3d)));
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.5),
                                        )),
                                        height: 50,
                                        child: const Center(
                                          child: Text("Réessayer",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                        // return Center(
                        //   child: Text(
                        //     "Error: " + error.toString(),
                        //   ),
                        // );
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
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/empty-folder.png"),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                width: 250,
                                child: Text(
                                  'Y\'a aucun chapitre disponible pour ce cours',
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
                                physics: ScrollPhysics(),
                                // physics: const BouncingScrollPhysics(),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 10, left: 10),
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
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
