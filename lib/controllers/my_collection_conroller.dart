import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCollectionController extends GetxController {
  late final CollectionReference collectionRef;
  late final RxList<DocumentSnapshot> documents;

  @override
  void onInit() {
    collectionRef = FirebaseFirestore.instance.collection('gym_report');
    documents = RxList<DocumentSnapshot>([]);
    super.onInit();
  }

  void fetchReportData() async {
    QuerySnapshot snapshot = await collectionRef.get();
    documents.value = snapshot.docs;
  }

  /*void updateData(DocumentSnapshot doc, Map<String, dynamic> newData) async {
    await doc.reference.update(newData);
    int index = documents.indexWhere((d) => d.id == doc.id);
    documents[index] = await doc.reference.get();
  }*/
}
