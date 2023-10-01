import 'dart:html';
import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chain_trace/appColor.dart';
import 'package:chain_trace/web3func.dart';
import 'package:web3dart/web3dart.dart';
class createOrder extends StatefulWidget {
  const createOrder({Key? key}) : super(key: key);

  @override
  State<createOrder> createState() => _createOrderState();
}
Client? httpClient;
Web3Client? ethClient;
final String apiUrl = 'https://sepolia.infura.io/v3/b641854f59c1482d91741e7cc78a5f48';
final String contractAddress = web3class.contactAdd;
class _createOrderState extends State<createOrder> {
  late TextEditingController _namecontroller;
  late TextEditingController _quantitycontroller;
  late TextEditingController _pricecontroller;
  late TextEditingController _descriptioncontroller;
  String _name="";
  int _quantity=0;
  int _price = 0;
  String _description = "";
  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late DeployedContract _contract;
  late EthPrivateKey _cred;
  Future<void> initWeb3() async {
    final client = Web3Client(apiUrl, Client());
    _abiCode = await rootBundle.loadString('assets/abi.json');
    // Parse the contract ABI
    _contractAbi = ContractAbi.fromJson(_abiCode, contractAddress);

    // Get the contract address
    _contractAddress = EthereumAddress.fromHex(contractAddress);

    // Create a DeployedContract instance
    _contract = DeployedContract(_contractAbi, _contractAddress);
     // _cred = EthPrivateKey.fromHex(web3class.privatekey);
    final privatekey = '0046f5dd2b6c7e1fc595da7316b13f5e94236df1f2d4df3cbcc069c12e78849b';

    setState(() {
      _client = client;
      _cred = EthPrivateKey.fromHex(privatekey);
    });
    print("init web3 over");
    print(_cred.address);
  }
  Future<void> addorder() async {
    final result = await _client.sendTransaction(
        _cred,
        Transaction.callContract(
          contract: _contract,
          function: _contract.function('createOrder'),
          parameters: [_name,BigInt.from(_quantity),BigInt.from(_price),_description],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    print("complete");
  }
  @override
  void initState(){
    super.initState();
    initWeb3();
    _namecontroller = TextEditingController();
    _quantitycontroller = TextEditingController();
    _pricecontroller = TextEditingController();
    _descriptioncontroller = TextEditingController();
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
            Image.asset("lib/Images/logo.png",
              width: 25,
            ),
            SizedBox(width: 12,),
            Text("Chain Trace",
              style: TextStyle(
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 700,
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    width: 0.5,
                    color: Colors.blueGrey,

                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:28.0,left: 18.0),
                            child: Text("Submit Order",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 4,
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text("Just type your private key we know its not ethical but we are under Development hope you will understand <3",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0,top: 8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                onChanged:(changedtext){
                                  setState(() {
                                    _name = _namecontroller.text;
                                  });
                                },
                                maxLines: null,
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                expands: false,
                                controller: _namecontroller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey,
                                        )
                                    ),
                                    labelText: 'Enter name',
                                    labelStyle: TextStyle(
                                        color: Colors.blueGrey
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: 8,width: MediaQuery.of(context).size.width,),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                style: TextStyle(color: Colors.white),

                                onChanged:(changedtext){
                                  setState(() {
                                    _quantity=int.parse(_quantitycontroller.text);
                                  });
                                },
                                maxLines: null,
                                expands: true,
                                controller: _quantitycontroller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey
                                        )
                                    ),
                                    labelText: 'Enter quantity',
                                    labelStyle: TextStyle(
                                        color: Colors.blueGrey,
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: 8,width: MediaQuery.of(context).size.width,),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                onChanged:(changedtext){
                                  setState(() {
                                    _price = int.parse(_pricecontroller.text);
                                  });
                                },
                                maxLines: null,
                                expands: true,
                                controller: _pricecontroller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey
                                        )
                                    ),
                                    labelText: 'Enter Price',
                                    labelStyle: TextStyle(
                                        color: Colors.blueGrey
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: 8,width: MediaQuery.of(context).size.width,),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                onChanged:(changedtext){
                                  setState(() {
                                    _description = _descriptioncontroller.text;
                                  });
                                },
                                maxLines: null,
                                expands: true,
                                controller: _descriptioncontroller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey
                                        )
                                    ),
                                    labelText: 'Description',
                                    labelStyle: TextStyle(
                                        color: Colors.blueGrey
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:180.0,top: 18),
                              child: GestureDetector(
                                onTap: (){
                                    addorder();
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
