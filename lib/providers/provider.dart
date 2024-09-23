import 'package:cemana/variables/credential.dart';
import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  late DataLocal room;
  late DataLocal message;
  bool isInit = false;
  bool isLoading = false;
  Map<String, TextEditingController> controller = {};
  Map<String, bool> chatLoading = {};

  AppProvider() {
    initialize();
  }

  void initialize() async {
    if (isInit) throw "already init";
    if (isLoading) throw "Loading";
    isLoading = true;
    refresh();
    room = await DataLocal.create("rooms", onRefresh: refresh);
    message = await DataLocal.create("messages", onRefresh: refresh);
    isLoading = false;
    isInit = true;
    refresh();
  }

  void refresh() {
    notifyListeners();
  }

  void sendMessage(BuildContext context, {String? id}) async {
    String content = controller[id ?? ""]!.text;
    DataItem r;
    if (id == null) {
      r = await room.insertOne({"name": content});
      Navigator.pushNamed(context, "/?q=${r.id}");
    } else {
      print(id);
      r = (await room.get(id))!;
    }
    controller[id ?? ""]!.clear();
    await message.insertOne({
      "message": {
        "role": "user",
        "content": content,
      },
      "roomId": r.id,
    });
    refresh();

    await getAnswer(r.id);

    refresh();
  }

  Future<void> getAnswer(String id) async {
    final dio = Dio();
    print("object");
    DataQuery query = await message.find(
      filters: [DataFilter(key: DataKey("roomId"), value: id)],
      sorts: [DataSort(key: DataKey("#createdAt"), desc: false)],
    );
    print("object");
    List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(
        query.data.map((_) => _.get(DataKey("message"))).toList());
    print(messages);
    Response response = await dio.post(
      'https://api.lamun.my.id/api/forwarder',
      data: {
        "url": "https://mistral-7b.lepton.run/api/v1/chat/completions",
        "body": {
          "model": "openchat-3-5",
          "messages": messages,
          "temperature": 0.7
        },
        "headers": {"Authorization": "Bearer ${Credential.apiKey}"}
      },
      // options: Options(headers: {"Authorization": "Bearer $apiKey"})
    );
    // Response response = await dio.post(
    //     'https://mistral-7b.lepton.run/api/v1/chat/completions',
    //     data: {
    //       "model": "openchat-3-5",
    //       "messages": messages,
    //       "temperature": 0.7
    //     },
    //     options: Options(headers: {"Authorization": "Bearer $apiKey"}));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      Map<String, dynamic> content = data['choices'][0]['message'];
      print(content);
      if (data['choices'][0]['finish_reason'] == "length") {
        print("belum selesai");
        getAnswer(id);
        await message.insertOne({
          "message": content,
          "roomId": id,
          "isFinished": false,
        });
      } else {
        print("sudah selesai");
        await message.insertOne({
          "message": content,
          "roomId": id,
          "isFinished": true,
        });
      }
    } else {
      print(response.data.toString());
    }
  }
}
