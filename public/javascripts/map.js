var map = null;
$(document).ready(function () {
  var myOptions = {
    zoom: 8,
    center: new google.maps.LatLng(0,0),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map"), myOptions);

  var bounds = new google.maps.LatLngBounds();

  for(var x in locations) {
    var ll = new google.maps.LatLng(locations[x]["lat"], locations[x]["lon"]);

    var marker = new google.maps.Marker({
      position: ll,
      map: map,
      title: x
    });

    bounds.extend(ll);
  }

  map.fitBounds(bounds);
});
