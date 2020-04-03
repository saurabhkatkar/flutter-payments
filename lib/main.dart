import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paymentapp/paytmScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Payments App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _amountController = TextEditingController();
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Razor Pay Code Start
  void openCheckout() async {
    var options = {
      'key': '<YOUR-RAZORPAY-API-KEY>',
      'amount': int.parse(_amountController.text) * 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  //Razor Pay Code Ends

  //PayTM Code Start
  void openPaytm() async {}
  //PayTM Code Ends

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter Price'),
                style: TextStyle(fontSize: 20.0),
                controller: _amountController,
              ),
            ),
            RaisedButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 45.0),
              shape: StadiumBorder(),
              onPressed: openCheckout,
              child: Text("Pay via RazorPay"),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 45.0),
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaytmScreen(
                      amount: _amountController.text,
                    ),
                  ),
                );
              },
              child: Text("Pay via PayTM"),
            ),
          ],
        ),
      ),
    );
  }
}
