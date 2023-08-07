import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {  // 임의의 새 `WordPair` 를 `current`에 재 할당함. 또한 `MyAppState`를 보고 있는 사람에게 알림을 보내는 `notifyListeners()` (`ChangeNotifier` 의 메서드) 를 호출함.
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // 모든 위젯은 위젯이 항상 최신 상태로 유지되도록 위젯의 상황이 변경될 때마다 자동으로 호출되는 `build()` 메서드를 정의
    var appState = context.watch<MyAppState>(); // `MyHomePage` 는 `watch` 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적
    var pair = appState.current;

    return Scaffold(  // 모든 `build` 메서드는 위젯 또는 중첩된 위젯 트리(좀 더 일반적임)를 반환해야합. 여기서 최상위 위젯은 `Scaffold`. 유용한 위젯이며 대부분의 실제 Flutter 앱에서 찾을 수 있음
      body: Center(
        child: Column( // Flutter 에서 가장 기본적인 레이아웃 위젯 중 하나. 하위 요소를 원하는 대로 사용하고 이를 위에서 아래로 열에 배치함. 기본적으로 열은 시각적으로 하위 요소를 상단에 배치함
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],  // Flutter 코드에서는 후행 쉼표를 많이 사용함. 이 특정 쉼표는 여기 없어도 됨. `children` 이 이 특정 `Column` 매개변수 목록의 마지막 멤버이자 유일한 멤버이기 때문. 그러나 일반적으로 후행 쉼표를 사용하는 것이 좋음. 멤버를 더 추가하는 작업이 쉬워지고, Dart 의 자동 형식 지정 도구에서 줄바꿈을 추가하도록 힌트 역할을 함
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  // 앱의 현재 테마를 요청
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    /**
     * `theme.textTheme` 을 사용하여 앱의 글꼴 테마에 액세스함. 이 클랫흐에는 `bodyMedium`(중간 크기의 표준 텍스트용) 또는 `caption`(이미지 설명용), `headlineLarge`(큰 헤드라인용) 등의 멤버가 포함되어있음
       `displayMedium` 속성은 디스플레이 텍스트를 위한 큰 스타일. 여기서 디스플레이라는 단어는 디스플레이 서체와 같은 인쇄상의 이미로 사용됨. `displayMedium` 문서에는 '디스플레이 스타일은 짧고 중요한 텍스트용으로 예약되어 있습니다' 라고 나옴
       테마의 `displayMedium` 속성은 이론적으로 `null` 일 수 있음. `!` 연산자(bang 연산자 - 절대 null 이 아님을 나타냄)를 사용하여 개발자가 잘 알고 하는 작업임을 Dart 에 알릴 수 있음.
       `displayMedium` 에서 `copyWith()` 를 호출하면 정의된 변경사항이 포함된 텍스트 스타일의 사본이 반환됨. 여기서는 텍스틍틔 색상만 변경함
       새로운 색상을 가져오려면 앱의 테마에 다시 액세스해야함. 색 구성표의 `onPrimary` 속성은 앱의 기본색상으로 사용하기 적합한 색상을 정의함
     */

    return Card(
      color: theme.colorScheme.primary, // `colorScheme` 속성과 동일하도록 카드의 색상 정의, 색 구성표에는 여러 색상이 포함되어 있으며 `primary` 가 앱을 정의하는 가장 두드러진 색상
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),  // `appState` 를 사용하고 해당 클래스의 유일한 멤버인 `current`(즉, `WordPair`)에 액세스함. `WordPair` 는 `asPascalCase` 또는 `asSnakeCase` 등 여러 유용한 getter 를 제공
      ),
    );
  }
}
