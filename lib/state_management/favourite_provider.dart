import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavouritesProvider extends ChangeNotifier {
  final CollectionReference restaurantDataCollection =
      FirebaseFirestore.instance.collection('restaurantData');
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');

  Future<String?> getRestaurantDocId(restaurantName, restaurantUnique) async {
    QuerySnapshot querySnapshot = await restaurantDataCollection
        .where('name', isEqualTo: restaurantName)
        .where('unique', isEqualTo: restaurantUnique)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<bool> isLiked(
      String userUid, String restaurantName, String restaurantUnique) async {
    final QuerySnapshot querySnapshot = await userDataCollection
        .doc(userUid)
        .collection('favourites')
        .where("name", isEqualTo: restaurantName)
        .where('unique', isEqualTo: restaurantUnique)
        .get();
    notifyListeners();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addFavoriteItem(
      String userUid, String restaurantName, String restaurantUnique) async {
    final restaurantDocId =
        await getRestaurantDocId(restaurantName, restaurantUnique);
    if (restaurantDocId != null) {
      final restaurantDocRef = restaurantDataCollection.doc(restaurantDocId);
      final DocumentSnapshot restaurantDocSnapshot =
          await restaurantDocRef.get();
      final Map<String, dynamic>? restaurantData =
          restaurantDocSnapshot.data() as Map<String, dynamic>?;
      if (restaurantData != null) {
        final favData = {"name": restaurantName, "unique": restaurantUnique};
        await userDataCollection
            .doc(userUid)
            .collection('favourites')
            .add(favData);
        List<String> currentLikes = List.from(restaurantData['likes'] ?? []);
        if (!currentLikes.contains(userUid)) {
          currentLikes.add(userUid);
          await restaurantDocRef.update({'likes': currentLikes});
        }
        notifyListeners();
      } else {
        return;
      }
    } else {
      return;
    }
  }

  Future<void> removeFavoriteItem(
      String userUid, String restaurantName, String restaurantUnique) async {
    final restaurantDocId =
        await getRestaurantDocId(restaurantName, restaurantUnique);
    if (restaurantDocId != null) {
      final QuerySnapshot querySnapshot = await userDataCollection
          .doc(userUid)
          .collection('favourites')
          .where("name", isEqualTo: restaurantName)
          .where('unique', isEqualTo: restaurantUnique)
          .get();
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (var document in documents) {
        await userDataCollection
            .doc(userUid)
            .collection('favourites')
            .doc(document.id)
            .delete();
      }
      final restaurantDocRef = restaurantDataCollection.doc(restaurantDocId);
      final DocumentSnapshot restaurantDocSnapshot =
          await restaurantDocRef.get();
      final Map<String, dynamic>? data =
          restaurantDocSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        List<String> currentLikes = List.from(data['likes'] ?? []);
        if (currentLikes.contains(userUid)) {
          currentLikes.remove(userUid);
          await restaurantDocRef.update({'likes': currentLikes});
        }
        notifyListeners();
      } else {
        return;
      }
    } else {
      return;
    }
  }
}
