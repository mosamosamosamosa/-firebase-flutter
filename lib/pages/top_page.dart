import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_udemy1/model/memo.dart';
import 'package:flutter_firebase_udemy1/pages/memo_add_edit_page.dart';
import 'package:flutter_firebase_udemy1/pages/memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  // //Memo型はmodelで定義されてるもの
  // List<Memo> memoList = [];

  // //Firestoreから値を取ってくる処理
  // Future<void> fetchMemo() async {
  //   //コレクション'memo'へのアクセス
  //   final memoCollection =
  //       await FirebaseFirestore.instance.collection('memo').get();
  //   //ドキュメントたちへのアクセス
  //   final docs = memoCollection.docs;
  //   //ドキュメントの数だけ値を取ってくる
  //   for (var doc in docs) {
  //     Memo fetchMemo = Memo(
  //         title: doc.data()['title'],
  //         detail: doc.data()['detail'],
  //         createDate: doc.data()['createDate']);

  //     //取得した内容をmemoListに代入する
  //     memoList.add(fetchMemo);
  //   }
  //   //取得したら画面再描画
  //   setState(() {});
  // }

  //リアルタイムで表示に反映させる①
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  // @override
  // void initState() {
  //   super.initState();
  //   fetchMemo();
  // }

  Future<void> deleteMemo(String id) async {
    final doc = FirebaseFirestore.instance.collection('memo').doc(id);
    doc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter × Firebase'),
      ),
      //リアルタイムで表示に反映させる②
      body: StreamBuilder<QuerySnapshot>(
          //ここでリアルタイムに取ってきてるので取得系は全部ここ
          //desending: true 新い順　false 古い順
          stream: memoCollection
              .orderBy('createDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            //読み込み中だったら
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return Center(child: Text('データがありません'));
            }
            //ドキュメントの内容を変数に代入
            final docs = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      docs[index].data() as Map<String, dynamic>;
                  final Memo fetchMemo = Memo(
                      id: docs[index].id,
                      title: data['title'],
                      detail: data['detail'],
                      createDate: data['createDate'],
                      updateDate: data['updateDate']);
                  return ListTile(
                      //要素の右側
                      trailing: IconButton(
                        onPressed: () {
                          //下からひょいって出てくるやつ
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                //Iphoneに適用できる
                                return SafeArea(
                                  child: Column(
                                    //アイテムに合わせた大きさに
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                          onTap: () {
                                            //戻った時に閉じてて欲しい
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MemoAddEditPage(
                                                            currentMemo:
                                                                fetchMemo)));
                                          },
                                          leading: const Icon(Icons.edit),
                                          title: const Text('編集')),
                                      ListTile(
                                          onTap: () async {
                                            await deleteMemo(fetchMemo.id);
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(Icons.delete),
                                          title: const Text('削除'))
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.edit),
                      ),
                      onTap: () {
                        //確認画面に遷移
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MemoDetailPage(memo: fetchMemo)));
                      },
                      title: Text(fetchMemo.title));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MemoAddEditPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
