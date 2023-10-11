// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, avoid_print, deprecated_member_use, must_be_immutable, unused_element, curly_braces_in_flow_control_structures

import 'dart:typed_data';

import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
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
                child: Text(DateFormat('EEEE, dd MMMM yyyy ')
                        .format(DateTime.parse(order.created_at)) +
                    (int.parse(DateFormat('hh')
                                .format(DateTime.parse(order.created_at))) +
                            7)
                        .toString() +
                    DateFormat(':mm').format(DateTime.parse(order.created_at))),

                // DateTime.parse(order.created_at).toLokal().toString()),
                // DateTime.now().toLokal().toString()),
                // order.created_at.toString()),
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
                        ('Customer     : ') + (order.customer),
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
                        'Total price    : ${CurrencyFormat.convertToIdr(order.nett, 0)}',
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
                              if (sharedPreferences!
                                      .getString('role_sales_brand')! !=
                                  '3') {
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return const LoadingDialogWidget(
                                        message: "",
                                      );
                                    });
                                // _createPdfBeliBerlian();
                                _createPdf();
                                await Future.delayed(const Duration(seconds: 8))
                                    .then((value) {
                                  Navigator.pop(
                                    context,
                                  );
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return const LoadingDialogWidget(
                                        message: "",
                                      );
                                    });
                                // _createPdfMetier();
                                // _launchURLInApp();

                                _launchURLInBrowser();
                                await Future.delayed(const Duration(seconds: 3))
                                    .then((value) {
                                  Navigator.pop(
                                    context,
                                  );
                                });
                              }

                              // ignore: use_build_context_synchronously
                            },
                            icon: const Icon(
                              Icons.print,
                              color: Colors.black,
                              size: 30,
                            )),
                        sharedPreferences!.getString('role_sales_brand') == '3'
                            ? const SizedBox()
                            : IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (c) {
                                        return const LoadingDialogWidget(
                                          message: "",
                                        );
                                      });
                                  _sharePdf();
                                  await Future.delayed(
                                          const Duration(seconds: 4))
                                      .then((value) {
                                    Navigator.pop(
                                      context,
                                    );
                                  });
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
    var url = sharedPreferences!.getString('role_sales_brand') == '3'
        ? 'http://54.179.58.215:8080/metier/laporan/${order.invoices_number}' //? khusus metier

        : 'http://54.179.58.215:8080/transcation/laporan/${order.invoices_number}';

    // 'http://54.179.58.215:8080/transcation/laporan/${order.invoices_number}';
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
    ];
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

//pdf metier
  void _createPdfMetier() async {
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
    //for metier
    List<pw.Widget> pdfImagesMetier = imagesUint8list.map((image) {
      try {
        return pw.Image(
          pw.MemoryImage(
            image,
          ),
          height: 90,
          width: 90,
          fit: pw.BoxFit.scaleDown,
        );
      } catch (c) {
        return pw.Image(
          pw.MemoryImage(
            byteList2,
          ),
          height: 90,
          width: 90,
          fit: pw.BoxFit.scaleDown,
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
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            //bari1
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  child: pw.Text('INVOICE TO',
                                      style: const pw.TextStyle(fontSize: 12)),
                                ),
                                pw.SizedBox(
                                  child: pw.Text(order.invoices_number,
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                            //bari2

                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  child: pw.Text(order.customer,
                                      style: const pw.TextStyle(fontSize: 12)),
                                ),
                                pw.SizedBox(
                                    child: pw.Text(
                                        DateFormat('MMMM dd, yyyy').format(
                                  DateTime.parse(order.created_at),
                                ))),
                              ],
                            ),
                            //bari3

                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  child: pw.Text(order.alamat,
                                      style: const pw.TextStyle(fontSize: 12)),
                                ),
                                pw.SizedBox(
                                  child: pw.Text(order.alamat,
                                      style: const pw.TextStyle(
                                        fontSize: 18,
                                      )),
                                ),
                              ],
                            ),
                            //bari4

                            pw.SizedBox(
                              height: 3,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.SizedBox(
                                  child: pw.Text('0888888',
                                      style: const pw.TextStyle(fontSize: 12)),
                                ),
                                pw.SizedBox(
                                  child: pw.Text('www.metier.id',
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(height: 40),

                      //head table
                      pw.Table(children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Divider(thickness: 3),
                                pw.Container(
                                  width: 100,
                                  child: pw.Text("DESCRIPTION", //nomor
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Divider(thickness: 3),
                                pw.Container(
                                  width: 50,
                                  padding: const pw.EdgeInsets.only(
                                      top: 10, left: 5),
                                  child: pw.Text("IMAGE",
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Divider(thickness: 3),
                                pw.Container(
                                  width: 50,
                                  padding: const pw.EdgeInsets.only(left: 0),
                                  child: pw.Text("QTY",
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Divider(thickness: 3),
                                pw.Container(
                                  width: 50,
                                  padding: const pw.EdgeInsets.only(left: 10),
                                  child: pw.Text("PRICE",
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Divider(thickness: 3)
                              ]),
                        ]),
                      ]),

                      //body isi
                      pw.Table(children: [
                        for (var i = 0; i < order.total_quantity; i++)
                          pw.TableRow(children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Text(order2[i].name,
                                      maxLines: 1,
                                      style: const pw.TextStyle(fontSize: 14)),
                                  pw.Container(
                                    height: 72,
                                    width: 200,
                                    child: pw.Text(order2[i].keterangan_barang,
                                        // maxLines: 4,
                                        style:
                                            const pw.TextStyle(fontSize: 16)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pdfImagesMetier[i],
                                  pw.Divider(thickness: 1),
                                ]),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    child: pw.Text('1',
                                        style:
                                            const pw.TextStyle(fontSize: 16)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    child: pw.Text(
                                        CurrencyFormat.convertToIdr(
                                                order2[i].price, 0)
                                            .toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 16)),
                                  ),
                                  pw.Divider(thickness: 1)
                                ]),
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

//pdf beli berlian
  void _createPdfBeliBerlian() async {
    PdfDocument document = PdfDocument();
    final doc = pw.Document();
    final ByteData bytes = await rootBundle.load('images/welcomeIcon.png');
    final Uint8List byteList = bytes.buffer.asUint8List();

    final ByteData bgByte = await rootBundle.load('images/bgBeliberlian.jpg');
    final Uint8List bgUint2 = bgByte.buffer.asUint8List();

    final ByteData bytes2 = await rootBundle.load('images/ilauncher.png');
    final Uint8List byteList2 = bytes2.buffer.asUint8List();

//new multi
    List<String> assetImages = [
      for (var i = 0; i < order.total_quantity; i++)
        'https://parvabisnis.id/uploads/products/' + order2[i].image_name
    ];
    for (String image in assetImages) await getImageBytes(image);
    List<pw.Widget> pdfImagesMetier = imagesUint8list.map((image) {
      try {
        return pw.Image(
          pw.MemoryImage(
            image,
          ),
          height: 129,
          width: 150,
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
          margin:
              const pw.EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          build: (context) {
            return [
              pw.Stack(children: [
                pw.Positioned(
                    // bottom: -30,
                    child: pw.Container(
                  width: 595,
                  height: 841,
                  child: pw.Image(pw.MemoryImage(bgUint2),
                      fit: pw.BoxFit.fitHeight, height: 841, width: 595),
                )),
                pw.Container(
                  width: 595,
                  height: 841,
                  padding:
                      const pw.EdgeInsets.only(left: 50, right: 50, top: 46),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        //header logo
                        pw.Container(
                          height: 30,
                          child: pw.Center(
                            child: pw.SizedBox(height: 42, width: 225),
                          ),
                        ),

                        pw.Container(
                          height: 44,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  //bari1
                                  pw.SizedBox(
                                    child:
                                        // pw.Text(order.invoices_number,
                                        pw.Text('00192391294',
                                            style: const pw.TextStyle(
                                              fontSize: 11.5,
                                            )),
                                  ),
                                  pw.SizedBox(
                                    child:
                                        // pw.Text(order.invoices_number,
                                        pw.Text('VINA',
                                            style: const pw.TextStyle(
                                              fontSize: 11.5,
                                            )),
                                  ),
                                  pw.SizedBox(
                                    child:
                                        // pw.Text(order.invoices_number,
                                        pw.Text('0813231294123',
                                            style: const pw.TextStyle(
                                              fontSize: 11.5,
                                            )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        pw.Container(
                          height: 25,
                          child: pw.Center(
                            child: pw.Text('INVOICE PEMBELIAN',
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Container(
                            height: 27,
                            // padding: const pw.EdgeInsets.symmetric(vertical: 5),
                            color: PdfColors.black,
                            width: 800,
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceAround,
                              children: [
                                pw.Text('Qty',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text('Product Description',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text('Price',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text('Total',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            )),
                        //? body isi
                        pw.Container(
                            padding: const pw.EdgeInsets.only(top: 15),
                            height: 125,
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 35,
                                ),
                                pw.Container(
                                  // color: PdfColors.amber,
                                  width: 40,
                                  child: pw.Text('1',
                                      style: pw.TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 25,
                                ),
                                pw.Container(
                                  width: 185,
                                  child: pw.Text(
                                      'BRG04224890I44K Millenia Diamond Ring - Cincin Berlian Asli Eropa Size 11',
                                      maxLines: 10,
                                      style: pw.TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 30,
                                ),
                                pw.Container(
                                  width: 90,
                                  child: pw.Text('1,000,000',
                                      maxLines: 10,
                                      style: pw.TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 10,
                                ),
                                pw.Container(
                                  width: 90,
                                  child: pw.Text('1,000,000',
                                      maxLines: 10,
                                      style: pw.TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              ],
                            )),

                        //? garis
                        pw.Divider(
                          color: PdfColors.blue,
                          thickness: 3,
                        ),

                        //bottom pdf beliberlian
                        pw.Container(
                          height: 65,
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.only(top: 5),
                                child: pw.Text('Payment Method :',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColors.black,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Column(
                                children: [
                                  pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 5),
                                      width: 238,
                                      child: pw.Text('Sub Total',
                                          style: const pw.TextStyle(
                                              fontSize: 11.5))),
                                  pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 5),
                                      width: 238,
                                      child: pw.Text('Tax Rate',
                                          style: const pw.TextStyle(
                                              fontSize: 11.5))),
                                  pw.Container(
                                      padding: const pw.EdgeInsets.only(
                                          left: 5, top: 5, bottom: 5),
                                      width: 238,
                                      height: 30,
                                      color: PdfColors.black,
                                      child: pw.Text('Grand Total :',
                                          style: const pw.TextStyle(
                                              fontSize: 11.5,
                                              color: PdfColors.white))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        //? garis
                        pw.Divider(
                          color: PdfColors.blue200,
                          height: 2,
                          thickness: 3,
                        ),

                        pw.Row(
                          children: [
                            pw.Container(
                              height: 375,
                              width: 225,
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  // pw.Container(
                                  //     // color:  PdfColor.fromRYB(255, 180, 178, 164),
                                  //     child: pw.Column(
                                  //   mainAxisAlignment:
                                  //       pw.MainAxisAlignment.start,
                                  //   children: [
                                  //     for (var i = 0; i <= 120; i++)
                                  //       pw.Container(
                                  //         padding:
                                  //             const pw.EdgeInsets.symmetric(
                                  //                 vertical: 4),
                                  //         child: pw.Text('|',
                                  //             style: pw.TextStyle(
                                  //                 fontSize: 16,
                                  //                 color: PdfColors.blue200,
                                  //                 fontWeight:
                                  //                     pw.FontWeight.bold)),
                                  //       ),
                                  //   ],
                                  // )),
                                  pw.Container(
                                      padding: const pw.EdgeInsets.only(
                                          left: 30, top: 8),
                                      width: 176,
                                      height: 375,
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'Sertificate',
                                            style: pw.TextStyle(
                                                fontSize: 12,
                                                fontWeight: pw.FontWeight.bold),
                                          ),
                                          pw.SizedBox(
                                            height: 5,
                                          ),
                                          pw.Container(
                                            height: 129,
                                            width: 165,
                                            decoration: pw.BoxDecoration(
                                                borderRadius:
                                                    pw.BorderRadius.circular(
                                                        12)),
                                            child: pdfImagesMetier[0],
                                          ),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 10),
                                              child: pw.Center(
                                                  child: pw.Text(
                                                      // order.description,
                                                      'RG003248124',
                                                      style: const pw.TextStyle(
                                                          fontSize: 11.5)))),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 10),
                                              child: pw.Text('Spesifikasi',
                                                  style: pw.TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          pw.FontWeight.bold))),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('METAL',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('18K WHITE GOLD ',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('WEIGHT',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('18K WHITE GOLD ',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 10),
                                              child: pw.Text('Diamond',
                                                  style: pw.TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          pw.FontWeight.bold))),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('RD',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('46 PCS - 0.22 CT',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('RD',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('11 PCS - 0.0378 CT',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('CUT',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('EXCELLENT',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('COLOR',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('F',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('CLARITY',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('VVS',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  top: 5),
                                              child: pw.Row(
                                                children: [
                                                  pw.SizedBox(
                                                    width: 60,
                                                    child: pw.Text('STORE',
                                                        style:
                                                            const pw.TextStyle(
                                                          fontSize: 11.5,
                                                        )),
                                                  ),
                                                  pw.Text('beliberlian.id',
                                                      style: const pw.TextStyle(
                                                        fontSize: 11.5,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      )),
                                  // pw.Container(
                                  //                   child: pw.Column(
                                  //                 mainAxisAlignment:
                                  //                     pw.MainAxisAlignment.start,
                                  //                 children: [
                                  //                   for (var i = 0; i <= 120; i++)
                                  //                     pw.Container(
                                  //                       padding:
                                  //                           const pw.EdgeInsets.symmetric(
                                  //                               vertical: 4),
                                  //                       child: pw.Text('|',
                                  //                           style: pw.TextStyle(
                                  //                               fontSize: 16,
                                  //                               color: PdfColors.blue200,
                                  //                               fontWeight:
                                  //                                   pw.FontWeight.bold)),
                                  //                     ),
                                  //                 ],
                                  //               )),
                                ],
                              ),
                            ),
                            pw.Container(
                              height: 375,
                              width: 276,
                              child: pw.Column(
                                children: [
                                  pw.SizedBox(height: 10),
                                  pw.Text('Syarat dan Ketentuan',
                                      style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 12)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '1.Jual kembali dan tukar tambah hanya dapat dilakukan jika disertai invoice Pembelian asli dengan stempel asli',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '2.Potongan untuk jual kembali sebesar 25%, dan potongan untuk tukar tambah sebesar 205 dari harga perhiasan yang tertera di invoice.',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '3.Perhiasan yang akan dijual kembali atau tukar tambah hanya bisa diproses setelah pembelian minimal 1 tahun dan maksimal 2,5 tahun (rentang waktu bulan ke-13-bulan ke -30) setelah tanggal pembelian',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '1.Jual kembali dan tukar tambah hanya dapat dilakukan jika disertai invoice Pembelian asli dengan stempel asli',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '2.Potongan untuk jual kembali sebesar 25%, dan potongan untuk tukar tambah sebesar 205 dari harga perhiasan yang tertera di invoice.',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '3.Perhiasan yang akan dijual kembali atau tukar tambah hanya bisa diproses setelah pembelian minimal 1 tahun dan maksimal 2,5 tahun (rentang waktu bulan ke-13-bulan ke -30) setelah tanggal pembelian',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '1.Jual kembali dan tukar tambah hanya dapat dilakukan jika disertai invoice Pembelian asli dengan stempel asli',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '2.Potongan untuk jual kembali sebesar 25%, dan potongan untuk tukar tambah sebesar 205 dari harga perhiasan yang tertera di invoice.',
                                      style: const pw.TextStyle(
                                          color: PdfColors.black, fontSize: 7)),
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                ),
              ])
            ];
          }),
    );

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}

// ignore: camel_case_extensions
extension toLokalTime on DateTime {
  String? toLokal() {
    initializeDateFormatting();
    try {
      return DateFormat.yMMMMEEEEd('id').add_jm().format(this);
    } catch (e) {
      return null;
    }
  }
}
