const functions = require("firebase-functions");
var admin = require("firebase-admin");
admin.initializeApp();
var db = admin.firestore();
const request = require('request');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.approvedPost = functions.firestore
    .document('Post/{postId}')
    .onWrite((change, context) => {
     
      const document = change.after.exists ? change.after.data() : null;

      if (document) {
            if (document.moderated && document.approvedBy) {
                var alert = new Object();
                alert.postid = change.after.id;
                alert.authorImgUrl = document.authorImgUrl;
                alert.authorName = document.authorName;
                alert.subject = "created a Post";
                alert.text = document.text;
                alert.archived = false;
                alert.created = document.lastUpdated;
                alert.createdBy = document.createdBy;
                alert.lastUpdated = document.lastUpdated;
                alert.lastUpdatedBy = document.lastUpdatedBy;

                return db.collection("Alert").add(alert).then(function(docRef) {
                    
                    var message = document.authorName + " created a new Post";

                    return db.collection("User").get().then(function(querySnapshot) {
                        querySnapshot.forEach(function(doc) {
                            var object = new Object();
                            object = doc.data();
                            object.id = doc.id;

                            if (object.apnsToken) {
                                if(object.id != document.createdBy) {
                                    sendNotifications(object.apnsToken, message);

                                }
                            }
                            
                        });
                
                    }).catch(function(error) {
                        
                    });
 
                }).catch(function(error) {
                    // res.send({error: error });
                    console.log(error);
                    return true;
                });

            }
      }
      

      // perform desired operations ...

 function sendNotifications(token, message) {
     request.post({
         url: "https://fcm.googleapis.com/fcm/send",
         method: "Post",
         json: true, // <--Very Important!!!
         headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
             'Authorization': 'key=AAAA9WAD-6w:APA91bESKO6_8126sxCh1zsXBzvSZPttUTPNIsSz3gV0hpV0EsvGOGRP5LH6YgRWqTSZI_5hD_Oip_IfgRYasS6nRqzgOtAYFEzU7tm2QnM_pJbqVGzvLmM6R3BHTNxa50UUQdLJwDF6'
         },
         body: {
             'to': token,
             'ollapse_key': 'type_a',
             'notifications': {
                 'body': message,
                 'title': 'New Post',
                 'badge': 1
                 }
             }
         }, function(error, response, body) {
             console.log(body);
             
         });
        }
    });
