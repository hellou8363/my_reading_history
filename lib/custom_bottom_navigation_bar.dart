import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

int _selectedIndex = 0;

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return _bottomNavigationBar();
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: '독서록 목록',
          icon: Icon(
            CupertinoIcons.list_dash,
          ),
        ),
        BottomNavigationBarItem(
          label: '독서록 등록',
          icon: Icon(CupertinoIcons.pen),
        ),
        BottomNavigationBarItem(
          label: '독서록 통계',
          icon: Icon(CupertinoIcons.graph_square),
        ),
      ],
      // bottom icon을 눌렀을 때 index 값을 반환하는 메서드
      onTap: (index) {
        // _MainScreensState클래스의 build 메서드 호출(비동기 스케줄링)
        setState(
              () {
                _selectedIndex = index;
                switch(index) {
                  case 0: Navigator.pushNamed(context, '/readingList');
                  case 1: Navigator.pushNamed(context, '/recordCreate');
                  case 2: Navigator.pushNamed(context, '/readingStatistics');
                }
          },
        );
      },
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
    );
  }

}

