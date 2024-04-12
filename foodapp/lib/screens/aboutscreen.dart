import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: Text('Thông tin nhóm 12'),
              ),
              ListTile(
                title: Text('Họ và tên: Nguyễn Bùi Minh Nhật'),
                subtitle: Text('MSSV: 20161347'),
              ),
              ListTile(
                title: Text('Họ và tên: Trần Thanh Huệ'),
                subtitle: Text('MSSV: 20110490'),
              ),
              ListTile(
                title: Text('Họ và tên: Cao Thọ Phú Thịnh'),
                subtitle: Text('MSSV: 21144449'),
              )
            ],
          ),
        )
    );
  }
}
