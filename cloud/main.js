
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("deleteListFromUserObject", function(request, response) {

  removeListFromUser(request, response);
  removeUserFromList(request, response);

});

function removeListFromUser(request, response) {
  var user = request.params.userArchive;
  var userUuid = request.params.userUuid;
  var listUuid = request.params.listUuid;

  var query = new Parse.Query("Users");
  query.equalTo("uuid", userUuid);
  query.find({
    success: function(results) {

      if (results.length <= 0) {
        response.error("Found no matching User object");
      } else {
        // results[0].set("object", user);

        // Remove this list from the listAccess array
        var listAccess = results[0].get("listAccess");
        // console.log(listAccess);
        for (var i = 0; i < listAccess.length; i++) {
            if (listAccess[i] == listUuid) {
              listAccess.splice(i, 1);
            }
        }
        // Save
        results[0].save({listAccess: listAccess, object: user}, {
          success: function(point) {
            // Saved successfully.
            // response.success("Saved.");
        },
          error: function(point, error) {
            // The save failed.
            // error is a Parse.Error with an error code and description.
            console.log(error);
            // response.error(error);
          }
        });

      }

    },
    error: function(error) {
      response.error("Object not found");
    }
  });
}

function removeUserFromList(request, response) {
  var user = request.params.userArchive;
  var userUuid = request.params.userUuid;
  var listUuid = request.params.listUuid;

  var query = new Parse.Query("Lists");
  query.equalTo("uuid", listUuid);
  query.find({
    success: function(results) {

      if (results.length <= 0) {
        response.error("Found no matching List object");
      } else {
        results[0].set("object", user);

        // Remove this list from the listAccess array
        var sharedWith = results[0].get("sharedWith");
        for (var i = 0; i < sharedWith.length; i++) {
            if (sharedWith[i] == userUuid) {
              sharedWith.splice(i, 1);
            }
        }
        // Save
        results[0].save({sharedWith: sharedWith, object: user}, {
          success: function(point) {
            // Saved successfully.
            response.success("Saved.");
        },
          error: function(point, error) {
            // The save failed.
            // error is a Parse.Error with an error code and description.
            console.log(error);
            response.error(error);
          }
        });
      }

    },
    error: function(error) {
      response.error("Object not found");
    }
  });
}

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
        // Save
        results[0].save({object: user}, {
          success: function(point) {
            // Saved successfully.
            response.success("Saved.");
        },
          error: function(point, error) {
            // The save failed.
            // error is a Parse.Error with an error code and description.
            console.log(error);
            response.error(error);
          }
        });
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
