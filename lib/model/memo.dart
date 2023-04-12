//メモに必要な情報をあらかじめ定義した設計図みたいなもの

import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  //型はFirestoreと合わせる
  String id;
  String title; //[必]メモのタイトル
  String detail; //[必]メモの内容
  Timestamp createDate; //[必]作成日時
  Timestamp? updateDate; //更新日時

  Memo(
      {required this.id,
      required this.title,
      required this.detail,
      required this.createDate,
      this.updateDate});
}

// void test() {
//   Memo newMwmo = Memo(
//     title: '新規めも',
//     detail: '買い出しに行く',
//     createDate: DateTime.now(),
//   );
// }
