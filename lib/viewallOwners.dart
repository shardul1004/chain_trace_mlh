import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:chain_trace/appColor.dart';
import 'package:web3dart/web3dart.dart';
import 'package:chain_trace/web3func.dart';

class viewAllowner extends StatefulWidget {
  final int nftid;
  const viewAllowner({Key? key, required this.nftid}) : super(key: key);

  @override
  State<viewAllowner> createState() => _viewAllownerState();
}
Client? httpClient;
Web3Client? ethClient;
// Infura API endpoint
final String apiUrl = 'https://sepolia.infura.io/v3/b641854f59c1482d91741e7cc78a5f48';
// Smart contract ABI
// Smart contract address
final String contractAddress = '0xe123954341BB87A7EaA63B56c3f614624C3cd526';
class _viewAllownerState extends State<viewAllowner> {

  List<String> address = [];
  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late DeployedContract _contract;
  bool isLoading = true;
  int _tokenid = 0;
  late TextEditingController _tokenidcontroller;
  Future<void> fetchowner() async {
    // address.clear();
    // final contractFunction = _contract.function('getOwnersHistory');
    // List totalTaskList = await _client.call(contract: _contract, function: contractFunction, params: [BigInt.from(widget.nftid)]);
    // print(totalTaskList[0]);
    // int length = totalTaskList.length;
    // for(int i = 0; i<length;i++){
    //   address.add(totalTaskList[i]);
    // }
    address.clear();
    final contractFunction = _contract.function('getOwnersHistory');
    List<dynamic> totalTaskList = await _client.call(contract: _contract, function: contractFunction, params: [BigInt.from(widget.nftid)]);
    print(totalTaskList[0]);

    int length = totalTaskList.length;
    for (int i = 0; i < length; i++) {
      List<dynamic> innerList = totalTaskList[i];
      for (int j = 0; j < innerList.length; j++) {
        String individualAddress = innerList[j].toString(); // Convert dynamic to String
        address.add(individualAddress);
      }
    }

    print(address); // List of String addresses
    // final contractgetowner = _contract.function('ownerofnft');
    // int totaltasklen = totalTaskList[0].toInt();
    // for(var i =0;i<totaltasklen;i++){
    //   var temp = await _client.call(
    //       contract: _contract,
    //       function: contractgetowner,
    //       params: [BigInt.from(widget.nftid),BigInt.from(i)]
    //   );
    //   print(temp);
    //   address.add(temp[0].toString());
    // }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initWeb3() async {
    // Create HTTP client to connect to Infura API endpoint
    final client = Web3Client(apiUrl, Client());

    // Load the contract ABI
    _abiCode = await rootBundle.loadString('assets/abi_nft.json');

    // Parse the contract ABI
    _contractAbi = ContractAbi.fromJson(_abiCode, contractAddress);

    // Get the contract address
    _contractAddress = EthereumAddress.fromHex(contractAddress);

    // Create a DeployedContract instance
    _contract = DeployedContract(_contractAbi, _contractAddress);

    setState(() {
      _client = client;
    });
    print("init web3 over");
    fetchowner();
  }
  @override
  void initState(){
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
      body: isLoading? Center(child:CircularProgressIndicator()):Column(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width,),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: address.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address: ${address[index]}",style: TextStyle(color: Colors.white),),

                    ],
                  ),
                );
              },
            ),
          )


        ],
      ),
    );
  }
}
