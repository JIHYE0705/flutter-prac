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

  var favorites = <WordPair>[]; // 새 속성 `favorites` 추가. 제네릭을 이용하여 목록에 `WordPair>[]` 단어 쌍만 포함될 수 있다고 지정함.

  void toggleFavorite() {
    if(favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // 모든 위젯은 위젯이 항상 최신 상태로 유지되도록 위젯의 상황이 변경될 때마다 자동으로 호출되는 `build()` 메서드를 정의
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
                extended: false,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: 0,
                onDestinationSelected: (value) {
                  print('selected: $value');
                },
              ),
          ),
          Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: GeneratorPage(),
              ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if(appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
              ),
            ],
          ),
        ],
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
