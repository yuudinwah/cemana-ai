import 'package:cemana/providers/provider.dart';
import 'package:cemana/utils/CemanaColors.dart';
import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
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
    Size size = MediaQuery.of(context).size!;
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
                  color: CemanaColors.backgroundColor,
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
                                      color: CemanaColors.primaryColor,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "Chat baru",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
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
                                              ? CemanaColors.hoverColor
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
                                              child: Text(
                                                data.get(DataKey("name")) ??
                                                    "-",
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
                            const Text("Cemana"),
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
                                      child: Text(
                                        _['name'] ?? "-",
                                        style: const TextStyle(fontSize: 14),
                                      ),
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
                                              color: CemanaColors.primaryColor,
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
                                                children: [
                                                  const Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  SizedBox(
                                                    width: 600,
                                                    child: Row(
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
                                                                  color: CemanaColors
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                ),
                                                              );
                                                            }
                                                            if (role ==
                                                                    "assistant" &&
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: CemanaColors
                                                                    .hoverColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                          child: Text(
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
                                      width: 700,
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
                                                hintText: "Tanya Apapun...",
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
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CemanaColors.hoverColor,
                                              ),
                                              child: const Icon(
                                                Icons.arrow_upward_rounded,
                                                weight: 900,
                                                color:
                                                    CemanaColors.primaryColor,
                                              ),
                                            ),
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
