import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('src/abis/DrivingLicense.json');
  //String contractAddress = '0xB91Ef5cF73014FD827cc48310Dd87BCCBd1Ba9fD';
  String contractAddress = '0xEe737412A2605AcebD3c555ad8ad88941016E4bf';
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'DrivingLicense'),
      EthereumAddress.fromHex(contractAddress));
  print('load contract' + contract.toString());
  return contract;
}

Future<void> createNewLicens() async {}
