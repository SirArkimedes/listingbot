
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("saveUserObject", function(request, response) {

  var user = request.params.userArchive;
  var userUuid = request.params.userUuid;

  var query = new Parse.Query("Users");
  query.equalTo("uuid", userUuid);
  query.find({
    success: function(results) {

      if (results.length <= 0) {
        response.error("Found no matching object");
      } else {
        results[0].set("object", user);
        response.success();
      }

    },
    error: function(error) {
      response.error("Object not found");
    }
  });

});

Parse.Cloud.define("newUserId", function(request, response) {

  uuid(request, response);

});

function uuid(request, response) {
  var uuidRan = Math.floor((Math.random() * 9903509) + 1000000);

  var query = new Parse.Query("Users");
  query.equalTo("uuid", uuidRan);
  query.find({
    success: function(results) {

      if (results.length <= 0) {
        response.success(uuidRan);
      } else {
        uuid(request,respond);
      }

    },
    error: function() {
      response.error("Object not found");
    }
  });
}

Parse.Cloud.define("newListId", function(request, response) {

  listUuid(request, response);

});

function listUuid(request, response) {
  var uuidRan = Math.floor((Math.random() * 9903509) + 1000000);

  var query = new Parse.Query("Lists");
  query.equalTo("uuid", uuidRan);
  query.find({
    success: function(results) {

      if (results.length <= 0) {
        response.success(uuidRan);
      } else {
        listUuid(request,respond);
      }

    },
    error: function() {
      response.error("Object not found");
    }
  });
}
