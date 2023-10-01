import 'package:chain_trace/web3func.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'bid.dart';
import 'package:http/src/client.dart';
import 'package:chain_trace/appColor.dart';
class getBids extends StatefulWidget {
  final int index;
  const getBids({Key? key, required this.index}) : super(key: key);

  @override
  State<getBids> createState() => _getBidsState();
}

Client? httpClient;
Web3Client? ethClient;
// Infura API endpoint
final String apiUrl = 'https://sepolia.infura.io/v3/b641854f59c1482d91741e7cc78a5f48';
// Smart contract ABI
// Smart contract address
final String contractAddress = web3class.contactAdd;
class _getBidsState extends State<getBids> {
  List<bid> bids =[];
  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late DeployedContract _contract;
  bool isLoading = true;
  late EthPrivateKey _cred;
  Future<void> updateAcc(int i)async{
    setState(() {
      isLoading=true;
    });
    print("entered isaccepted update");
    final contractfunctions = _contract.function('acceptBid');
    final result = await _client.sendTransaction(
        _cred,
        Transaction.callContract(
          contract: _contract,
          function: _contract.function('acceptBid'),
          parameters: [BigInt.from(widget.index),BigInt.from(i)],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    print(result);
    setState(() {
      isLoading=false;
    });

  }
  Future<void> fetchbid()async{
    print("entered fetchbuild");
    bids.clear();
    print("yes");
    final contractFunction = _contract.function('totalBidCount');
    List totalTaskList = await _client.call(contract: _contract, function: contractFunction, params: [BigInt.from(widget.index)]);
    print(totalTaskList);
    int totalTasklen = totalTaskList[0].toInt();
    final contractgetorder = _contract.function('getBid');
    for(var i =0;i<totalTasklen;i++){
      var temp = await _client.call(
        contract: _contract,
        function: contractgetorder,
        params: [BigInt.from(widget.index),BigInt.from(i)],
      );
      print(temp);
      bids.add(bid(
        orderId: (temp[0][0] as BigInt).toInt(),
        quantity: (temp[0][1] as BigInt).toInt(),
        price: (temp[0][2] as BigInt).toInt(),
        address: (temp[0][3]).toString(),
        isaccepted: (temp[0][4]).toString()
      ));
    }
    setState(() {
      isLoading  = false;
    });
    final privateKey = EthPrivateKey.fromHex(web3class.privatekey);
    final address = await privateKey.address;
    print(address.hex);
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
      _cred = EthPrivateKey.fromHex(web3class.privatekey);
    });
    print("web3 init complete");
    fetchbid();

  }
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
              itemCount: bids.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    updateAcc(index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${bids[index].orderId}",style: TextStyle(color: Colors.white),),
                        Text("Quantity: ${bids[index].quantity}",style: TextStyle(color: Colors.white),),
                        Text("Price: ${bids[index].price}",style: TextStyle(color: Colors.white),),
                        Text("Address: ${bids[index].address}",style: TextStyle(color: Colors.white),),
                        Text("Accepted: ${bids[index].isaccepted}",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                );
              },
            ),
          )


        ],
      ),
    );;
  }
}
