//import 'package:dart_web3/dart_web3.dart';
import 'dart:io';

import 'package:dapp_f/DrivingLicenseModel.dart';
import 'package:dapp_f/TodoListModel.dart';
import 'package:dapp_f/profile.dart';
import 'package:dapp_f/services/functions.dart';
import 'package:dapp_f/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider(
            create: (context) => DrivingLicenseModel(), child: ProfilePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SessionStatus? session;
  String? account;
  Web3Client? web3client;
  Client? httpClient;
  WalletConnect? connector;
  String rpcUrl =
      'https://ropsten.infura.io/v3/86ae74f732714f648d5078ae4b83f5d6';
  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('ff');
          //launchUrl(Uri.parse('wc:a227a073-c03a-4d8c-be3d-cd4e50c887ae@1'));
          EthereumWalletConnectProvider provider =
              EthereumWalletConnectProvider(connector!);
          var re = await connector!.sendCustomRequest(
              method: 'licenses', params: [BigInt.from(22222)]);
          print(re);
          // String result = await EthereumWalletConnectProvider(connector!)
          //     .sendTransaction(
          //         from: session!.accounts.first,
          //         to: '0x478a4904ED1e493D6c11D9C6746Ea7D6ab6736A6',
          //         value: BigInt.from(10000000));
          // SessionStatus newSession = await connector!.createSession(
          //     chainId: 3,
          //     onDisplayUri: (uri) async =>
          //         {print(uri), await launchUrl(Uri.parse(uri))});

          // print(result);
        },
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text('Conncet'),
        onPressed: () async {
          DeployedContract contract = await loadContract();
          print('connect button');
          connector = WalletConnect(
            bridge: 'https://bridge.walletconnect.org',
            clientMeta: const PeerMeta(
              name: 'Masnour',
              description: 'WalletConnect Developer App',
              url: 'https://walletconnect.org',
              icons: [
                'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
              ],
            ),
          );
          connector!.on('connect', (session) => print(session));
          connector!.on('session_update', (payload) => print(payload));
          connector!.on('disconnect', (session) => print(session));
          // connector!.killSession();
          if (!connector!.connected) {
            session = await connector!.createSession(
                chainId: 3,
                onDisplayUri: (uri) async =>
                    {print(uri), await launchUrl(Uri.parse(uri))});
          }
          setState(() {
            account = session!.accounts[0];
          });
          print('account ' + account!);
          if (account != null) {
            // print('in acc');
            // EthereumWalletConnectProvider provider =
            //     EthereumWalletConnectProvider(connector);
            // String result = await EthereumWalletConnectProvider(connector)
            //     .sendTransaction(
            //         from: session!.accounts.first,
            //         to: contract.address.toString());
            // print('result ' + result);
            print(contract.address);

            //  print('data: ${session!.accounts.first}');
            // yourContract = YourContract(address: contractAddr, client: client);
          }

          // if (account != null) {
          //   var httpClient = Client();
          //   final client = Web3Client(rpcUrl,);
          //   EthereumWalletConnectProvider provider =
          //       EthereumWalletConnectProvider(connector);
          // }
          // EthereumWalletConnectProvider provider =
          //     EthereumWalletConnectProvider(connector);
          // final credentials = EthereumWalletConnectProvider(connector);
        },
      )),
    );
  }
}
