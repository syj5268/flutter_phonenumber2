import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Contact Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var real_contacts = await ContactsService.getContacts(); //연락처 사용
      setState(() {
        contacts = real_contacts;
      });
      print(contacts[0].displayName);
      //print(real_contacts[0].displayName);
      //var newPerson = Contact(); // 새로 추가
      //newPerson.givenName = 'Suyoung';
      //newPerson.familyName = 'Lee';
      //ContactsService.addContact(newPerson);
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request(); //허락해달라고 팝업띄우는 코드
      // openAppSettings(); //앱설정화면 켜준다.
    }
  }

//  @override
//  void initState() {
//    super.initState();
//    getPermission(); //initState 안에 있어서 위젯 로드될 때 한번 실행된다
//  }

  List<Contact> contacts = [];

  addContact(newname) {
    //setState 함수를 작성하여 메인 화면에 contact 추가
    setState(() {
      contacts.add(newname);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                getPermission();
              },
              icon: Icon(Icons.contacts))
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: FlutterLogo(),
            title: Text(contacts[index].givenName ?? "noname"),
          );
          //Container(child: contacts[index].givenName);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return inputDialog(addcon: addContact);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class inputDialog extends StatelessWidget {
  //inputDialog를 custom widget이라 부른다. widget=함수
  inputDialog({
    super.key,
    required this.addcon, //중괄호 안에 넣어주었기 때문에 위에서 'count: 00'
  });

  //부모한테 state 설정권한을 주어야함
  final addcon;
  final controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
      children: [
        TextField(
            controller: controller1,
            //input 가능한 창
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '텍스트를 입력해주세요',
            )),
        Row(
          children: [
            TextButton(
              onPressed: () {
                var newcon = new Contact();
                newcon.givenName = controller1.text;
                addcon(newcon);
              },
              child: Text('확인'),
            ),
            TextButton(onPressed: () {}, child: Text('취소'))
          ],
        ),
      ],
    ));
  }
}
