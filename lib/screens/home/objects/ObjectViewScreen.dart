import 'dart:async';
import 'dart:math';
import 'package:TerraViva/models/ThreeDObject.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../controller/noteController.dart';
import '../../../models/note.dart';
import '../../../network/Endpoints.dart';
import '../../../provider/dataCenter.dart';
import '../../../service/DatabaseService.dart';
import '../../../service/serviceLocator.dart';

// class ObjectViewScreen extends StatefulWidget {
//   ObjectViewScreen({Key? key, required this.object3d}) : super(key: key);
//   late ThreeDObject object3d;

//   @override
//   _ObjectViewScreenState createState() => _ObjectViewScreenState();
// }

// class _ObjectViewScreenState extends State<ObjectViewScreen> {
//   GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
//   final TextEditingController noteController = TextEditingController();
//   List<Note> userNotes = [];
//   final NoteController noteControllerApi = getIt<NoteController>();
//   DatabaseService dbService = DatabaseService.instance;

//   void saveObject(BuildContext context) {
//     var savedProvider = Provider.of<DataCenter>(context, listen: false);
//     ThreeDObject obj = widget.object3d.clone();
//     FileDownloader.downloadFile(
//         url: '${Endpoints.baseUrl}/files/download/${widget.object3d.object}',
//         onProgress: (String? fileName, double? progress) {
//           print('FILE fileName HAS PROGRESS $progress');
//         },
//         onDownloadCompleted: (String path) {
//           print('FILE DOWNLOADED TO PATH: $path');
//           obj.object = 'file://$path';
//           FileDownloader.downloadFile(
//               url:
//                   '${Endpoints.baseUrl}/files/download/${widget.object3d.image}',
//               onProgress: (String? fileName2, double? progress) {
//                 print('FILE fileName HAS PROGRESS $progress');
//               },
//               onDownloadCompleted: (String path2) {
//                 print('FILE DOWNLOADED TO PATH: $path2');

//                 dbService.insertObject(obj.toJson());
//                 savedProvider.setSaved();
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Container(
//                       padding: const EdgeInsets.only(top: 0, bottom: 2),
//                       child: const Text(
//                         "Object saved with success.",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       )),
//                   behavior: SnackBarBehavior.floating,
//                   backgroundColor: const Color.fromARGB(255, 75, 138, 220),
//                   margin:
//                       const EdgeInsets.only(bottom: 20, left: 25, right: 25),
//                 ));
//               },
//               onDownloadError: (String error) {});
//         },
//         onDownloadError: (String error) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Container(
//                 padding: const EdgeInsets.only(top: 0, bottom: 2),
//                 child: const Text(
//                   "Object failed to download.",
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 )),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: const Color.fromARGB(255, 160, 23, 23),
//             margin: const EdgeInsets.only(bottom: 20, left: 25, right: 25),
//           ));
//         });
//   }

//   @override
//   void initState() {
//     //You can download a single file

//     getNotes();
//     super.initState();
//   }

//   Future<void> _refreshNotes() async {
//     setState(() {});
//   }

//   Future<void> getNotes() async {
//     userNotes =
//         await noteControllerApi.getNotesByThreeDObjects(widget.object3d.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var object3dProvider = Provider.of<DataCenter>(context, listen: true);

//     print(
//         "\n\n\n******** ${Endpoints.baseUrl}/files/download/${widget.object3d.object} \n\n\n");

//     return ScaffoldMessenger(
//       child: Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.info),
//               onPressed: () {
//                 showModalBottomSheet<void>(
//                     constraints: BoxConstraints(
//                         maxWidth: MediaQuery.of(context).size.width,
//                         minWidth: MediaQuery.of(context).size.width,
//                         maxHeight: MediaQuery.of(context).size.height / 3,
//                         minHeight: MediaQuery.of(context).size.height / 3),
//                     isScrollControlled: true,
//                     shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(24.0),
//                             topRight: Radius.circular(24.0))),
//                     context: context,
//                     builder: (BuildContext context) {
//                       return StatefulBuilder(builder:
//                           (BuildContext context, StateSetter setState) {
//                         return SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(
//                                     bottom: 10, left: 16, top: 10),
//                                 height: 30,
//                                 child: const Text('Description',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         color: Color.fromARGB(255, 0, 0, 0),
//                                         fontSize: 26,
//                                         fontWeight: FontWeight.bold)),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.only(
//                                     bottom: 10, left: 16, top: 10),
//                                 child: Text(widget.object3d.description,
//                                     textAlign: TextAlign.left,
//                                     style: const TextStyle(
//                                         color: Color.fromARGB(255, 0, 0, 0),
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400)),
//                               )
//                             ],
//                           ),
//                         );
//                       });
//                     });
//               },
//             ),
//           ],
//           title: Text(
//             object3dProvider.currentObject3d.name,
//             style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Color.fromARGB(255, 144, 127, 218)),
//           ),
//           centerTitle: true,
//           toolbarHeight: 50,
//           backgroundColor: const Color.fromARGB(255, 246, 246, 246),
//           shadowColor: Colors.transparent,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               // handle the press
//               Navigator.pop(context);
//             },
//           ),
//           automaticallyImplyLeading: false,
//         ),
//         // body: Text("zzzz"),
//         body: Center(
//             child: BabylonJSViewer(
//                 src:
//                     '${Endpoints.baseUrl}/files/download/${widget.object3d.object}')),
//         floatingActionButton: CircularMenu(
//             toggleButtonBoxShadow: [
//               BoxShadow(
//                 offset: const Offset(0.0, 6.0),
//                 color: Colors.grey.withOpacity(0),
//                 blurRadius: 5.0,
//               ),
//             ],
//             key: key,
//             toggleButtonColor: Colors.blue,
//             startingAngleInRadian: 1.00 * pi,
//             endingAngleInRadian: 1.25 * pi,
//             alignment: Alignment.bottomRight,
//             items: [
//               CircularMenuItem(
//                   icon: Icons.note_add,
//                   boxShadow: [
//                     BoxShadow(
//                       offset: const Offset(0.0, 6.0),
//                       color: Colors.grey.withOpacity(0),
//                       blurRadius: 5.0,
//                     ),
//                   ],
//                   color: const Color.fromARGB(255, 146, 42, 172),
//                   onTap: () {
//                     key.currentState?.reverseAnimation();
//                     showModalBottomSheet<void>(
//                         constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width,
//                             minWidth: MediaQuery.of(context).size.width,
//                             maxHeight: MediaQuery.of(context).size.height - 100,
//                             minHeight:
//                                 MediaQuery.of(context).size.height - 100),
//                         isScrollControlled: true,
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(24.0),
//                                 topRight: Radius.circular(24.0))),
//                         context: context,
//                         builder: (BuildContext context) {
//                           return StatefulBuilder(builder:
//                               (BuildContext context, StateSetter setState) {
//                             return SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                       height:
//                                           MediaQuery.of(context).size.height -
//                                               170,
//                                       padding: EdgeInsets.only(
//                                           bottom: MediaQuery.of(context)
//                                               .viewInsets
//                                               .bottom),
//                                       child: SingleChildScrollView(
//                                           child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                             Container(
//                                               margin: const EdgeInsets.only(
//                                                   bottom: 10,
//                                                   left: 10,
//                                                   top: 10),
//                                               height: 30,
//                                               child:
//                                               const Text('Ny Notes',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     color: Color.fromARGB(255, 0, 0, 0),
//                                                     fontSize: 30,
//                                                     fontWeight:FontWeight.bold)
//                                                   ),
//                                             ),

//                                             SizedBox(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .height -
//                                                   140,
//                                               child: ListView.builder(
//                                                   shrinkWrap: true,
//                                                   physics:
//                                                       const BouncingScrollPhysics(),
//                                                   itemCount: userNotes.length,
//                                                   scrollDirection:
//                                                       Axis.vertical,
//                                                   itemBuilder: (ctx, index) {
//                                                     return Dismissible(
//                                                       background: Container(
//                                                         height: 100,
//                                                         margin: const EdgeInsets
//                                                             .all(10),
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(8),
//                                                           color: Colors.blue,
//                                                         ),
//                                                         child: const Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   10),
//                                                           child: Row(
//                                                             children: [
//                                                               Icon(
//                                                                   Icons
//                                                                       .favorite,
//                                                                   color: Colors
//                                                                       .red),
//                                                               SizedBox(
//                                                                 width: 8.0,
//                                                               ),
//                                                               Text(
//                                                                   'Move to favorites',
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .white)),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       secondaryBackground:
//                                                           Container(
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(8),
//                                                           color: Colors.red,
//                                                         ),
//                                                         height: 100,
//                                                         margin: const EdgeInsets
//                                                             .all(10),
//                                                         child: const Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   10),
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .end,
//                                                             children: [
//                                                               Icon(Icons.delete,
//                                                                   color: Colors
//                                                                       .white),
//                                                               SizedBox(
//                                                                 width: 8.0,
//                                                               ),
//                                                               Text(
//                                                                   'Move to trash',
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .white)),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       confirmDismiss:
//                                                           (DismissDirection
//                                                               direction) async {
//                                                         if (direction ==
//                                                             DismissDirection
//                                                                 .startToEnd) {
//                                                           return await showDialog(
//                                                             context: context,
//                                                             builder:
//                                                                 (BuildContext
//                                                                     context) {
//                                                               return AlertDialog(
//                                                                 title: const Text(
//                                                                     "Add Gift to Cart"),
//                                                                 content: const Text(
//                                                                     "Are you sure you want to add this gift in your cart"),
//                                                                 actions: <Widget>[
//                                                                   ElevatedButton(
//                                                                       onPressed: () =>
//                                                                           Navigator.of(context).pop(
//                                                                               true),
//                                                                       child: const Text(
//                                                                           "Yes")),
//                                                                   ElevatedButton(
//                                                                     onPressed: () =>
//                                                                         Navigator.of(context)
//                                                                             .pop(false),
//                                                                     child:
//                                                                         const Text(
//                                                                             "No"),
//                                                                   ),
//                                                                 ],
//                                                               );
//                                                             },
//                                                           );
//                                                         } else {
//                                                           return await showDialog(
//                                                             context: context,
//                                                             builder:
//                                                                 (BuildContext
//                                                                     context) {
//                                                               return AlertDialog(
//                                                                 title: const Text(
//                                                                     "Remove Note"),
//                                                                 content: const Text(
//                                                                     "Are you sure you want to remove this note ?"),
//                                                                 actions: <Widget>[
//                                                                   ElevatedButton(
//                                                                       onPressed:
//                                                                           () async {
//                                                                         await noteControllerApi
//                                                                             .deleteNote(userNotes[index].id);
//                                                                         await getNotes();

//                                                                         setState(
//                                                                             () {});
//                                                                         Navigator.of(context)
//                                                                             .pop(true);
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         "Yes",
//                                                                         style:
//                                                                             TextStyle(
//                                                                           backgroundColor:
//                                                                               Colors.red,
//                                                                         ),
//                                                                       )),
//                                                                   ElevatedButton(
//                                                                     onPressed:
//                                                                         () {
//                                                                       Navigator.of(
//                                                                               context)
//                                                                           .pop(
//                                                                               false);
//                                                                     },
//                                                                     child:
//                                                                         const Text(
//                                                                             "No"),
//                                                                   ),
//                                                                 ],
//                                                               );
//                                                             },
//                                                           );
//                                                         }
//                                                       },
//                                                       key: Key(userNotes[index]
//                                                           .id
//                                                           .toString()),
//                                                       // Provide a function that tells the app
//                                                       // what to do after an item has been swiped away.

//                                                       child: Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(10),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8),
//                                                             color: const Color
//                                                                 .fromARGB(85,
//                                                                 57, 170, 245),
//                                                           ),
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .only(
//                                                                   top: 5,
//                                                                   bottom: 5,
//                                                                   left: 10,
//                                                                   right: 10),
//                                                           child: Container(
//                                                               constraints: BoxConstraints(
//                                                                   minHeight: 50,
//                                                                   minWidth: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height -
//                                                                       100 -
//                                                                       20),
//                                                               child:
//                                                                   SingleChildScrollView(
//                                                                 child: Column(
//                                                                   mainAxisSize:
//                                                                       MainAxisSize
//                                                                           .min,
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     ReadMoreText(
//                                                                       userNotes[
//                                                                               index]
//                                                                           .content,
//                                                                       trimLines:
//                                                                           3,
//                                                                       trimMode:
//                                                                           TrimMode
//                                                                               .Line,
//                                                                       trimCollapsedText:
//                                                                           'Show more',
//                                                                       trimExpandedText:
//                                                                           'Show less',
//                                                                       moreStyle: const TextStyle(
//                                                                           fontSize:
//                                                                               15,
//                                                                           fontWeight: FontWeight
//                                                                               .bold,
//                                                                           color:
//                                                                               Colors.blue),
//                                                                       lessStyle: const TextStyle(
//                                                                           fontSize:
//                                                                               15,
//                                                                           fontWeight: FontWeight
//                                                                               .bold,
//                                                                           color:
//                                                                               Colors.blue),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ))),
//                                                     );
//                                                   }),
//                                             )
//                                           ]))),
//                                   Container(
//                                     height: 70,
//                                     // You can set the height as needed
//                                     color: const Color.fromARGB(
//                                         255, 240, 242, 245),
//                                     padding: const EdgeInsets.only(
//                                         top: 10, bottom: 10),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         TextField(
//                                           onChanged: (s) =>
//                                               {setState(() => {})},
//                                           controller: noteController,
//                                           minLines: 3,
//                                           maxLines: 8,
//                                           readOnly: false,
//                                           decoration: InputDecoration(
//                                               border: InputBorder.none,
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: const BorderSide(
//                                                     color: Color.fromARGB(
//                                                         255, 255, 255, 255),
//                                                     width:
//                                                         1.0), // Change color and width for enabled (non-focused) state
//                                                 borderRadius:
//                                                     BorderRadius.circular(10.0),
//                                               ),
//                                               constraints: BoxConstraints(
//                                                   maxWidth:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .width -
//                                                           100,
//                                                   minWidth:
//                                                       MediaQuery.of(
//                                                                   context)
//                                                               .size
//                                                               .width -
//                                                           100),
//                                               filled: true,
//                                               fillColor: const Color.fromARGB(
//                                                   255, 255, 255, 255),
//                                               contentPadding:
//                                                   const EdgeInsets.all(5),
//                                               hintText: "Add new note",
//                                               hintStyle: const TextStyle(
//                                                   letterSpacing: .5,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w300,
//                                                   color: Color.fromARGB(
//                                                       255, 144, 144, 144))),
//                                         ),
//                                         InkWell(
//                                           onTap: () async {
//                                             userNotes.add(
//                                                 await noteControllerApi
//                                                     .addNewNote(
//                                                         noteController.text,
//                                                         widget.object3d.id));
//                                             noteController.clear();
//                                             // setState(() {});
//                                             _refreshNotes();
//                                           },
//                                           child: SizedBox(
//                                               width: 50,
//                                               child: Text(
//                                                 "save",
//                                                 style:
//                                                     noteController.text.isEmpty
//                                                         ? const TextStyle(
//                                                             fontSize: 20,
//                                                             color: Colors.grey)
//                                                         : const TextStyle(
//                                                             fontSize: 20,
//                                                             color: Colors.blue),
//                                               )),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                       height: MediaQuery.of(context)
//                                           .viewInsets
//                                           .bottom),
//                                 ],
//                               ),
//                             );
//                           });
//                         });
//                     // callback
//                   }),
//               CircularMenuItem(
//                   boxShadow: [
//                     BoxShadow(
//                       offset: const Offset(0.0, 6.0),
//                       color: Colors.grey.withOpacity(0),
//                       blurRadius: 5.0,
//                     ),
//                   ],
//                   icon: Icons.save_alt,
//                   color: const Color.fromARGB(255, 146, 42, 172),
//                   onTap: () {
//                     saveObject(context);
//                   }),
//             ]),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       ),
//     );
//   }
// }

class ObjectViewScreen extends StatefulWidget {
  ObjectViewScreen({Key? key, required this.object3d}) : super(key: key);
  late ThreeDObject object3d;

  @override
  _ObjectViewScreenState createState() => _ObjectViewScreenState();
}

class _ObjectViewScreenState extends State<ObjectViewScreen> {
  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  final TextEditingController noteController = TextEditingController();
  
  List<Note> userNotes = [];
  final NoteController noteControllerApi = getIt<NoteController>();
  DatabaseService dbService = DatabaseService.instance;

  // Flutter3DController controller = Flutter3DController();

  @override
  void initState() {
    //You can download a single file

    getNotes();
    super.initState();
    // controller.onModelLoaded.addListener(() {
    //   debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    // });
  }

  Future<void> _refreshNotes() async {
    setState(() {});
  }

  Future<void> getNotes() async {
    userNotes =
        await noteControllerApi.getNotesByThreeDObjects(widget.object3d.id);
  }

  @override
  Widget build(BuildContext context) {
    var object3dProvider = Provider.of<DataCenter>(context, listen: true);

    print(
        "\n\n\n******** ${Endpoints.baseUrl}/files/download/${widget.object3d.object} \n\n\n");

    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 37, 71, 146),
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
                    minHeight: MediaQuery.of(context).size.height / 3,
                  ),
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
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
                            child: Text(
                                object3dProvider.currentObject3d.description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
          title: Text(
            object3dProvider.currentObject3d.name,
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Color.fromARGB(255, 144, 127, 218)),
          ),
          centerTitle: true,
          toolbarHeight: 50,
          backgroundColor: const Color.fromARGB(255, 246, 246, 246),
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
        //   child: Flutter3DViewer(
        //       activeGestureInterceptor: true,
        //       progressBarColor: Colors.green,
        //       enableTouch: true,
        //       onProgress: (double progressValue) {
        //         debugPrint('model loading progress : $progressValue');
        //       },
        //       onLoad: (String modelAddress) {
        //         debugPrint('model loaded : $modelAddress');
        //       },
        //       onError: (String error) {
        //         debugPrint('model failed to load : $error');
        //       },
        //       controller: controller,
        //       src:
        //           '${Endpoints.baseUrl}/files/download/${widget.object3d.object}'),
        // ),
        child: BabylonJSViewer(
          src: '${Endpoints.baseUrl}/files/download/${widget.object3d.object}')),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            onPressed: () {
              // Directly show the notes modal without the save button.
              showNotesModal(context);
            },
            child: const Icon(Icons.note_add, color: Colors.white),
          ),

          
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     // IconButton(
        //     //   onPressed: () {
        //     //     // controller.playAnimation();
        //     //   },
        //     //   icon: const Icon(Icons.play_arrow, color: Colors.white),
        //     // ),
        //     // const SizedBox(
        //     //   height: 4,
        //     // ),
        //     // IconButton(
        //     //   onPressed: () {
        //     //     // controller.pauseAnimation();
        //     //     //controller.stopAnimation();
        //     //   },
        //     //   icon: const Icon(Icons.pause, color: Colors.white),
        //     // ),
        //     // const SizedBox(
        //     //   height: 4,
        //     // ),
        //     // IconButton(
        //     //   onPressed: () {
        //     //     // controller.resetAnimation();
        //     //   },
        //     //   icon: const Icon(Icons.replay_circle_filled, color: Colors.white),
        //     // ),
        //     // const SizedBox(
        //     //   height: 4,
        //     // ),
        //     // const SizedBox(
        //     //   height: 4,
        //     // ),
        //     // IconButton(
        //     //   onPressed: () {
        //     //     // controller.setCameraOrbit(20, 20, 5);
        //     //     //controller.setCameraTarget(0.3, 0.2, 0.4);
        //     //   },
        //     //   icon: const Icon(Icons.camera_alt, color: Colors.white),
        //     // ),
        //     // const SizedBox(
        //     //   height: 4,
        //     // ),
        //     // IconButton(
        //     //   onPressed: () {
        //     //     // controller.resetCameraOrbit();
        //     //     //controller.resetCameraTarget();
        //     //   },
        //     //   icon:
        //     //       const Icon(Icons.cameraswitch_outlined, color: Colors.white),
        //     // ),
        //     // const SizedBox(
        //     //   height: 4,
        //     // ),
        //     IconButton(
        //       onPressed: () {
        //         showNotesModal(context);
        //       },
        //       icon: const Icon(Icons.note_add, color: Colors.green, size: 30),
        //     )
        //   ],
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  void showNotesModal(BuildContext context) {
    showModalBottomSheet<void>(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            minWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - 100,
            minHeight: MediaQuery.of(context).size.height - 100),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height - 170,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, top: 10),
                              height: 50,
                              child: const Text('My Notes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 140,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: userNotes.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (ctx, index) {
                                    return Dismissible(
                                      background: Container(
                                        height: 100,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.blue,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.favorite,
                                                  color: Colors.red),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Text('Move to favorites',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.red,
                                        ),
                                        height: 100,
                                        margin: const EdgeInsets.all(10),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Text('Move to trash',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      confirmDismiss:
                                          (DismissDirection direction) async {
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Add Gift to Cart"),
                                                content: const Text(
                                                    "Are you sure you want to add this gift in your cart"),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: const Text("Yes")),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text("No"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Remove Note"),
                                                content: const Text(
                                                    "Are you sure you want to remove this note ?"),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        await noteControllerApi
                                                            .deleteNote(
                                                                userNotes[index]
                                                                    .id);
                                                        await getNotes();

                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),

                                                      child: const Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                          color:Colors.white,
                                                        ),
                                                      )),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text("No"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      key: Key(userNotes[index].id.toString()),
                                      // Provide a function that tells the app
                                      // what to do after an item has been swiped away.

                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: const Color.fromARGB(
                                                85, 57, 170, 245),
                                          ),
                                          margin: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 10,
                                              right: 10),
                                          child: Container(
                                              constraints: BoxConstraints(
                                                  minHeight: 50,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height -
                                                          100 -
                                                          20),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText(
                                                      userNotes[index].content,
                                                      trimLines: 3,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          'Show more',
                                                      trimExpandedText:
                                                          'Show less',
                                                      moreStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.blue),
                                                      lessStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ))),
                                    );
                                  }),
                            )
                          ]))),
                  Container(
                    height: 70,
                    // You can set the height as needed
                    color: const Color.fromARGB(255, 240, 242, 245),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextField(
                          onChanged: (s) => {setState(() => {})},
                          controller: noteController,
                          minLines: 3,
                          maxLines: 8,
                          readOnly: false,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width:
                                        1.0), // Change color and width for enabled (non-focused) state
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 100,
                                  minWidth:
                                      MediaQuery.of(context).size.width - 100),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              contentPadding: const EdgeInsets.all(5),
                              hintText: "Add new note",
                              hintStyle: const TextStyle(
                                  letterSpacing: .5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromARGB(255, 144, 144, 144))),
                        ),
                        InkWell(
                          onTap: () async {
                            print("******* ${noteController.text} *****");
                            userNotes.add(await noteControllerApi.addNewNote(
                                noteController.text, widget.object3d.id));
                            noteController.clear();
                            setState(() {});
                            _refreshNotes();
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Note created successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                          },
                          child: SizedBox(
                              width: 50,
                              child: Text(
                                "save",
                                style: noteController.text.isEmpty
                                    ? const TextStyle(
                                        fontSize: 20, color: Colors.grey)
                                    : const TextStyle(
                                        fontSize: 20, color: Colors.blue),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          });
        });
    // callback
  }

  //   return ScaffoldMessenger(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.info),
  //             onPressed: () {
  //               showModalBottomSheet<void>(
  //                   constraints: BoxConstraints(
  //                       maxWidth: MediaQuery.of(context).size.width,
  //                       minWidth: MediaQuery.of(context).size.width,
  //                       maxHeight: MediaQuery.of(context).size.height / 3,
  //                       minHeight: MediaQuery.of(context).size.height / 3),
  //                   isScrollControlled: true,
  //                   shape: const RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(24.0),
  //                           topRight: Radius.circular(24.0))),
  //                   context: context,
  //                   builder: (BuildContext context) {
  //                     return StatefulBuilder(builder:
  //                         (BuildContext context, StateSetter setState) {
  //                       return SingleChildScrollView(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               margin: const EdgeInsets.only(
  //                                   bottom: 10, left: 16, top: 10),
  //                               height: 30,
  //                               child: const Text('Description',
  //                                   textAlign: TextAlign.left,
  //                                   style: TextStyle(
  //                                       color: Color.fromARGB(255, 0, 0, 0),
  //                                       fontSize: 26,
  //                                       fontWeight: FontWeight.bold)),
  //                             ),
  //                             Container(
  //                               margin: const EdgeInsets.only(
  //                                   bottom: 10, left: 16, top: 10),
  //                               child: Text(widget.object3d.description,
  //                                   textAlign: TextAlign.left,
  //                                   style: const TextStyle(
  //                                       color: Color.fromARGB(255, 0, 0, 0),
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w400)),
  //                             )
  //                           ],
  //                         ),
  //                       );
  //                     });
  //                   });
  //             },
  //           ),
  //         ],
  //         title: Text(
  //           object3dProvider.currentObject3d.name,
  //           style: const TextStyle(
  //               fontWeight: FontWeight.w500,
  //               color: Color.fromARGB(255, 144, 127, 218)),
  //         ),
  //         centerTitle: true,
  //         toolbarHeight: 50,
  //         backgroundColor: const Color.fromARGB(255, 246, 246, 246),
  //         shadowColor: Colors.transparent,
  //         leading: IconButton(
  //           icon: const Icon(Icons.arrow_back_ios),
  //           onPressed: () {
  //             // handle the press
  //             Navigator.pop(context);
  //           },
  //         ),
  //         automaticallyImplyLeading: false,
  //       ),
  //       body: Center(
  //         child: BabylonJSViewer(src:'${Endpoints.baseUrl}/files/download/${widget.object3d.object}')),

  //         floatingActionButton: CircularMenu(
  //           toggleButtonBoxShadow: [
  //             BoxShadow(
  //               offset: const Offset(0.0, 6.0),
  //               color: Colors.grey.withOpacity(0),
  //               blurRadius: 5.0,
  //             ),
  //           ],
  //           key: key,
  //           toggleButtonColor: Colors.blue,
  //           startingAngleInRadian: 1.00 * pi,
  //           endingAngleInRadian: 1.25 * pi,
  //           alignment: Alignment.bottomRight,
  //           items: [
  //             CircularMenuItem(
  //                 icon: Icons.note_add,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     offset: const Offset(0.0, 6.0),
  //                     color: Colors.grey.withOpacity(0),
  //                     blurRadius: 5.0,
  //                   ),
  //                 ],
  //                 color: const Color.fromARGB(255, 146, 42, 172),
  //                 onTap: () {
  //                   key.currentState?.reverseAnimation();
  //                   showNotesModal(context);
  //                   // callback
  //                 }),
  //             CircularMenuItem(
  //                 boxShadow: [
  //                   BoxShadow(
  //                     offset: const Offset(0.0, 6.0),
  //                     color: Colors.grey.withOpacity(0),
  //                     blurRadius: 5.0,
  //                   ),
  //                 ],
  //                 icon: Icons.save_alt,
  //                 color: const Color.fromARGB(255, 146, 42, 172),
  //                 onTap: () {
  //                   saveObject(context);
  //                 }),
  //           ]),
  //       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
  //     ),
  //   );
  // }
}
