// import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


void sendNotification(String fmctoken , String name, String message) async {
  final String serverKey = 'AAAAntBPKPk:APA91bGqz8Pb2So7eP9oWUE8dbIUZ8kmjj9v7o6BI9a5VCB6JI3utBbUWOdPYhaWWocrTXsqrWh5UVTXEYdlBKot1H5KpxYdl2tSLrO3gGcmDrFjhKcLSDXnuTkukAVE1uYyD6pouaj_'; // Replace with your FCM server key
  final String targetFCMToken = fmctoken; // Replace with the FCM token of the device

  final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final Map<String, dynamic> body = {
    'to': targetFCMToken,
    'notification': {
      'title': 'Message from $name',
      'body': '$message',
    },
    'data': {
      'key1': 'value1',
      'key2': 'value2',
    },
  };

  final http.Response response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
    print('Response: ${response.body}');
  } else {
    print('Failed to send notification');
    print('Response: ${response.body}');
  }
}
class MyChatPage extends StatefulWidget {
  final String uid;
  final String currentUid;
  final String productid;
  final String name;

  const MyChatPage({required this.currentUid,required this.uid,required this.productid,required this.name, Key? key}) : super(key: key);

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  
  List<types.Message> _messages = [];
  final _user =  types.User(
    id: FirebaseAuth.instance.currentUser!.uid,
  );

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      // _messages.insert(0, message);
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

void _handleSendPressed(types.PartialText message) async {
  final textMessage = types.TextMessage(
    author: _user,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: const Uuid().v4(),
    text: message.text,
  );

  try {
    await FirebaseFirestore.instance.collection('productlist').doc(widget.productid.toString()).collection(widget.uid).add(textMessage.toJson());
    var fcmtok = (await FirebaseFirestore.instance.collection('Users').doc(widget.uid).get()).data();
    print(fcmtok!['fmctoken']);
       sendNotification(fcmtok['fmctoken'],widget.name,message.text);

    _addMessage(textMessage);
    _addMessage(textMessage);
  } catch (error) {
    print('Error sending message to Firestore: $error');
    // Handle error (e.g., show a snackbar)
  }
}



void _loadMessages()  {
  FirebaseFirestore.instance.collection('productlist').doc(widget.productid.toString()).collection(widget.uid).orderBy('createdAt',descending: true).snapshots().listen(
    (snapshot) {
      final messages = snapshot.docs
          .map((doc) {
            final data = doc.data();
            return types.Message.fromJson(data);
          })
          
          // ignore: unnecessary_null_comparison
          .where((message) => message != null) // Filter out null messages
          .cast<types.Message>() // Cast to List<types.Message>
          .toList();

      setState(() {
        _messages = messages;
      });
    },
  );
}


@override
Widget build(BuildContext context) { 
  return Scaffold(
    backgroundColor: Color(0xFFDEEFFD),
    
  body: SingleChildScrollView(
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
        width: double.infinity,
        height: 87,
        decoration: BoxDecoration(
            color: Color(0xFFDEEFFD),
            border: Border(
                    // left: BorderSide(color: Color(0xFF607D8B)),
                    // top: BorderSide(color: Color(0xFF607D8B)),
                    // right: BorderSide(color: Color(0xFF607D8B)),
                    bottom: BorderSide(width: 0.51, color: Color(0xFF607D8B)),
            ),
            boxShadow: [
                    BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                    )
            ],
        ),
    
            child: Column(
                  children: [
                    Row(
                      children: [
                        BackButton(),
                        Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.06,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: fetch('name'), // Use fetch() here
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text('loading'); // Or some loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  snapshot.data
                                      .toString(), // Use snapshot.data.toString()
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0.06,
                                  ),
                                );
                              }
                            },
                          ),
                          FutureBuilder(
                            future: fetch('price'), // Use fetch() here
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text('loading'); // Or some loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  '₹'+snapshot.data.toString(), // Use snapshot.data.toString()
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0.10,
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height-120,
              child: Chat(
                messages: _messages,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: _user,
              ),
            ),
          ),
          // Add other widgets below the chat container if needed
        ],
      ),
    ),
  ),
);
}
fetch(type) async {
    CollectionReference productlists =
        FirebaseFirestore.instance.collection('productlist');
    DocumentSnapshot productlist = await productlists
        .doc(widget.productid)
        .get(); // Use widget.productid here
    String ret = productlist[type];
    print(ret);
    return ret;
  }
}