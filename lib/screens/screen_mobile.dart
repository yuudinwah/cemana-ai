// ignore_for_file: use_build_context_synchronously

import 'package:cemana/providers/provider.dart';
import 'package:cemana/utils/color_util.dart';
import 'package:cemana/utils/file_util.dart';
import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ScreenMobile extends StatefulWidget {
  const ScreenMobile(this.id, {super.key});

  final String? id;
  @override
  State<ScreenMobile> createState() => _ScreenMobileState();
}

class _ScreenMobileState extends State<ScreenMobile> {
  ScrollController controller = ScrollController();

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
        child: FutureBuilder<DataItem?>(
          future: widget.id == null ? null : a.room.get(widget.id!),
          builder: (_, snapshot) {
            if (widget.id != null && !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            DataItem? room = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: widget.id == null ? false : true,
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    if (widget.id == null)
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          "src/logo-cemana.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        "${room?.get(DataKey("name")) ?? "Cemana"}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
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
                      Text("${room.get(DataKey("inference.name")) ?? ""}"),
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
                height: height,
                width: width,
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: height,
                        width: width,
                        child: Builder(
                          builder: (_) {
                            if (widget.id == null) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 32,
                                        horizontal: 32,
                                      ),
                                      width: 600,
                                      child: const Text(
                                        "Halo,\nApa yang bisa saya bantu kali ini?",
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: CemanaColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (_) {
                                        if (!a.isInit) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return FutureBuilder<DataQuery>(
                                          future: a.room.find(
                                            sorts: [
                                              DataSort(
                                                key: DataKey("#createdAt",
                                                    onKeyCatch: "#createdAt"),
                                                desc: true,
                                              )
                                            ],
                                          ),
                                          builder: (_, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const SizedBox();
                                            }
                                            DataQuery query = snapshot.data!;
                                            List<DataItem> datas = query.data;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 32,
                                                ),
                                                if (datas.isNotEmpty)
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Chat terakhir",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                Column(
                                                  children: List.generate(
                                                    datas.length,
                                                    (index) {
                                                      DataItem data =
                                                          datas[index];
                                                      bool selected =
                                                          widget.id == data.id;
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/?q=${data.id}");
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                          // height: 60,
                                                          width: width,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: selected
                                                                ? Colors
                                                                    .purple[200]
                                                                : null,
                                                          ),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .chat_bubble),
                                                              const SizedBox(
                                                                width: 16,
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        data.get(DataKey("name")) ??
                                                                            "-",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              4),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: data.get(DataKey("inference.type")) ==
                                                                                "Image"
                                                                            ? Colors.blue
                                                                            : Colors.green,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        data.get(DataKey("inference.type")) ??
                                                                            "-",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              10,
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
                                  ],
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
                                  controller: controller,
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
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 16,
                                          ),
                                          width: width,
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
                                                      decoration: BoxDecoration(
                                                        color: CemanaColors
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                    );
                                                  }
                                                  if (role == "assistant" &&
                                                      index > 0 &&
                                                      datas[index - 1].get(DataKey(
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
                                                      color: CemanaColors
                                                          .hoverColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    alignment: Alignment.center,
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Builder(
                                                  builder: (context) {
                                                    if (data.get(DataKey(
                                                            "message.type")) ==
                                                        "Image") {
                                                      if (data.files.isEmpty) {
                                                        return const SizedBox();
                                                      }
                                                      if (data.files.isEmpty) {
                                                        return const SizedBox();
                                                      }
                                                      return FutureBuilder(
                                                        future: data.files.first
                                                            .getBytes(),
                                                        builder: (_, snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 250,
                                                                width: 250,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  child: Image.memory(
                                                                      snapshot
                                                                          .data!),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                                width: 250,
                                                                child: Row(
                                                                  children: [
                                                                    const Expanded(
                                                                      child:
                                                                          SizedBox(),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        FileUtil()
                                                                            .saveFileFromBytes(
                                                                          context,
                                                                          bytes:
                                                                              snapshot.data!,
                                                                          name:
                                                                              "${DateTime.now()}.png",
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              8,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.purple,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            const Row(
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
                                                        },
                                                      );
                                                    }
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        SizedBox(
                                                          width: width,
                                                          child: SelectableText(
                                                            (data.get(DataKey(
                                                                        "message.content")) ??
                                                                    "")
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        if (role ==
                                                                "assistant" &&
                                                            data.get(DataKey(
                                                                    "isFinished")) ==
                                                                true)
                                                          SizedBox(
                                                            width: width,
                                                            height: 50,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    String m =
                                                                        "";
                                                                    bool end =
                                                                        false;
                                                                    int i = 0;
                                                                    do {
                                                                      try {
                                                                        if (datas[index - i].get(DataKey("message.role")) ==
                                                                            "user") {
                                                                          throw "";
                                                                        }
                                                                        m = "${datas[index - i].get(DataKey("message.content"))} \n $m";
                                                                        i++;
                                                                      } catch (e) {
                                                                        end =
                                                                            true;
                                                                      }
                                                                    } while (end ==
                                                                        false);
                                                                    await Clipboard.setData(
                                                                        ClipboardData(
                                                                            text:
                                                                                m));
                                                                    double w;
                                                                    if (width <
                                                                        720) {
                                                                      w = width -
                                                                          32;
                                                                    } else {
                                                                      w = width -
                                                                          32;
                                                                      if (w >
                                                                          500) {
                                                                        w = 500;
                                                                      }
                                                                    }
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      width: w,
                                                                      content:
                                                                          const Text(
                                                                              "Disimpan di papan clip"),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue,
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      action:
                                                                          SnackBarAction(
                                                                        label:
                                                                            'Tutup',
                                                                        disabledTextColor:
                                                                            Colors.white,
                                                                        textColor:
                                                                            Colors.yellow,
                                                                        onPressed:
                                                                            () {
                                                                          ScaffoldMessenger.of(context)
                                                                              .hideCurrentSnackBar();
                                                                        },
                                                                      ),
                                                                    ));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .purple,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child:
                                                                        const Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .copy,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Text(
                                                                          "Salin",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
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
                                        ),
                                        if (index == datas.length - 1 &&
                                            a.chatLoading[widget.id] == true)
                                          Container(
                                            height: 45,
                                            width: 45,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                            child:
                                                Image.asset("src/loading.gif"),
                                          ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Builder(
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
                            height: 80,
                            decoration: BoxDecoration(
                              color: CemanaColors.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    onSubmitted: (_) {
                                      // FocusScope.of(context)
                                      //     .requestFocus(FocusNode());
                                      a
                                          .sendMessage(
                                        context,
                                        id: widget.id,
                                        inference: room == null
                                            ? a.selectedInference
                                            : room.get(DataKey("inference")) ??
                                                a.selectedInference,
                                      )
                                          .then((_) {
                                        controller.animateTo(
                                          controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          curve: Curves.fastOutSlowIn,
                                        );
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Tanya apapun...",
                                    ),
                                    onTap: () {},
                                    controller: a.controller[widget.id ?? ""],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // FocusScope.of(context)
                                    //     .requestFocus(FocusNode());
                                    a
                                        .sendMessage(
                                      context,
                                      id: widget.id,
                                      inference: room == null
                                          ? a.selectedInference
                                          : room.get(DataKey("inference")) ??
                                              a.selectedInference,
                                    )
                                        .then((_) {
                                      try {
                                        controller.animateTo(
                                          controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          curve: Curves.fastOutSlowIn,
                                        );
                                      } catch (e) {
                                        //
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CemanaColors.hoverColor,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_upward_rounded,
                                      weight: 900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
