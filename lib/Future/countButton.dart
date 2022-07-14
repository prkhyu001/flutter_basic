import 'package:flutter/material.dart';

class countButton extends StatelessWidget {
  const countButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button 을 이용한 Future 연습'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                print('시작!');
                // exam1();
                // exam2().then((value) => print(value));
                String result = await exam2();
                print(result);
              },
              child: Text('연습1'),
            ),
            ElevatedButton(
              onPressed: () async {
                for (int i = 0; i < 5; i++){
                  await Future.delayed(const Duration(seconds: 1));
                  print("1 second elapsed, hi!");
                }
              },
              child: Text('두번째 버튼 예제'),
            ),
          ],
        ),
      ),
    );
  }

  // 3초 후에 프린트 되는 함수
  Future<void> exam1() async {
    var delay = Future.delayed(const Duration(seconds: 3));
    delay.then((value) => print("Hello!"));
  }

  // String 을 리턴해주는 함수
  // exam1() 함수와 똑같이 동작 but better option than exam1()

  Future<String> exam2() async {
    await Future.delayed(const Duration(seconds: 3));
    return "3 seconds passed, Hello!";
    // // (coding style used less frequently nowadays)
    // var sentence = await Future.value("3 seconds passed, Hello!");
    // return sentence;
  }
}
