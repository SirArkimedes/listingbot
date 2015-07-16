
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("newUserId", function(request, response) {

  uuid(request, response);

});

function uuid(request, response) {
  var uuidRan = Math.floor((Math.random() * 9903509) + 1000000);

  var query = new Parse.Query("ListUsers");
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
