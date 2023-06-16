// ignore_for_file: avoid_print, unused_element

import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';

class MainReport extends StatefulWidget {
  const MainReport({super.key});

  @override
  State<MainReport> createState() => _MainReportState();
}

class _MainReportState extends State<MainReport> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Report",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _bodyatas(),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _bodytengah()
                ],
              )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        },
        child: const Icon(
          Icons.home,
          color: Colors.white,
          size: 50,
        ),
      )),
    );
  }

  Widget _bodytengah() {
    return SizedBox(
      height: 800,
      child: FutureBuilder(
        // future: DbAllKodekeluarbarang.db.getAllkeluarbarang(),
        future: DbAllitems.db.getAllitems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black12,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // leading: ClipRRect(
                  //   borderRadius: BorderRadius.circular(40),
                  //   child: CachedNetworkImage(
                  //     imageUrl:
                  //         'https://parvabisnis.id/uploads/products/${snapshot.data[index].image_name}',
                  //     placeholder: (context, url) =>
                  //         const CircularProgressIndicator(),
                  //     errorWidget: (context, url, error) =>
                  //         const Icon(Icons.error),
                  //     height: 124,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // title: Text(
                  //     "Name: ${snapshot.data[index].user_id} ${snapshot.data[index].name}"),
                  subtitle: Text('EMAIL: ${snapshot.data[index].name}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _bodyatas() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 0.09,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                      var apiProvider = ApiServices();
                      await apiProvider.getAllItems();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                        var apiProvider = ApiServices();
                        await apiProvider.getAllItems();
                      },
                      icon: Image.asset(
                        "images/sales.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 1",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/login.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 2",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/seo-report.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 3",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            // pertanyaan 4
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/sales.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 4",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/login.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 5",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/seo-report.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 6",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            //pertanyaan 7
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/sales.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 7",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/login.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 8",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: OutlinedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => PosSalesScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => PosSalesScreen()));
                      },
                      icon: Image.asset(
                        "images/seo-report.png",
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                const Text(
                  "Question 9",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                ),
              ],
            ),
          ],
        ));
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DbAllitems.db.deleteAllitems();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('Allitems deleted');
  }
}
