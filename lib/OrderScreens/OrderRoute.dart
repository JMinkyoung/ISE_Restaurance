import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurance/OrderScreens/Order.dart';
import 'package:restaurance/OrderScreens/Menu.dart';
import 'package:restaurance/customAppBar.dart';

class OrderRoute extends StatefulWidget {
  OrderRoute({Key key, this.table, this.orderId}) : super(key: key);

  final int table;
  final String orderId;

  @override
  _OrderRouteState createState() => _OrderRouteState();
}

class _OrderRouteState extends State<OrderRoute> {
  int _index = 0;
  List<OrderRow> rows;
  List<Menu> menus;
  List<String> cates;

  Future _loadInfos() async {
    if (menus == null) {
      QuerySnapshot snapshots =
          await FirebaseFirestore.instance.collection("Menu").get();

      cates = new List<String>();
      this.menus = new List<Menu>();
      for (QueryDocumentSnapshot snapshot in snapshots.docs) {
        String cate = snapshot.get("MenuType").toString();
        if (!cates.contains(cate)) {
          cates.add(cate);
        }

        menus.add(Menu(
          snapshot.get("MenuType").toString(),
          snapshot.get("MenuName").toString(),
          int.parse(snapshot.get("MenuPrice").toString()),
          int.parse(snapshot.get("MenuTime").toString()),
        ));
      }
    }

    if (rows == null) {
      rows = new List<OrderRow>();
      if (widget.table > 0) {
        QuerySnapshot snapshots = await FirebaseFirestore.instance
            .collection("OrderRow")
            .where("orderId", isEqualTo: widget.orderId)
            .get();

        for (QueryDocumentSnapshot snapshot in snapshots.docs) {
          String name = snapshot.get("menuName");
          Menu menu;
          for (Menu m in menus) {
            if (m.name == name) menu = m;
          }
          if (menu != null) rows.add(OrderRow(menu, snapshot.get('count')));
        }
      }
    }
  }

  Widget _buildRow(OrderRow row) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(row.menu.name),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  tooltip: '수량 감소',
                  onPressed: () {
                    if (row.count > 1)
                      setState(() {
                        --row.count;
                      });
                  },
                ),
                Text(row.count.toString() + "개"),
                IconButton(
                  icon: Icon(Icons.add),
                  tooltip: '수량 증가',
                  onPressed: () {
                    setState(() {
                      ++row.count;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  tooltip: '메뉴 제거',
                  onPressed: () {
                    setState(() {
                      rows.remove(row);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCateButton(List<String> cates, String cate) {
    int index = cates.indexOf(cate);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _index = index;
          });
        },
        color: Color(0xFFFFD180),
        child: Text(cate),
      ),
    );
  }

  Widget _buildMenuSelector() {
    List<List<Menu>> menus = new List<List<Menu>>();
    for (String cate in this.cates) {
      menus.add(new List<Menu>());
      for (Menu menu in this.menus) {
        if (menu.category == cate) menus.last.add(menu);
      }
    }

    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Material(
          elevation: 5,
          child: Container(
            width: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFFFFD180),
                  Color(0xFFFFE0B2),
                  Color(0xFFFFD180),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('메뉴 목록',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cates.map((e) => _buildCateButton(cates, e)).toList(),
            ),
          ),
        ),
        IndexedStack(
          index: _index,
          children: menus
              .map((ele) => SizedBox(
                    height: 400,
                    width: 600,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 20.0),
                      children: ele.map((e) => _buildMenu(e)).toList(),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMenu(Menu menu) {
    return Card(
      child: ListTile(
        title: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.centerLeft,
              child: Text(menu.name),
            ),
            Align(
              alignment: FractionalOffset.centerRight,
              child: Text(menu.price.toString() + "원"),
            ),
          ],
        ),
        onTap: () {
          int index = -1;
          for (int i = 0; i < rows.length; ++i) {
            if (rows[i].menu.name == menu.name) {
              index = i;
              break;
            }
          }
          setState(() {
            if (index == -1)
              rows.add(OrderRow(menu, 1));
            else
              ++rows[index].count;
          });
        },
      ),
    );
  }

  void _pushPaymentRoute() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('주문 결제'),
            ),
            body: Center(
              child: RaisedButton(
                onPressed: () async {
                  String orderId = widget.orderId;
                  if (widget.table == 0) {
                    orderId = (await FirebaseFirestore.instance
                            .collection("Order")
                            .add({'tableNum': 0, 'start': DateTime.now()}))
                        .id;
                  }

                  FirebaseFirestore.instance
                      .collection("OrderRow")
                      .where("orderId", isEqualTo: widget.orderId)
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  });

                  int total = 0;
                  int wait = 0;
                  for (var row in rows) {
                    total += row.menu.price;
                    wait = row.menu.time > wait ? row.menu.time : wait;
                    FirebaseFirestore.instance.collection('OrderRow').add({
                      'orderId': widget.orderId,
                      'menuName': row.menu.name,
                      'count': row.count
                    });
                  }

                  FirebaseFirestore.instance
                      .collection("Order")
                      .doc(orderId)
                      .update({
                    'total': total,
                    'wait': wait,
                    'completed': true,
                    'end': DateTime.now(),
                    'useremail': FirebaseAuth.instance.currentUser.email
                  });

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('현금 결제'),
              ),
            ),
          );
        }, // ...to here.
      ),
    );
  }

  Widget _buildListButtonsRow() {
    if (widget.table > 0) {
      return Row(
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Color(0xFFFFD180),
            child: Text(
              "변경 취소",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          RaisedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("OrderRow")
                  .where("orderId", isEqualTo: widget.orderId)
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot ds in snapshot.docs) {
                  ds.reference.delete();
                }
              });

              FirebaseFirestore.instance
                  .collection("Order")
                  .doc(widget.orderId)
                  .delete();

              Navigator.of(context).pop();
            },
            color: Color(0xFFFFD180),
            child: Text("주문 제거", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 10,
          ),
          RaisedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("OrderRow")
                  .where("orderId", isEqualTo: widget.orderId)
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot ds in snapshot.docs) {
                  ds.reference.delete();
                }
              });

              int total = 0;
              int wait = 0;
              for (var row in rows) {
                total += row.menu.price;
                wait = row.menu.time > wait ? row.menu.time : wait;
                FirebaseFirestore.instance.collection('OrderRow').add({
                  'orderId': widget.orderId,
                  'menuName': row.menu.name,
                  'count': row.count
                });
              }

              FirebaseFirestore.instance
                  .collection("Order")
                  .doc(widget.orderId)
                  .update({'total': total, 'wait': wait});

              Navigator.of(context).pop();
            },
            color: Color(0xFFFFD180),
            child: Text("주문 저장", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 10,
          ),
          RaisedButton(
            onPressed: () {
              _pushPaymentRoute();
            },
            color: Color(0xFFFFD180),
            child: Text("주문 결제", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Color(0xFFFFD180),
            child: Text("주문 취소"),
          ),
          RaisedButton(
            onPressed: () {
              _pushPaymentRoute();
            },
            color: Color(0xFFFFD180),
            child: Text("주문 결제"),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String titleText = widget.table.toString() + "번 테이블 주문 수정";
    if (widget.table == 0) titleText = "테이블 주문";
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: customAppBar_Staff(context, "주문 목록"),
      body: FutureBuilder(
        future: _loadInfos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("에러 발생. 재실행해주세요.");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildMenuSelector(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                  child: Container(color: Colors.black, width: 4),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Material(
                      elevation: 5,
                      child: Container(
                        width: 500,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFFD180),
                              Color(0xFFFFE0B2),
                              Color(0xFFFFD180),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('주문상품 목록',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      width: 600,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 20.0),
                        children: rows.map((e) => _buildRow(e)).toList(),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: _buildListButtonsRow(), //Your widget here,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
