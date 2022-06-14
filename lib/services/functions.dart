import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('src/abis/DrivingLicense.json');
  //String contractAddress = '0xB91Ef5cF73014FD827cc48310Dd87BCCBd1Ba9fD';
  String contractAddress = '0x1218aC46BD6Fb5C11676D723E458cE556fFB6217';
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'DrivingLicense'),
      EthereumAddress.fromHex(contractAddress));
  print('load contract' + contract.toString());
  return contract;
}

Future<void> createNewLicens() async {}
