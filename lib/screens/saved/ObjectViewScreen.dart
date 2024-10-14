import 'dart:math';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/Object3d.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../controller/noteController.dart';
import '../../../models/note.dart';
import '../../../network/Endpoints.dart';
import '../../../provider/dataCenter.dart';
import '../../../service/DatabaseService.dart';
import '../../../service/serviceLocator.dart';

class SavedObjectViewScreen extends StatefulWidget {
  SavedObjectViewScreen({Key? key, required this.object3d}) : super(key: key);
  late Object3d object3d;

  @override
  _SavedObjectViewScreenState createState() => _SavedObjectViewScreenState();
}

class _SavedObjectViewScreenState extends State<SavedObjectViewScreen> {
  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  final TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var object3dProvider = Provider.of<DataCenter>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                showModalBottomSheet<void>(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        minWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height / 3,
                        minHeight: MediaQuery.of(context).size.height / 3),
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0))),
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 16, top: 10),
                                height: 30,
                                child: Text('Description',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 16, top: 10),
                                child: Text(widget.object3d.description,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              )
                            ],
                          ),
                        );
                      });
                    });
              },
            ),
          ],
          title: Text(
            object3dProvider.currentObject3d.name,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          toolbarHeight: 50,
          backgroundColor: Color.fromARGB(255, 246, 246, 246),
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
        body: Center(
          child: BabylonJSViewer(src: widget.object3d.data),
        ));
  }
}
