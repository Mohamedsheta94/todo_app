import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_application/model/my_user.dart';
import 'package:todo_application/model/tasks.dart';

class FirebaseUtils {
  static CollectionReference<Tasks> getTasksCollection(String uId) {
    return getUserCollection()
        .doc(uId)
        .collection(Tasks.collectionName)
        .withConverter<Tasks>(
            fromFirestore: (snapShot, options) =>
                Tasks.fromFireStore(snapShot.data()!),
            toFirestore: (tasks, options) => tasks.toFireStore());
  }

  static Future<void> addTaskToFirebase(Tasks tasks, String uId) {
    var collection = getTasksCollection(uId);
    var docRef = collection.doc();
    tasks.id = docRef.id;
    return docRef.set(tasks);
  }

  static Future<void> deleteTaskFromFireStore(Tasks tasks, String uId) {
    return getTasksCollection(uId).doc(tasks.id).delete();
  }

  static Future<void> editIsDone(Tasks tasks, String uId) {
    return getTasksCollection(uId)
        .doc(tasks.id)
        .update({'isDone': !tasks.isDone!});
  }

  static Future<void> editTask(Tasks tasks, String uId) {
    return getTasksCollection(uId).doc(tasks.id).update(tasks.toFireStore());
  }

  static Future<void> updateTask(Tasks tasks, String uId) {
    return getTasksCollection(uId).doc(tasks.id).update(tasks.toFireStore());
  }

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUserCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var docSnapshot = await getUserCollection().doc(uId).get();
    return docSnapshot.data();
  }
}
