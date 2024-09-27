// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cemana/variables/credential.dart';
import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  late DataLocal room;
  late DataLocal message;
  bool isInit = false;
  bool isLoading = false;
  Map<String, TextEditingController> controller = {};
  Map<String, bool> chatLoading = {};

  List<Map<String, dynamic>> inferences = [
    {
      "id": "qwen2-72b",
      "name": "Qwen2 72B",
      "url": "https://qwen2-72b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "llama3-1-405b",
      "name": "Llama 3.1 405B",
      "url": "https://llama3-1-405b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "llama3-1-70b",
      "name": "Llama 3.1 70B",
      "url": "https://llama3-1-70b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "llama3-1-8b",
      "name": "Llama 3.1 8B",
      "url": "https://llama3-1-8b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "nous-hermes-llama2",
      "name": "Nous: Hermes 13B",
      "url":
          "https://nous-hermes-llama2-13b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "openchat-3-5",
      "name": "OpenChat 3.5",
      "url": "https://openchat-3-5.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "wizardlm-2-7b",
      "name": "WizardLM-2 7B",
      "url": "https://wizardlm-2-7b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "llama3-8b",
      "name": "Llama3 8B",
      "url": "https://llama3-8b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "llama3-70b",
      "name": "Llama3 70b",
      "url": "https://llama3-70b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "wizardlm-2-8x22b",
      "name": "WizardLM-2 8x22B",
      "url": "https://wizardlm-2-8x22b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "mistral-7b",
      "name": "Mistral 7B",
      "url": "https://mistral-7b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "toppy-m-7b",
      "name": "Toppy M 7B",
      "url": "https://toppy-m-7b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "dolphin-mixtral-8x7b",
      "name": "Dolphin Mixtral 8x7b",
      "url": "https://dolphin-mixtral-8x7b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "mixtral-8x7b",
      "name": "Mixtral 8x7b",
      "url": "https://mixtral-8x7b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "llama2-13b",
      "name": "Llama2 13b",
      "url": "https://llama2-13b.lepton.run/api/v1/chat/completions",
      "temperature": 0.7,
      "type": "LLM",
    },
    {
      "id": "sdxl",
      "name": "Stable Diffusion XL",
      "url": "https://sdxl.lepton.run/run",
      "width": 1024,
      "height": 1024,
      "guidance_scale": 5,
      "high_noise_frac": 0.75,
      "seed": 151886915,
      "steps": 30,
      "use_refiner": false,
      "type": "Image",
    },
  ];

  late Map<String, dynamic> selectedInference;

  AppProvider() {
    initialize();
    selectedInference = inferences[5];
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

  Future<void> sendMessage(BuildContext context,
      {String? id, required Map<String, dynamic> inference}) async {
    try {
      String content = controller[id ?? ""]!.text;
      if (content.isEmpty) throw "Coba isi sesuatu hal yang menarik untukmu";
      DataItem r;
      if (id == null) {
        r = await room.insertOne({"name": content, "inference": inference});

        Navigator.pushNamed(context, "/?q=${r.id}");
      } else {
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
      room.updateOne(r.id, value: {});
      await getAnswer(r.id, inference: inference);

      refresh();
    } catch (e) {
      chatLoading[id ?? ""] = false;
      refresh();
      double width = MediaQuery.of(context).size.width;
      double w;
      if (width < 720) {
        w = width - 32;
      } else {
        w = width - 32;
        if (w > 500) {
          w = 500;
        }
      }
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        width: w,
        content: Text("$e"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Tutup',
          disabledTextColor: Colors.white,
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
    }
  }

  Future<void> getAnswer(String id,
      {required Map<String, dynamic> inference}) async {
    chatLoading[id] = true;
    refresh();
    final dio = Dio();
    DataQuery query = await message.find(
      filters: [DataFilter(key: DataKey("roomId"), value: id)],
      sorts: [DataSort(key: DataKey("#createdAt"), desc: false)],
    );
    List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(
        query.data.map((_) => _.get(DataKey("message"))).toList());
    if (inference['type'] == "LLM") {
      Response response;
      if (kIsWeb) {
        response = await dio.post(
          'https://api.lamun.my.id/api/forwarder',
          data: {
            "url": inference['url'],
            "body": {
              "model": inference['id'],
              "messages": messages,
              "temperature": inference['temperature'] ?? 0.7,
            },
            "headers": {"Authorization": "Bearer ${Credential.apiKey}"}
          },
        );
      } else {
        response = await dio.post(inference['url'],
            data: {
              "model": inference['id'],
              "messages": messages,
              "temperature": inference['temperature'] ?? 0.7,
            },
            options: Options(
                headers: {"Authorization": "Bearer ${Credential.apiKey}"}));
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        Map<String, dynamic> content = data['choices'][0]['message'];

        if (data['choices'][0]['finish_reason'] == "length") {
          getAnswer(id, inference: inference);
          await message.insertOne({
            "message": content,
            "roomId": id,
            "isFinished": false,
          });
        } else {
          await message.insertOne({
            "message": content,
            "roomId": id,
            "isFinished": true,
          });
        }
      } else {
        //
      }
    } else if (inference['type'] == "Image") {
      Map<String, dynamic> m = messages.last;
      http.Response response;

      if (kIsWeb) {
        response = await http.post(
          Uri.parse('https://api.lamun.my.id/api/forwarder/image'),
          body: jsonEncode({
            "url": inference['url'],
            "body": {
              "prompt": m['content'],
              "width": inference['width'],
              "height": inference['height'],
              "guidance_scale": inference['guidance_scale'],
              "high_noise_frac": inference['high_noise_frac'],
              "seed": inference['seed'],
              "steps": inference['steps'],
              "use_refiner": inference['use_refiner'],
            },
            "headers": {
              "Authorization": "Bearer ${Credential.apiKey}",
              'Content-Type': 'application/json',
            }
          }),
        );
      } else {
        response = await http.post(
          Uri.parse(inference['url']),
          headers: {
            "Authorization": "Bearer ${Credential.apiKey}",
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST',
          },
          body: jsonEncode(
            {
              "prompt": m['content'],
              "width": inference['width'],
              "height": inference['height'],
              "guidance_scale": inference['guidance_scale'],
              "high_noise_frac": inference['high_noise_frac'],
              "seed": inference['seed'],
              "steps": inference['steps'],
              "use_refiner": inference['use_refiner'],
            },
          ),
        );
      }
      if (response.statusCode == 200) {
        // Map<String, dynamic> data = response.body;
        // response.bodyBytes.toString();
        Map<String, dynamic> content = {
          "role": "assistant",
          "type": "Image",
        };
        DataItem d = await message.insertOne({
          "message": content,
          "roomId": id,
          "isFinished": true,
        });
        await d.saveFile(response.bodyBytes);
        print("file saved");
      } else {
        //
      }
    }
    chatLoading[id] = false;
    refresh();
  }
}
