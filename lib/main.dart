import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

String apiKey = "Your-secret-api-key";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      builder: (_, __) {
        return MaterialApp(
          title: 'Cemana',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(null),
          onGenerateRoute: (_) {
            String? q;
            try {
              q = _.name?.split("q=")[1];
            } catch (e) {
              //
            }
            return PageRouteBuilder(
              settings: _,
              pageBuilder: (context, animation1, animation2) => MyHomePage(q),
              transitionDuration: const Duration(
                seconds: 0,
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.id, {super.key});

  final String? id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size!;
    double width = size.width;
    double height = size.height;
    AppProvider a = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Cemana"),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: [
            Container(
              color: Colors.purple[50],
              width: 300,
              height: height,
              child: Builder(
                builder: (_) {
                  if (!a.isInit) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return FutureBuilder<DataQuery>(
                    future: a.room.find(),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      DataQuery query = snapshot.data!;
                      List<DataItem> datas = query.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                // height: 45,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.purple[100]!,
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Chat baru"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (datas.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                "Chat terakhir",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: datas.length,
                              itemBuilder: (_, index) {
                                DataItem data = datas[index];
                                bool selected = widget.id == data.id;
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/?q=${data.id}");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    // height: 60,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          selected ? Colors.purple[200] : null,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.chat_bubble),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data.get(DataKey("name")) ?? "-",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    // Text(widget.id ?? ""),
                    Expanded(
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: Builder(
                          builder: (_) {
                            if (widget.id == null) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32,
                                    horizontal: 32,
                                  ),
                                  width: 600,
                                  child: const Text(
                                    "Halo,\nApa yang bisa saya bantu kali ini?",
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return FutureBuilder<DataQuery>(
                              future: a.message.find(filters: [
                                DataFilter(
                                    key: DataKey("roomId"), value: widget.id),
                              ], sorts: [
                                DataSort(
                                    key: DataKey("#createdAt"), desc: false)
                              ]),
                              builder: (_, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                DataQuery query = snapshot.data!;
                                List<DataItem> datas = query.data;

                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32,
                                  ),
                                  itemCount: datas.length,
                                  itemBuilder: (_, index) {
                                    DataItem data = datas[index];
                                    String role =
                                        (data.get(DataKey("message.role")) ??
                                                "")
                                            .toString();
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          SizedBox(
                                            width: 600,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Builder(
                                                  builder: (_) {
                                                    if (role == "user") {
                                                      return Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                      );
                                                    }
                                                    if (role == "assistant" &&
                                                        index > 0 &&
                                                        datas[index - 1].get(
                                                                DataKey(
                                                                    "message.role")) ==
                                                            "assistant") {
                                                      return const SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                      );
                                                    }
                                                    return Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.purple,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    (data.get(DataKey(
                                                                "message.content")) ??
                                                            "")
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Builder(
                          builder: (_) {
                            if (a.controller[widget.id ?? ""] == null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                a.controller[widget.id ?? ""] =
                                    TextEditingController();
                                a.refresh();
                              });
                              return const SizedBox();
                            }
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 8,
                              ),
                              width: 720,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onSubmitted: (_) {
                                        a.sendMessage(context, id: widget.id);
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      controller: a.controller[widget.id ?? ""],
                                    ),
                                  ),
                                  const SizedBox(
                                    child: Icon(Icons.send),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        'https://mistral-7b.lepton.run/api/v1/chat/completions',
        data: {
          "model": "openchat-3-5",
          "messages": messages,
          "temperature": 0.7
        },
        options: Options(headers: {"Authorization": "Bearer $apiKey"}));

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
