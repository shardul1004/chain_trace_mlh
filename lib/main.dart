import 'dart:html';
import 'package:chain_trace/createbid.dart';
import 'package:chain_trace/createorder.dart';
import 'package:chain_trace/getbids.dart';
import 'package:chain_trace/main_page.dart';
import 'package:chain_trace/mintnft.dart';
import 'package:chain_trace/registration.dart';
import 'package:chain_trace/viewallOwnerfirst.dart';
import 'package:chain_trace/viewallOwners.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:chain_trace/web3func.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
void main() {
  runApp(const MyApp());
}
Client? httpClient;
Web3Client? ethClient;
// Infura API endpoint
final String apiUrl = 'https://sepolia.infura.io/v3/b641854f59c1482d91741e7cc78a5f48';
// Smart contract ABI
// Smart contract address
final String contractAddress = web3class.contactAdd;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chain Trace',
      home: mainPage(),
    );
  }
}


