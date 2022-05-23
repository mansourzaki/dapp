// import 'package:flutter/material.dart';
// import 'package:flutter_web3/flutter_web3.dart';
// import 'package:web3dart/web3dart.dart';

// class MetaMaskProvider with ChangeNotifier {
//   static const operatingChain = 3;

//   String currentAddress = '';

//   int currentChain = -1;

//   bool get isEnabled => ethereum != null;

//   bool get isInOperatingChain => currentChain == operatingChain;

//   bool get isConnected => isEnabled && currentAddress.isNotEmpty;

//   clear() {
//     currentAddress = '';
//     currentChain = -1;
//     notifyListeners();
//   }

//   Future<void> connect() async {
//     if (isEnabled) {
//       final accounts = await ethereum!.requestAccount();
//       if (accounts.isNotEmpty) {
//         currentAddress = accounts.first;
//         currentChain = await ethereum!.getChainId();
//         notifyListeners();
//       }
//     }
//   }

//   init() {
//     if (isEnabled) {
//       ethereum!.onAccountsChanged((accounts) {
//         clear();
//       });
//       ethereum!.onChainChanged((chainId) {
//         clear();
//       });
//     }
//   }
// }
