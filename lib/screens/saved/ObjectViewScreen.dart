import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:TerraViva/models/Object3d.dart';
import 'package:provider/provider.dart';
import '../../../provider/dataCenter.dart';

class SavedObjectViewScreen extends StatefulWidget {
  SavedObjectViewScreen({Key? key, required this.object3d}) : super(key: key);
  late ThreeDObject object3d;

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
                    shape: const RoundedRectangleBorder(
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
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 16, top: 10),
                                height: 30,
                                child: const Text('Description',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 16, top: 10),
                                child: Text(widget.object3d.description,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
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
            style: const TextStyle(fontWeight: FontWeight.w500),
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
        body: Center(
          child: BabylonJSViewer(src: widget.object3d.object),
        ));
  }
}
