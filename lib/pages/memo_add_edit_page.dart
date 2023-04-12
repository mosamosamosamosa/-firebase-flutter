import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase_udemy1/model/memo.dart';

class MemoAddEditPage extends StatefulWidget {
  const MemoAddEditPage({super.key, this.currentMemo});

  final Memo? currentMemo;

  //受け取ったcurremtMemoがnullならばadd notnullならばedit

  @override
  State<MemoAddEditPage> createState() => _MemoAddEditPageState();
}

class _MemoAddEditPageState extends State<MemoAddEditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  //メモ作成メソッド
  Future<void> createMemo() async {
    //コレクション'memo'にアクセスする
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    memoCollection.add({
      'title': titleController.text,
      'detail': detailController.text,
      'createDate': Timestamp.now()
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentMemo != null) {
      //このif文に来ている時点でnullではないので！でnull許容してあげる
      titleController.text = widget.currentMemo!.title;
      detailController.text = widget.currentMemo!.detail;
    }
  }

  Future<void> updateMemo() async {
    //.docで特定のドキュメントにアクセスできる
    final doc = FirebaseFirestore.instance
        .collection('memo')
        .doc(widget.currentMemo!.id);

    doc.update({
      'title': titleController.text,
      'detail': detailController.text,
      'upDateDate': Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(widget.currentMemo == null ? 'メモ追加' : 'メモ編集')),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('タイトル'),
              const SizedBox(height: 10),
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10)))),
              const SizedBox(height: 40),
              const Text('詳細'),
              const SizedBox(height: 10),
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: detailController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10)))),
              const SizedBox(height: 58),
              Container(
                  //入力欄とサイズを揃える
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        //メモ作成
                        if (widget.currentMemo == null) {
                          await createMemo();
                        } else {
                          await updateMemo();
                        }

                        Navigator.pop(context);
                      },
                      child: Text(widget.currentMemo == null ? '追加' : '更新')))
            ],
          ),
        ));
  }
}
