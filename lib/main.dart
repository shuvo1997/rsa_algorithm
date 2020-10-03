import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKeyPrime = GlobalKey<FormState>();
  final _formKeyD = GlobalKey<FormState>();
  final _formKeyEncrypt = GlobalKey<FormState>();
  final _formKeyDecrypt = GlobalKey<FormState>();
  int n = 0;
  int p;
  int q;
  int r;
  int e = 0;
  int d = 0;
  String normalmsg = '';
  String encryptedmsg = '';
  String inputencryptedmsg = '';
  String output = '';
  int appendval;
  int dropDownValue = 0;
  String checkmsg;

  double opacityStep1 = 0.0;
  double opacityStep2 = 0.0;
  double opacityStep3 = 0.0;
  double opacityStep4 = 0.0;

  List<Text> numbers = [];
  List<int> num = [];
  List<int> encryptedNumbers = [];

  int bigmod(int a, int b, int m) {
    int ans = 1;
    int rem = a % m;

    while (b != 0) {
      if (b % 2 == 1) {
        ans = (ans * rem) % m;
      }
      rem = (rem * rem) % m;
      b = (b / 2).floor();
    }
    return ans;
  }

  bool isPrime(int x) {
    if (x == 2) {
      return true;
    } else {
      for (int i = 2; i <= sqrt(x).ceil(); i++) {
        if (x % i == 0) {
          return false;
        } else if (i == sqrt(x).ceil()) {
          return true;
        }
      }
    }
  }

  int gcd(int a, int b) {
    if (b == 0) {
      return a;
    } else {
      return gcd(b, a % b);
    }
  }

  void listGen(int r) {
    numbers = [];
    for (int i = 2; i < r; i++) {
      if (gcd(i, r) == 1) {
        num.add(i);
        numbers.add(Text(
          i.toString() + ',',
          style: TextStyle(
            fontSize: 18,
          ),
        ));
      }
    }
  }

  void calculate(int e) {
    for (int i = 1; i < r; i++) {
      int x = 1 + i * r;
      if (x % e == 0) {
        d = (x / e).round();
        break;
      }
    }
  }

  List<int> textToNumbers(String s) {
    List<int> numbers = [];
    for (int i = 0; i < s.length; i++) {
      int val = s.codeUnitAt(i);
      //print(val);
      int num = bigmod(val, 7, 143);
      numbers.add(num);
    }
    return numbers;
  }

  String numbersToText(List<int> numbers) {
    String s = '';
    List<int> sortedNumbers = numbers.toList();
    sortedNumbers.sort();
    int lowestValue = sortedNumbers[0];
    if (lowestValue < 33) {
      int appendValue = 33 - lowestValue;
      appendval = appendValue;
      for (int i = 0; i < numbers.length; i++) {
        numbers[i] = numbers[i] + appendValue;
        //print(numbers[i]);
      }
    }
    for (int i = 0; i < numbers.length; i++) {
      s = s + String.fromCharCode(numbers[i]);
    }
    return s;
  }

  List<int> textToNumbersDecryption(String s) {
    List<int> numbers = [];
    for (int i = 0; i < s.length; i++) {
      int val = s.codeUnitAt(i);
      val = val - appendval;
      //print(val);
      int num = bigmod(val, 103, 143);
      numbers.add(num);
    }
    return numbers;
  }

  String numbersToTextDecryption(List<int> numbers) {
    String s = '';
    for (int i = 0; i < numbers.length; i++) {
      s = s + String.fromCharCode(numbers[i]);
    }
    return s;
  }

  void _changeOpacity() {
    setState(() {
      opacityStep1 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('RSA Algorithm')),
          backgroundColor: Colors.blueAccent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      'Step 1: Compute N as the product of P and Q',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Form(
                      key: _formKeyPrime,
                      child: Column(
                        children: [
                          TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter a prime number',
                                labelText: 'Enter a prime number: P ',
                              ),
                              validator: (val) {
                                if (val.isEmpty || !isPrime(int.parse(val))) {
                                  return 'Enter a prime number';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                p = int.parse(val);
                              }),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter a prime number',
                              labelText: 'Enter a prime number: Q',
                            ),
                            validator: (val) {
                              if (val.isEmpty || !isPrime(int.parse(val))) {
                                return 'Enter a prime number';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              q = int.parse(val);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FlatButton(
                            child: Text('Calculate'),
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (_formKeyPrime.currentState.validate()) {
                                setState(() {
                                  n = p * q;
                                  r = (p - 1) * (q - 1);
                                  listGen(r);
                                  num.add(1);
                                  _changeOpacity();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacityStep1,
                    duration: Duration(seconds: 1),
                    child: Text(
                      'N= P*Q = ' + n.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacityStep1,
                    duration: Duration(seconds: 2),
                    child: Text(
                      '\u03A6(n)= (p-1)*(q-1)=' + r.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacityStep1,
                    duration: Duration(seconds: 3),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ExpansionTile(
                          title: Text(
                            'Choose a number from below',
                            style:
                                TextStyle(fontSize: 20, color: Colors.purple),
                          ),
                          backgroundColor: Colors.purple[100],
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Wrap(
                                spacing: 3.0,
                                runSpacing: 3.0,
                                children: numbers,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      'Step 2: Find two numbers e and d that are relatively prime to N and for which e*d = 1 mod r:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Form(
                    key: _formKeyD,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter the value of e',
                              labelText: 'Enter the value of E',
                            ),
                            validator: (val) => val.isEmpty
                                ? 'Enter a number from the list'
                                : null,
                            onChanged: (val) {
                              e = int.parse(val);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            child: Text('Calculate D'),
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (_formKeyD.currentState.validate()) {
                                setState(() {
                                  calculate(e);
                                  opacityStep2 = 1.0;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedOpacity(
                    opacity: opacityStep2,
                    duration: Duration(seconds: 2),
                    child: Column(
                      children: [
                        Text(
                          'The value of d is:' + d.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'So, the public key is (' +
                              e.toString() +
                              ',' +
                              n.toString() +
                              ')',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'And the private key is (' +
                              d.toString() +
                              ',' +
                              n.toString() +
                              ')',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (gcd(e, n) == 1 && gcd(d, n) == 1) {
                          checkmsg = 'e and \u03A6(n) is relatively prime';
                        }
                      },
                      child: Text(
                        'Check e & d',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      'Step 3: Use e and d to encode and decode messages',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Form(
                    key: _formKeyEncrypt,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter a message',
                            labelText: 'Enter a message',
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a message' : null,
                          onChanged: (val) {
                            normalmsg = val;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          child: Text('Encrypt Message'),
                          color: Colors.blueAccent,
                          onPressed: () {
                            if (_formKeyEncrypt.currentState.validate()) {
                              setState(() {
                                encryptedNumbers = textToNumbers(normalmsg);
                                encryptedmsg = numbersToText(encryptedNumbers);
                                opacityStep3 = 1.0;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AnimatedOpacity(
                    opacity: opacityStep3,
                    duration: Duration(seconds: 2),
                    child: Column(
                      children: [
                        Text(
                          'The encrypted message is:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(encryptedmsg, style: TextStyle(fontSize: 20)),
                        CopyButton(
                          msg: encryptedmsg,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKeyDecrypt,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter encrypted message',
                            labelText: 'Enter encrypted message',
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a message' : null,
                          onChanged: (val) {
                            inputencryptedmsg = val;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          child: Text('Decrypt Message'),
                          color: Colors.blueAccent,
                          onPressed: () {
                            if (_formKeyDecrypt.currentState.validate()) {
                              setState(() {
                                encryptedNumbers =
                                    textToNumbersDecryption(inputencryptedmsg);
                                output =
                                    numbersToTextDecryption(encryptedNumbers);
                                opacityStep4 = 1.0;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AnimatedOpacity(
                    opacity: opacityStep4,
                    duration: Duration(seconds: 2),
                    child: Column(
                      children: [
                        Text(
                          'The message is:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          output,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  final String msg;
  CopyButton({this.msg});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: Colors.grey,
        onPressed: () {
          Clipboard.setData(ClipboardData(text: msg));
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Text is copied'),
            ),
          );
        },
        child: Text('Copy'));
  }
}
