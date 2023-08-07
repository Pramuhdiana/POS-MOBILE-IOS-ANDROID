// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, avoid_print, deprecated_member_use, must_be_immutable, unused_element

import 'dart:typed_data';

import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' show get;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryModelNew extends StatelessWidget {
  //Read an image data from website/webspace
  String pdfFile = '';
  var pdf = pw.Document();

  List<Uint8List> imagesUint8list = [];

  final dynamic order;
  final dynamic order2;
  HistoryModelNew({Key? key, required this.order, this.order2})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 18),
            width: double.infinity,
            child: Row(
              children: [
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        // 'Kode ID       : ${order['name']}',
                        'Kode ID       : ${order.invoices_number}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  DateFormat('EEEE, dd MMMM yyyy HH:mm')
                      .format(DateTime.parse(order.created_at)),
                ),
              ),
            ],
          ),
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade500.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ('Customer          : ') + (order.customer),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ('Total item     : ') +
                            (order.total_quantity.toString()),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Total price   : ${CurrencyFormat.convertToIdr(order.nett, 0)}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () async {
                              // _launchURLInApp();
                              _launchURLInBrowser();
                            },
                            icon: const Icon(
                              Icons.link_sharp,
                              color: Colors.red,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return const LoadingDialogWidget(
                                      message: "",
                                    );
                                  });
                              _createPdf();
                            },
                            icon: const Icon(
                              Icons.print,
                              color: Colors.black,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return const LoadingDialogWidget(
                                      message: "",
                                    );
                                  });
                              _sharePdf();
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.greenAccent,
                              size: 30,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURLInBrowser() async {
    var url =
        // 'http://54.179.58.215:8080/transcation/laporan/${order.invoices_number}';
        'http://54.179.58.215:8080/transcation/laporan/${order.invoices_number}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

//link print invoice di web
  _launchURLInApp() async {
    var url =
        'http://54.179.58.215:8080/transcation/laporan/${order.invoices_number}';
    // 'https://medium.com/@malkhansingh95699';
    // 'http://54.179.58.215:8080/transcation/history';
    // 'http://54.179.58.215:8080/transcation/laporan/INV-000156';

    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

//convert image nettwork to uint8list
  getImageBytes(String assetImage) async {
    Response response = await get(
      Uri.parse(assetImage),
    );
    final ByteData bytes2 = await rootBundle.load('images/ilauncher.png');
    final Uint8List byteList = bytes2.buffer.asUint8List();
    if (response.statusCode != 200) {
      imagesUint8list.add(byteList);
      print(imagesUint8list.length);
    } else {
      imagesUint8list.add(response.bodyBytes);
      print(imagesUint8list.length);
    }
  }

  void _sharePdf() async {
    PdfDocument document = PdfDocument();
    final doc = pw.Document();
    final ByteData bytes = await rootBundle.load('images/welcomeIcon.png');

    final Uint8List byteList = bytes.buffer.asUint8List();
    final ByteData bytes2 = await rootBundle.load('images/ilauncher.png');
    final Uint8List byteList2 = bytes2.buffer.asUint8List();

//new multi
    List<String> assetImages = [
      for (var i = 0; i < order.total_quantity; i++)
        'https://parvabisnis.id/uploads/products/' + order2[i].image_name
    ];

    // ignore: curly_braces_in_flow_control_structures
    for (String image in assetImages) await getImageBytes(image);
    List<pw.Widget> pdfImages = imagesUint8list.map((image) {
      try {
        return pw.Image(
          pw.MemoryImage(
            image,
          ),
          height: 25,
          width: 25,
          fit: pw.BoxFit.fitHeight,
        );
      } catch (c) {
        return pw.Image(
          pw.MemoryImage(
            byteList2,
          ),
          height: 25,
          width: 25,
          fit: pw.BoxFit.fitHeight,
        );
      }
    }).toList();
    print(pdfImages);

    doc.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            if (order.total_quantity <= 10) {
              return [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      //header
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Image(pw.MemoryImage(byteList),
                              fit: pw.BoxFit.fitHeight, height: 50, width: 150),
                          pw.Header(text: order.jenisform, level: 1),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'No Surat        : ' +
                                          order.invoices_number,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Toko',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.customer,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'BC                  : ' + order.user,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Alamat',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.alamat,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                    'Hari/Tanggal  : ' +
                                        DateFormat('EEEE, dd MMMM yyyy H:mm')
                                            .format(DateTime.parse(
                                                order.created_at)),
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Note',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(height: 20),

                      //head table
                      pw.Table(children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 3),
                                  child: pw.Text("No", //nomor
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 15),
                                  child: pw.Text("Kode Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: -5),
                                  child: pw.Text("Keterangan Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 60, right: 3),
                                  child: pw.Text("Jumlah",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 0, right: 25),
                                  child: pw.Text("Harga",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 0),
                                  child: pw.Text("Gambar",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ])
                        ]),
                      ]),

                      //body isi
                      pw.Table(children: [
                        for (var i = 0; i < order.total_quantity; i++)
                          pw.TableRow(children: [
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18, width: 20),
                                  pw.Padding(
                                    padding:
                                        const pw.EdgeInsets.only(left: -15),
                                    child: pw.Text((i + 1).toString(), //nomor
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: -5),
                                    child: pw.Text(order2[i].name.toString(),
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(
                                    height: 19,
                                  ),
                                  pw.SizedBox(
                                    height: 6,
                                    width: 80,
                                    child: pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(left: -45),
                                      child: pw.Text(
                                          order2[i].keterangan_barang,
                                          // order2.docs[i - 1]['description'],
                                          style:
                                              const pw.TextStyle(fontSize: 6)),
                                    ),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 0),
                                    child: pw.Text('1',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        right: -5, left: 20),
                                    child: pw.Text(
                                        '\$ ${order2[i].price.toString()}',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pdfImages[i],
                                  // pw.Image(pw.MemoryImage(byteList2),
                                  //     fit: pw.BoxFit.fitHeight,
                                  //     height: 25,
                                  //     width: 25),
                                  pw.Divider(thickness: 1),
                                ])
                          ])
                      ]),

                      //bottom pdf
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text(
                                      'Terbilang                     :',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(width: 95, child: pw.Text('Total')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text('\$ ' + order.total.toString(),
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text('Kondisi Pembayaran   : ',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(width: 95, child: pw.Text('Diskon')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text(
                                    order.basic_discount.toString() + ' %',
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text('Jangka Waktu             : ',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(width: 95, child: pw.Text('Rate')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text(order.rate.toString(),
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text('Jatuh Tempo               : ',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(
                                  width: 95, child: pw.Text('Total Transaksi')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text(
                                    CurrencyFormat.convertToIdr(order.nett, 0)
                                        .toString(),
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 20, top: 20.0),
                                  child: pw.SizedBox(
                                      child: pw.Text('Hormat Kami,',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 30, top: 20.0),
                                  child: pw.SizedBox(
                                      child: pw.Text('Hormat Kami,',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                            ],
                          ),
                          pw.SizedBox(height: 18),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: pw.SizedBox(
                                      child: pw.Text(
                                          'Tanda Tangan & Nama Jelas',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 20.0),
                                  child: pw.SizedBox(
                                      child: pw.Text(
                                          '${sharedPreferences!.getString("name")!}',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                            ],
                          ),
                        ],
                      )
                    ])
              ];
            }
            //total cart lebih dari 10
            else {
              return [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      //header
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Image(pw.MemoryImage(byteList),
                              fit: pw.BoxFit.fitHeight, height: 50, width: 150),
                          pw.Header(text: order.jenisform, level: 1),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'No Surat        : ' +
                                          order.invoices_number,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Toko',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.customer,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'BC                  : ' + order.user,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Alamat',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.alamat,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                    'Hari/Tanggal  : ' +
                                        DateFormat('EEEE, dd MMMM yyyy H:mm')
                                            .format(DateTime.parse(
                                                order.created_at)),
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Note',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      //head table
                      pw.Table(children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 3),
                                  child: pw.Text("No", //nomor
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 15),
                                  child: pw.Text("Kode Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: -5),
                                  child: pw.Text("Keterangan Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 60, right: 3),
                                  child: pw.Text("Jumlah",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 0, right: 25),
                                  child: pw.Text("Harga",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 0),
                                  child: pw.Text("Gambar",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ])
                        ]),
                      ]),

                      // body isi page 1
                      //body isi
                      pw.Table(children: [
                        for (var i = 0; i < 10; i++)
                          pw.TableRow(children: [
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18, width: 20),
                                  pw.Padding(
                                    padding:
                                        const pw.EdgeInsets.only(left: -15),
                                    child: pw.Text((i + 1).toString(), //nomor
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: -5),
                                    child: pw.Text(order2[i].name.toString(),
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(
                                    height: 19,
                                  ),
                                  pw.SizedBox(
                                    height: 6,
                                    width: 80,
                                    child: pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(left: -45),
                                      child: pw.Text(
                                          order2[i].keterangan_barang,
                                          // order2.docs[i - 1]['description'],
                                          style:
                                              const pw.TextStyle(fontSize: 6)),
                                    ),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 0),
                                    child: pw.Text('1',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        right: -5, left: 20),
                                    child: pw.Text(
                                        '\$ ${order2[i].price.toString()}',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pdfImages[i],
                                  // pw.Image(pw.MemoryImage(byteList2),
                                  //     fit: pw.BoxFit.fitHeight,
                                  //     height: 25,
                                  //     width: 25),
                                  pw.Divider(thickness: 1),
                                ])
                          ])
                      ]),
                    ]),
                // body isi page 2
                //body isi
                pw.Table(children: [
                  for (var i = 10; i < order.total_quantity; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18, width: 20),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: -15),
                              child: pw.Text((i + 1).toString(), //nomor
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: -5),
                              child: pw.Text(order2[i].name.toString(),
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(
                              height: 19,
                            ),
                            pw.SizedBox(
                              height: 6,
                              width: 80,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: -45),
                                child: pw.Text(order2[i].keterangan_barang,
                                    // order2.docs[i - 1]['description'],
                                    style: const pw.TextStyle(fontSize: 6)),
                              ),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 0),
                              child: pw.Text('1',
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18),
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.only(right: -5, left: 20),
                              child: pw.Text('\$ ${order2[i].price.toString()}',
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pdfImages[i],
                            // pw.Image(pw.MemoryImage(byteList2),
                            //     fit: pw.BoxFit.fitHeight,
                            //     height: 25,
                            //     width: 25),
                            pw.Divider(thickness: 1),
                          ])
                    ])
                ]),
                //bottom pdf
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Terbilang                     :',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(width: 95, child: pw.Text('Total')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text('\$ ' + order.total.toString(),
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Kondisi Pembayaran   : ',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(width: 95, child: pw.Text('Diskon')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(order.basic_discount.toString() + ' %',
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Jangka Waktu             : ',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(width: 95, child: pw.Text('Rate')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(order.rate.toString(),
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Jatuh Tempo               : ',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(
                            width: 95, child: pw.Text('Total Transaksi')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(
                              CurrencyFormat.convertToIdr(order.nett, 0)
                                  .toString(),
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 20, top: 20.0),
                            child: pw.SizedBox(
                                child: pw.Text('Hormat Kami,',
                                    style: const pw.TextStyle(fontSize: 10)))),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 30, top: 20.0),
                            child: pw.SizedBox(
                                child: pw.Text('Hormat Kami,',
                                    style: const pw.TextStyle(fontSize: 10)))),
                      ],
                    ),
                    pw.SizedBox(height: 50),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              top: 20.0,
                            ),
                            child: pw.SizedBox(
                                child: pw.Text('Tanda Tangan & Nama Jelas',
                                    style: const pw.TextStyle(fontSize: 10)))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20.0),
                            child: pw.SizedBox(
                                child: pw.Text(
                                    '${sharedPreferences!.getString("name")!}',
                                    style: const pw.TextStyle(fontSize: 10)))),
                      ],
                    ),
                  ],
                )
              ];
            }
          }),
    ); // Page

    /// share the document to other applications:
    await Printing.sharePdf(
        bytes: await doc.save(), filename: '${order.invoices_number}.pdf');
  }

  void _createPdf() async {
    PdfDocument document = PdfDocument();
    final doc = pw.Document();
    final ByteData bytes = await rootBundle.load('images/welcomeIcon.png');

    final Uint8List byteList = bytes.buffer.asUint8List();
    final ByteData bytes2 = await rootBundle.load('images/ilauncher.png');
    final Uint8List byteList2 = bytes2.buffer.asUint8List();

//new multi
    List<String> assetImages = [
      for (var i = 0; i < order.total_quantity; i++)
        'https://parvabisnis.id/uploads/products/' + order2[i].image_name
      // 'https://parvabisnis.id/uploads/products/RG007221160.jpg'
      // 'https://parvabisnis.id/uploads/products/SRL10192120.jpg'
    ];
    // ignore: curly_braces_in_flow_control_structures
    for (String image in assetImages) await getImageBytes(image);
    List<pw.Widget> pdfImages = imagesUint8list.map((image) {
      try {
        return pw.Image(
          pw.MemoryImage(
            image,
          ),
          height: 25,
          width: 25,
          fit: pw.BoxFit.fitHeight,
        );
      } catch (c) {
        return pw.Image(
          pw.MemoryImage(
            byteList2,
          ),
          height: 25,
          width: 25,
          fit: pw.BoxFit.fitHeight,
        );
      }
    }).toList();

    doc.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            if (order.total_quantity <= 10) {
              return [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      //header
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Image(pw.MemoryImage(byteList),
                              fit: pw.BoxFit.fitHeight, height: 50, width: 150),
                          pw.Header(text: order.jenisform, level: 1),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'No Surat        : ' +
                                          order.invoices_number,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Toko',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.customer,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'BC                  : ' + order.user,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Alamat',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.alamat,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                    'Hari/Tanggal  : ' +
                                        DateFormat('EEEE, dd MMMM yyyy H:mm')
                                            .format(DateTime.parse(
                                                order.created_at)),
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Note',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(height: 20),

                      //head table
                      pw.Table(children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 3),
                                  child: pw.Text("No", //nomor
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 15),
                                  child: pw.Text("Kode Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: -5),
                                  child: pw.Text("Keterangan Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 60, right: 3),
                                  child: pw.Text("Jumlah",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 0, right: 25),
                                  child: pw.Text("Harga",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 0),
                                  child: pw.Text("Gambar",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ])
                        ]),
                      ]),

                      //body isi
                      pw.Table(children: [
                        for (var i = 0; i < order.total_quantity; i++)
                          pw.TableRow(children: [
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18, width: 20),
                                  pw.Padding(
                                    padding:
                                        const pw.EdgeInsets.only(left: -15),
                                    child: pw.Text((i + 1).toString(), //nomor
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: -5),
                                    child: pw.Text(order2[i].name.toString(),
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(
                                    height: 19,
                                  ),
                                  pw.SizedBox(
                                    height: 6,
                                    width: 80,
                                    child: pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(left: -45),
                                      child: pw.Text(
                                          order2[i].keterangan_barang,
                                          // order2.docs[i - 1]['description'],
                                          style:
                                              const pw.TextStyle(fontSize: 6)),
                                    ),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 0),
                                    child: pw.Text('1',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        right: -5, left: 20),
                                    child: pw.Text(
                                        '\$ ${order2[i].price.toString()}',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pdfImages[i],
                                  // pw.Image(pw.MemoryImage(byteList2),
                                  //     fit: pw.BoxFit.fitHeight,
                                  //     height: 25,
                                  //     width: 25),
                                  pw.Divider(thickness: 1),
                                ])
                          ])
                      ]),

                      //bottom pdf
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text(
                                      'Terbilang                     :',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(width: 95, child: pw.Text('Total')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text('\$ ' + order.total.toString(),
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text('Kondisi Pembayaran   : ',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(width: 95, child: pw.Text('Diskon')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text(
                                    order.basic_discount.toString() + ' %',
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text('Jangka Waktu             : ',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(width: 95, child: pw.Text('Rate')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text(order.rate.toString(),
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.SizedBox(
                                  width: 250,
                                  child: pw.Text('Jatuh Tempo               : ',
                                      style: const pw.TextStyle(fontSize: 10))),
                              pw.SizedBox(
                                  width: 95, child: pw.Text('Total Transaksi')),
                              pw.Text(':'),
                              pw.SizedBox(
                                width: 100,
                                child: pw.Text(
                                    CurrencyFormat.convertToIdr(order.nett, 0)
                                        .toString(),
                                    style: const pw.TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 20, top: 20.0),
                                  child: pw.SizedBox(
                                      child: pw.Text('Hormat Kami,',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 30, top: 20.0),
                                  child: pw.SizedBox(
                                      child: pw.Text('Hormat Kami,',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                            ],
                          ),
                          pw.SizedBox(height: 18),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: pw.SizedBox(
                                      child: pw.Text(
                                          'Tanda Tangan & Nama Jelas',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 20.0),
                                  child: pw.SizedBox(
                                      child: pw.Text(
                                          '${sharedPreferences!.getString("name")!}',
                                          style: const pw.TextStyle(
                                              fontSize: 10)))),
                            ],
                          ),
                        ],
                      )
                    ])
              ];
            }
            //total cart lebih dari 10
            else {
              return [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      //header
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Image(pw.MemoryImage(byteList),
                              fit: pw.BoxFit.fitHeight, height: 50, width: 150),
                          pw.Header(text: order.jenisform, level: 1),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'No Surat        : ' +
                                          order.invoices_number,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Toko',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.customer,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                      'BC                  : ' + order.user,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Alamat',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text(order.alamat,
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  width: 300,
                                  child: pw.Text(
                                    'Hari/Tanggal  : ' +
                                        DateFormat('EEEE, dd MMMM yyyy H:mm')
                                            .format(DateTime.parse(
                                                order.created_at)),
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 35,
                                  child: pw.Text('Note',
                                      style: const pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Text(':'),
                                pw.SizedBox(
                                  width: 100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      //head table
                      pw.Table(children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 3),
                                  child: pw.Text("No", //nomor
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 15),
                                  child: pw.Text("Kode Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: -5),
                                  child: pw.Text("Keterangan Barang",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 60, right: 3),
                                  child: pw.Text("Jumlah",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 0, right: 25),
                                  child: pw.Text("Harga",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 0),
                                  child: pw.Text("Gambar",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ])
                        ]),
                      ]),

                      // body isi page 1
                      //body isi
                      pw.Table(children: [
                        for (var i = 0; i < 10; i++)
                          pw.TableRow(children: [
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18, width: 20),
                                  pw.Padding(
                                    padding:
                                        const pw.EdgeInsets.only(left: -15),
                                    child: pw.Text((i + 1).toString(), //nomor
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: -5),
                                    child: pw.Text(order2[i].name.toString(),
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(
                                    height: 19,
                                  ),
                                  pw.SizedBox(
                                    height: 6,
                                    width: 80,
                                    child: pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(left: -45),
                                      child: pw.Text(
                                          order2[i].keterangan_barang,
                                          // order2.docs[i - 1]['description'],
                                          style:
                                              const pw.TextStyle(fontSize: 6)),
                                    ),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 0),
                                    child: pw.Text('1',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.SizedBox(height: 18),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        right: -5, left: 20),
                                    child: pw.Text(
                                        '\$ ${order2[i].price.toString()}',
                                        style: const pw.TextStyle(fontSize: 6)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pdfImages[i],
                                  // pw.Image(pw.MemoryImage(byteList2),
                                  //     fit: pw.BoxFit.fitHeight,
                                  //     height: 25,
                                  //     width: 25),
                                  pw.Divider(thickness: 1),
                                ])
                          ])
                      ]),
                    ]),
                // body isi page 2
                //body isi
                pw.Table(children: [
                  for (var i = 10; i < order.total_quantity; i++)
                    pw.TableRow(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18, width: 20),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: -15),
                              child: pw.Text((i + 1).toString(), //nomor
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: -5),
                              child: pw.Text(order2[i].name.toString(),
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(
                              height: 19,
                            ),
                            pw.SizedBox(
                              height: 6,
                              width: 80,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: -45),
                                child: pw.Text(order2[i].keterangan_barang,
                                    // order2.docs[i - 1]['description'],
                                    style: const pw.TextStyle(fontSize: 6)),
                              ),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 0),
                              child: pw.Text('1',
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(height: 18),
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.only(right: -5, left: 20),
                              child: pw.Text('\$ ${order2[i].price.toString()}',
                                  style: const pw.TextStyle(fontSize: 6)),
                            ),
                            pw.Divider(thickness: 1)
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pdfImages[i],
                            // pw.Image(pw.MemoryImage(byteList2),
                            //     fit: pw.BoxFit.fitHeight,
                            //     height: 25,
                            //     width: 25),
                            pw.Divider(thickness: 1),
                          ])
                    ])
                ]),
                //bottom pdf
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Terbilang                     :',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(width: 95, child: pw.Text('Total')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text('\$ ' + order.total.toString(),
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Kondisi Pembayaran   : ',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(width: 95, child: pw.Text('Diskon')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(order.basic_discount.toString() + ' %',
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Jangka Waktu             : ',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(width: 95, child: pw.Text('Rate')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(order.rate.toString(),
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                            width: 250,
                            child: pw.Text('Jatuh Tempo               : ',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.SizedBox(
                            width: 95, child: pw.Text('Total Transaksi')),
                        pw.Text(':'),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(
                              CurrencyFormat.convertToIdr(order.nett, 0)
                                  .toString(),
                              style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 20, top: 20.0),
                            child: pw.SizedBox(
                                child: pw.Text('Hormat Kami,',
                                    style: const pw.TextStyle(fontSize: 10)))),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 30, top: 20.0),
                            child: pw.SizedBox(
                                child: pw.Text('Hormat Kami,',
                                    style: const pw.TextStyle(fontSize: 10)))),
                      ],
                    ),
                    pw.SizedBox(height: 50),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              top: 20.0,
                            ),
                            child: pw.SizedBox(
                                child: pw.Text('Tanda Tangan & Nama Jelas',
                                    style: const pw.TextStyle(fontSize: 10)))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20.0),
                            child: pw.SizedBox(
                                child: pw.Text(
                                    '${sharedPreferences!.getString("name")!}',
                                    style: const pw.TextStyle(fontSize: 10)))),
                      ],
                    ),
                  ],
                )
              ];
            }
          }),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
