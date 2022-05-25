import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('src/abis/DrivingLicense.json');
  String contractAddress = '0x50c6c07da80c31c123de6e88565003929d326d55';
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'DrivingLicense'),
      EthereumAddress.fromHex(contractAddress));
  print('load contract' + contract.toString());
  return contract;
}

Future<void> createNewLicens() async {}
