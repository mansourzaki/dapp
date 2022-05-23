import 'dart:convert';

import 'package:dapp_f/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListModel with ChangeNotifier {
  List list = [];
  int size = 0;
  bool isLoading = false;
  final String _rpcUrl = 'http://192.168.1.47:7545';
  final String _wsUrl = 'ws://192.168.1.47:7545/';
  final String _privateKey =
      '0c2bfb12f49f5faee865838fa90d5a5f65c22ea6a95d4d6306b08b611733ab92';

  Web3Client? _web3client;
  String? _abiCode;
  Credentials? _credentials;
  EthereumAddress? _contractAddress;
  EthereumAddress? _ownerAddress;
  DeployedContract? _contract;
  ContractFunction? _addTask;
  ContractFunction? _getTask;
  ContractFunction? _updateStatus;
  ContractFunction? _deleteTask;
  ContractFunction? _getTaskCount;
  ContractFunction? _getAll;
  ContractEvent? _taskCreated;

  TodoListModel() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiFile = await rootBundle.loadString("src/abis/Todo.json");
    var jsonABi = jsonDecode(abiFile);
    _abiCode = jsonEncode(jsonABi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonABi['networks']['5777']['address']);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _ownerAddress = await _credentials!.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, 'Todo'), _contractAddress!);
    _addTask = _contract!.function('addTask');
    _getTask = _contract!.function('getTask');
    _deleteTask = _contract!.function('deleteTask');
    _getTaskCount = _contract!.function('getTaskCount');
    _updateStatus = _contract!.function('updateStatus');
    _getAll = _contract!.function('users');
    _taskCreated = _contract!.event('TaskCreated');
  }

  getTasks() async {
    List map = await _web3client!
        .call(contract: _contract!, function: _getAll!, params: []);
    print(map);
    notifyListeners();
  }

  addTask(String name) async {
    print('in addd task');
    isLoading = true;
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!, function: _addTask!, parameters: [name]));
    print(_ownerAddress);
    print('after');
  }

  Future<void> getTask(BigInt index) async {
    List s = await _web3client!
        .call(contract: _contract!, function: _getTask!, params: [index]);
    print('aaa $s');
    print(_ownerAddress);
  }
}
