// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cemana/providers/provider.dart';
import 'package:cemana/utils/file_util.dart';
import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ScreenDesktop extends StatefulWidget {
  const ScreenDesktop(this.id, {super.key});

  final String? id;
  @override
  State<ScreenDesktop> createState() => _ScreenDesktopState();
}

class _ScreenDesktopState extends State<ScreenDesktop> {
  bool minimize = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    AppProvider a = Provider.of<AppProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Material(
        color: Colors.white,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              AnimatedPositioned(
                left: minimize ? -300 : 0,
                duration: const Duration(
                  milliseconds: 250,
                ),
                child: Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: selected
                                              ? Colors.purple[200]
                                              : null,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.chat_bubble),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data.get(DataKey(
                                                              "name")) ??
                                                          "-",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: data.get(DataKey(
                                                                  "inference.type")) ==
                                                              "Image"
                                                          ? Colors.blue
                                                          : Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      data.get(DataKey(
                                                              "inference.type")) ??
                                                          "-",
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
              ),
              AnimatedPositioned(
                left: minimize ? 0 : 300,
                right: 0,
                bottom: 0,
                top: 0,
                duration: const Duration(milliseconds: 250),
                child: FutureBuilder<DataItem?>(
                  future: widget.id == null ? null : a.room.get(widget.id!),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData && widget.id != null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    DataItem? room = snapshot.data;
                    return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () {
                            minimize = !minimize;
                            setState(() {});
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        title: Row(
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                "src/logo-cemana.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Text("emana"),
                            const SizedBox(
                              width: 16,
                            ),
                            const Expanded(child: SizedBox()),
                            if (widget.id == null)
                              DropdownButton<Map<String, dynamic>>(
                                underline: const SizedBox(),
                                items: a.inferences.map((_) {
                                  return DropdownMenuItem<Map<String, dynamic>>(
                                    value: _,
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(minHeight: 48.0),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(_['name'] ?? "-"),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (_) {
                                  if (_ != null) {
                                    a.selectedInference = _;
                                    a.refresh();
                                  }
                                },
                                value: a.selectedInference,
                              ),
                            if (room != null)
                              Text("${room.get(DataKey("inference.name"))}"),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        // foregroundColor: Colors.transparent,
                        bottomOpacity: 0.0,
                        // toolbarOpacity: 0.0,
                      ),
                      body: SizedBox(
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
                                            key: DataKey("roomId"),
                                            value: widget.id),
                                      ], sorts: [
                                        DataSort(
                                            key: DataKey("#createdAt"),
                                            desc: false)
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
                                            String role = (data.get(DataKey(
                                                        "message.role")) ??
                                                    "")
                                                .toString();
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Container(
                                                    width: width,
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 600,
                                                      minWidth: 200,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Builder(
                                                              builder: (_) {
                                                                if (role ==
                                                                    "user") {
                                                                  return Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .blue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                    ),
                                                                  );
                                                                }
                                                                if (role ==
                                                                        "assistant" &&
                                                                    index > 0 &&
                                                                    datas[index -
                                                                                1]
                                                                            .get(DataKey("message.role")) ==
                                                                        "assistant") {
                                                                  return const SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                  );
                                                                }
                                                                return Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .purple,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                );
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Expanded(
                                                              child: Builder(
                                                                builder: (_) {
                                                                  if (data.get(
                                                                          DataKey(
                                                                              "message.type")) ==
                                                                      "Image") {
                                                                    return Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              250,
                                                                          width:
                                                                              250,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            child:
                                                                                Image.memory(
                                                                              base64Decode(data.get(DataKey("message.content")) ?? ""),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              250,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Expanded(
                                                                                child: SizedBox(),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  FileUtil().saveFileFromBytes(context, bytes: base64Decode(data.get(DataKey("message.content")) ?? ""), name: "${DateTime.now()}.png");
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 16,
                                                                                    vertical: 8,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.purple,
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  child: const Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.download,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 8,
                                                                                      ),
                                                                                      Text(
                                                                                        "Download",
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                                  return Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            width,
                                                                        child:
                                                                            SelectableText(
                                                                          (data.get(DataKey("message.content")) ?? "")
                                                                              .toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (role ==
                                                                              "assistant" &&
                                                                          data.get(DataKey("isFinished")) ==
                                                                              true)
                                                                        SizedBox(
                                                                          width:
                                                                              width,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  String m = "";
                                                                                  bool end = false;
                                                                                  int i = 0;
                                                                                  do {
                                                                                    try {
                                                                                      if (datas[index - i].get(DataKey("message.role")) == "user") {
                                                                                        throw "";
                                                                                      }
                                                                                      m = "${datas[index - i].get(DataKey("message.content"))} \n $m";
                                                                                      i++;
                                                                                    } catch (e) {
                                                                                      end = true;
                                                                                    }
                                                                                  } while (end == false);
                                                                                  await Clipboard.setData(ClipboardData(text: m));
                                                                                  double w;
                                                                                  if (width < 720) {
                                                                                    w = width - 32;
                                                                                  } else {
                                                                                    w = width - 32;
                                                                                    if (w > 500) {
                                                                                      w = 500;
                                                                                    }
                                                                                  }
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    width: w,
                                                                                    content: const Text("Disimpan di papan clip"),
                                                                                    backgroundColor: Colors.blue,
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
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 16,
                                                                                    vertical: 8,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.purple,
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  child: const Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.copy,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 8,
                                                                                      ),
                                                                                      Text(
                                                                                        "Salin",
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (index ==
                                                                datas.length -
                                                                    1 &&
                                                            a.chatLoading[widget
                                                                    .id] ==
                                                                true)
                                                          Container(
                                                            height: 45,
                                                            width: 45,
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 8,
                                                              horizontal: 16,
                                                            ),
                                                            child: Image.asset(
                                                                "src/loading.gif"),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 16,
                                ),
                                Builder(
                                  builder: (_) {
                                    if (a.controller[widget.id ?? ""] == null) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
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
                                      width: width,
                                      height: 80,
                                      constraints: const BoxConstraints(
                                        maxWidth: 720,
                                        minWidth: 260,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.purple[50],
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              onSubmitted: (_) {
                                                a.sendMessage(
                                                  context,
                                                  id: widget.id,
                                                  inference: room == null
                                                      ? a.selectedInference
                                                      : room.get(DataKey(
                                                              "inference")) ??
                                                          a.selectedInference,
                                                );
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Apa yang ada di pikiran mu?",
                                              ),
                                              controller:
                                                  a.controller[widget.id ?? ""],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              a.sendMessage(
                                                context,
                                                id: widget.id,
                                                inference: room == null
                                                    ? a.selectedInference
                                                    : room.get(DataKey(
                                                            "inference")) ??
                                                        a.selectedInference,
                                              );
                                            },
                                            child: const Icon(Icons.send),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
