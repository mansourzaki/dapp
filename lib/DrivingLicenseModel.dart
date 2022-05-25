import 'dart:convert';

import 'package:dapp_f/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class DrivingLicenseModel with ChangeNotifier {
  List list = [];
  int size = 0;
  bool isLoading = false;
  final String _rpcUrl =
      'https://ropsten.infura.io/v3/86ae74f732714f648d5078ae4b83f5d6';
  final String _wsUrl =
      'wss://ropsten.infura.io/ws/v3/86ae74f732714f648d5078ae4b83f5d6';
  // final String _privateKey =
  //     '0c2bfb12f49f5faee865838fa90d5a5f65c22ea6a95d4d6306b08b611733ab92';
  final String _privateKey =
      '955cf52b6dc10f22316b78807575686d9a60d8e28b288c9dc5bedc7e48cd924d';

  Web3Client? _web3client;
  String? _abiCode;
  Credentials? _credentials;
  // EthereumAddress? _contractAddress =
  //     EthereumAddress.fromHex('0xB91Ef5cF73014FD827cc48310Dd87BCCBd1Ba9fD');
  EthereumAddress? _ownerAddress;
  DeployedContract? _contract;
  ContractFunction? _getLicense;
  ContractFunction? _createLicense;
  ContractFunction? _getLength;
  // ContractFunction? _getIds;

  DrivingLicenseModel() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _web3client =Web3Client('_rpcUrl', Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiFile =
        await rootBundle.loadString("src/abis/DrivingLicense.json");
    var jsonABi = jsonDecode(abiFile);
    _abiCode = jsonEncode(jsonABi);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _ownerAddress = await _credentials!.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode!, 'Todo'),
        EthereumAddress.fromHex('0x9e4b8b178588305b6f3028e62124a48cec38c9ad'));
    _getLicense = _contract!.function('licenses');
    _createLicense = _contract!.function('createLicense');
    _getLength = _contract!.function('getLicensesSize');
    // _getIds = _contract!.function('ids');
  }

  getLicensesSize() async {
    List map = await _web3client!
        .call(contract: _contract!, function: _getLength!, params: []);
    print(map);
    notifyListeners();
  }

  createLicense(String name, int id) async {
    print('in addd task');
    isLoading = true;
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _createLicense!,
            parameters: [name, BigInt.from(id)]));
    print(_ownerAddress);
    print('after');
  }

  // Future<void> getTask(BigInt index) async {
  //   List s = await _web3client!
  //       .call(contract: _contract!, function: _getTask!, params: [index]);
  //   print('aaa $s');
  //   print(_ownerAddress);
  // }
}
