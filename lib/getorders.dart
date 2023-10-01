import 'dart:html';

import 'package:chain_trace/createbid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chain_trace/appColor.dart';
import 'package:chain_trace/main_page.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/src/client.dart';
import 'package:chain_trace/web3func.dart';

import 'order.dart';

class getOrder extends StatefulWidget {
  const getOrder({Key? key}) : super(key: key);

  @override
  State<getOrder> createState() => _getOrderState();
}

Client? httpClient;
Web3Client? ethClient;
// Infura API endpoint
final String apiUrl =
    'https://sepolia.infura.io/v3/b641854f59c1482d91741e7cc78a5f48';
// Smart contract ABI
// Smart contract address
final String contractAddress = web3class.contactAdd;

class _getOrderState extends State<getOrder> {
  List<order> orders = [];
  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late DeployedContract _contract;
  bool isLoading = true;
  Future<void> fetchorder() async {
    orders.clear();
    final contractFunction = _contract.function('getOrderCount');
    List totalTaskList = await _client
        .call(contract: _contract, function: contractFunction, params: []);
    int totalorderlen = totalTaskList[0].toInt();

    final contractgetorder = _contract.function('getOrder');
    print(totalorderlen);
    for (var i = 1; i <= totalorderlen; i++) {
      var temp = await _client.call(
          contract: _contract,
          function: contractgetorder,
          params: [BigInt.from(i)]);
      print(temp);

      orders.add(order(
          id: (temp[0][0] as BigInt).toInt(),
          name: temp[0][1].toString(), // convert to String
          quantity: (temp[0][2] as BigInt).toInt(),
          price: (temp[0][3] as BigInt).toInt(),
          address: temp[0][4].toString(),
          description: temp[0][5], // use temp[5] instead of temp[4]
          isAccepted: temp[0][6].toString() // use temp[6] instead of temp[4]
          ));
    }
    print(orders);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initWeb3() async {
    // Create HTTP client to connect to Infura API endpoint
    final client = Web3Client(apiUrl, Client());

    // Load the contract ABI
    _abiCode = await rootBundle.loadString('assets/abi.json');

    // Parse the contract ABI
    _contractAbi = ContractAbi.fromJson(_abiCode, contractAddress);

    // Get the contract address
    _contractAddress = EthereumAddress.fromHex(contractAddress);

    // Create a DeployedContract instance
    _contract = DeployedContract(_contractAbi, _contractAddress);

    setState(() {
      _client = client;
    });
    fetchorder();
  }

  void initState() {
    super.initState();
    initWeb3();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: appColor.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              "lib/Images/logo.png",
              width: 25,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              "Chain Trace",
              style: TextStyle(
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order ID: ${orders[index].id}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Name: ${orders[index].name}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Quantity: ${orders[index].quantity}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Price: ${orders[index].price}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Address: ${orders[index].address}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Description: ${orders[index].description}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Accepted: ${orders[index].isAccepted}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:180.0,top: 24),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder:(context)=> createBid( id: orders[index].id,)));
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            boxShadow: [BoxShadow(
                                              color: Color(0xFF1CF6E8).withOpacity(0.6),
                                              blurRadius: 12,
                                              offset: Offset(2,2),
                                            )],
                                            borderRadius: BorderRadius.circular(12),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color(0xFF1CF6E8),Color(0xFF4E6DFF),Color(0xFF8E5EFF)],
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Let's go",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w400),),
                                              Icon(Icons.arrow_right_alt_sharp,color: Colors.white,size: 25,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
