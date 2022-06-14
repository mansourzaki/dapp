import 'package:dapp_f/models/License.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Client httpClient;
  late Web3Client ethereumClient;
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController id2Controller = TextEditingController();

  String address = '0x3c5d57a73d0bc7e87289734a14f5f6e2e8c3cfda';
  String ethereumClientUrl =
      'https://ropsten.infura.io/v3/143aa563dccc496ab7993a6d0788add7';
  String contractName = 'DrivingLicense';
  String privateKey =
      '955cf52b6dc10f22316b78807575686d9a60d8e28b288c9dc5bedc7e48cd924d';
  bool loading = false;
  bool showDetails = false;
  int size = 0;
  License license = License('', '0', DateTime.now());
  Future<List<dynamic>> query(String functionName, List<dynamic> params) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: params);
    return result;
  }

  Future<dynamic> transaction(String functionName, List<dynamic> params) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    dynamic result = await ethereumClient.sendTransaction(
      credential,
      Transaction.callContract(
          contract: contract, function: function, parameters: params),
      chainId: 3
    );
    showDetails = false;
    return result;
  }

  Future<DeployedContract> getContract() async {
    String abi = await rootBundle.loadString("src/abis/DrivingLicense.json");
    String contractAddress = "0x58532E85A514045fA502641e42360bD4f26eC44b";
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<void> getLicense(int id) async {
    BigInt parsedId = BigInt.from(id);
    var result = await query('getLicense', [parsedId]);

    List data = result[0];
    int timestamp = int.parse(data[1].toString());
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    print(date.toString());
    license = License(data[0], data[1].toString(), date);
    showDetails = true;
    setState(() {});
    print(result);
  }

  Future<void> getLicensesSize() async {
    loading = true;
    setState(() {});
    List<dynamic> result = await query('balance', []);
    size = int.parse(result[0].toString());
    loading = false;
    print('size $size');
    setState(() {});
  }

  Future<void> createNewLicense(String name, int id) async {
    print('creating');
    BigInt parsedId = BigInt.from(id);
    final result = await transaction("createLicense", [name, parsedId]);
    print('created');
    print(result);
  }

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethereumClient = Web3Client(ethereumClientUrl, httpClient);
    getLicensesSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 700,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Balance",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              loading
                  ? const CircularProgressIndicator()
                  : Text(
                      size.toString(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(children: [
                  const Text(
                    'Create New License',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(label: Text('Name')),
                  ),
                  TextField(
                    controller: idController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(label: Text('Id')),
                  ),
                ]),
              ),
              const Divider(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Get License by Id',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            textBaseline: TextBaseline.alphabetic),
                      ),
                      TextField(
                        controller: id2Controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Id')),
                      ),
                      Visibility(
                        visible: showDetails,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${license.name}'),
                              Text('Id: ${license.id}'),
                              Text('Date ${license.time}')
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      onPressed: getLicensesSize,
                      icon: const Icon(Icons.refresh),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: IconButton(
                      onPressed: () =>
                          getLicense(int.parse(id2Controller.text)),
                      icon: const Icon(Icons.get_app),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: IconButton(
                      onPressed: () => createNewLicense(
                          nameController.text, int.parse(idController.text)),
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
