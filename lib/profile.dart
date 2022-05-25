import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

import 'services/functions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SessionStatus? session;
  String? account;
  DeployedContract? contract;
  bool isConnected = false;
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

  Future<void> _connect() async {
    contract = await loadContract();
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
    connector!.on('connect', (session) {
      isConnected = true;
      print(session);
    });
    connector!.on('session_update', (payload) => print(payload));
    connector!.on('disconnect', (session) => print(session));
    // connector!.killSession();
    if (!connector!.connected) {
      isConnected = true;
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
      print(contract!.address);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
              onPressed: () async {
                await connector!.killSession();
                isConnected = false;
                setState(() {});
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: isConnected
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text('getLicenses')),
                  ElevatedButton(
                      onPressed: () async {
                        print('create');
                        print('session');
                        // launchUrl(Uri.parse(
                        //     'wc:a227a073-c03a-4d8c-be3d-cd4e50c887ae@1'));
                        EthereumWalletConnectProvider provider =
                            EthereumWalletConnectProvider(connector!);

                        var re = await connector!.sendCustomRequest(
                            method: 'licenses',
                            params: [406153734]);
                        print(re);
                        // String result =
                        //     await EthereumWalletConnectProvider(connector!)
                        //         .sendTransaction(
                        //   from: session!.accounts.first,
                        //   to: '0x478a4904ED1e493D6c11D9C6746Ea7D6ab6736A6',
                        //   value: BigInt.from(10000000),
                        // );
                        // print('before launch');

                        // Credentials cre = EthPrivateKey.fromHex(
                        //     '955cf52b6dc10f22316b78807575686d9a60d8e28b288c9dc5bedc7e48cd924d');
                        // var _ownerAddress = await cre.extractAddress();
                        // print('$_ownerAddress adress');
                        // var res = await web3client!.sendTransaction(
                        //     cre,
                        //     Transaction.callContract(
                        //       value: EtherAmount.inWei(BigInt.from(500000000000000)),
                        //         contract: contract!,
                        //         function: contract!.function('createLicense'),
                        //         parameters: ['mans', BigInt.from(12345678)]));
                        // List s = await web3client!.call(
                        //     contract: contract!,
                        //     function: contract!.function('licenses'),
                        //     params: [BigInt.from(406153734)]);

                        // print(res);
                        // await connector!.sendCustomRequest(
                        //     method: 'createLicense  ',
                        //     params: ['mansour', 406153]);
                      },
                      child: const Text('Create New License'))
                ],
              ),
            )
          : _buildConnectionButtons(),
    );
  }

  Widget _buildConnectionButtons() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected
            ? const Text('connected')
            : ElevatedButton(
                child: Text('Conncet'),
                onPressed: () async {
                  await _connect();
                  setState(() {});
                }),
        ElevatedButton(
            child: const Text('Disconnect'),
            onPressed: () async {
              await connector!.killSession();
              setState(() {});
            }),
      ],
    ));
  }
}
