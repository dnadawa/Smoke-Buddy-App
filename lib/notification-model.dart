import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel{

  static getPlayerID(String uid) async {
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;
    String notificationID = user[0]['notificationID'];
    bool notifyOwnPosts = user[0]['notifyOwnPosts'];
    bool notifyOtherPosts = user[0]['notifyOtherPosts'];
    Map data = {
      'notificationID': notificationID,
      'notifyOwnPosts': notifyOwnPosts,
      'notifyOtherPosts': notifyOtherPosts,
    };
    return data;
  }

  static setPlayerID() {
    OneSignal.shared.getPermissionSubscriptionState().then((result) async {
      var playerId = result.subscriptionStatus.userId;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.get('uid');

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'notificationID': playerId
      });
    });
  }


  static sendFollowNotification({String receiverID,String postID}) async {
    var data = await NotificationModel.getPlayerID(receiverID);
    String playerID = data['notificationID'];
    bool notifyOwnPosts = data['notifyOwnPosts'];
    List<String> playerIDs = [playerID];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;

    String subjectName = user[0]['name'];
    if(notifyOwnPosts){
      OneSignal.shared.postNotification(OSCreateNotification(
          playerIds: playerIDs,
          content: "$subjectName followed your post.",
          heading: "Your post followed!",
          additionalData: {
            'type': 'postFollow',
            'postID': postID
          }
      ));
      await FirebaseFirestore.instance.collection('notifications').add({
        'notification': "$subjectName followed your post",
        'type': 'postFollow',
        'postID': postID,
        'uid': [receiverID],
        'time': DateTime.now().toString()
      });
    }

  }

  static sendProfileFollowNotification({String receiverID}) async {
    var data = await NotificationModel.getPlayerID(receiverID);
    String playerID = data['notificationID'];
    List<String> playerIDs = [playerID];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;

    String subjectName = user[0]['name'];

    OneSignal.shared.postNotification(OSCreateNotification(
        playerIds: playerIDs,
        content: "$subjectName followed you.",
        heading: "Your have followed!",
        additionalData: {
          'type': 'profileFollow',
        }
    ));
    await FirebaseFirestore.instance.collection('notifications').add({
      'notification': "$subjectName followed you",
      'type': 'profileFollow',
      'uid': [receiverID],
      'time': DateTime.now().toString()
    });
  }

  static sendPostCreateNotification({String author,String postID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');

    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;
    List following = user[0]['followers'];


    if(following.isNotEmpty){
      List<String> playerIDs = [];
      for(int i=0;i<following.length;i++){
        var data = await NotificationModel.getPlayerID(following[i]);
        String playerID = data['notificationID'];
        bool notifyOtherPosts = data['notifyOtherPosts'];
        if(notifyOtherPosts){
          playerIDs.add(playerID);
        }
      }

      if(playerIDs.isNotEmpty){
        OneSignal.shared.postNotification(OSCreateNotification(
            playerIds: playerIDs,
            content: "$author posted a new post.",
            heading: "New Post added",
            additionalData: {
              'type': 'postCreate',
              'postID': postID
            }
        ));
        await FirebaseFirestore.instance.collection('notifications').add({
          'notification': "$author posted a new post",
          'type': 'postCreate',
          'uid': following,
          'time': DateTime.now().toString()
        });
      }


    }


  }

  static sendLikeNotification({String receiverID,String postID,List following}) async {


    ///send to author
    var data = await NotificationModel.getPlayerID(receiverID);
    String authorID = data['notificationID'];
    bool notifyOwnPosts = data['notifyOwnPosts'];
    List<String> authorIDs = [authorID];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;
    String subjectName = user[0]['name'];
    if(uid!=receiverID&&notifyOwnPosts){
      OneSignal.shared.postNotification(OSCreateNotification(
          playerIds: authorIDs,
          content: "$subjectName liked your post.",
          heading: "Your post liked!",
          additionalData: {
            'type': 'postLike',
            'postID': postID
          }
      ));
      await FirebaseFirestore.instance.collection('notifications').add({
        'notification': "$subjectName liked your post",
        'type': 'postLike',
        'postID': postID,
        'uid': [receiverID],
        'time': DateTime.now().toString()
      });
    }



    ///send to followers


      if(following.contains(uid)){
        following.remove(uid);
      }

      if(following.isNotEmpty){
        List<String> followerIDs = [];
        for(int i=0;i<following.length;i++){
          var data = await NotificationModel.getPlayerID(following[i]);
          String followerID = data['notificationID'];
          bool notifyOtherPosts = data['notifyOtherPosts'];
          if(notifyOtherPosts){
            followerIDs.add(followerID);
          }
        }

        if(followerIDs.isNotEmpty){
          OneSignal.shared.postNotification(OSCreateNotification(
              playerIds: followerIDs,
              content: "$subjectName liked a post you are following.",
              heading: "Followed post liked!",
              additionalData: {
                'type': 'postLike',
                'postID': postID
              }
          ));

          await FirebaseFirestore.instance.collection('notifications').add({
            'notification': "$subjectName liked a post you are following",
            'type': 'postLike',
            'postID': postID,
            'uid': following,
            'time': DateTime.now().toString()
          });
        }



      }




  }

  static sendCommentNotification({String receiverID,String postID,List following}) async {


    ///send to author
    var data = await NotificationModel.getPlayerID(receiverID);
    String authorID = data['notificationID'];
    bool notifyOwnPosts = data['notifyOwnPosts'];
    List<String> authorIDs = [authorID];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;
    String subjectName = user[0]['name'];
    print(notifyOwnPosts);
    if(uid!=receiverID&&notifyOwnPosts){
      OneSignal.shared.postNotification(OSCreateNotification(
          playerIds: authorIDs,
          content: "$subjectName commented your post.",
          heading: "Your post commented!",
          additionalData: {
            'type': 'postComment',
            'postID': postID
          }
      ));
      await FirebaseFirestore.instance.collection('notifications').add({
        'notification': "$subjectName commented your post",
        'type': 'postComment',
        'postID': postID,
        'uid': [receiverID],
        'time': DateTime.now().toString()
      });
    }




    ///send to followers


      if(following.contains(uid)){
        following.remove(uid);
      }

      if(following.isNotEmpty){
        List<String> followerIDs = [];
        for(int i=0;i<following.length;i++){
          var data = await NotificationModel.getPlayerID(following[i]);
          String followerID = data['notificationID'];
          bool notifyOtherPosts = data['notifyOtherPosts'];
          if(notifyOtherPosts){
            followerIDs.add(followerID);
          }
        }

        if(followerIDs.isNotEmpty){
          OneSignal.shared.postNotification(OSCreateNotification(
              playerIds: followerIDs,
              content: "$subjectName commented a post you are following.",
              heading: "Followed post commented!",
              additionalData: {
                'type': 'postComment',
                'postID': postID
              }
          ));

          await FirebaseFirestore.instance.collection('notifications').add({
            'notification': "$subjectName commented a post you are following",
            'type': 'postComment',
            'postID': postID,
            'uid': following,
            'time': DateTime.now().toString()
          });
        }


      }




  }

}