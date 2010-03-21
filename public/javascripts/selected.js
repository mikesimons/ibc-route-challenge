$(document).ready(function() {
  $(".routebox").click(function() {
    if(this.checked) {
      routes[this.value].setMap(map);
    } else {
      routes[this.value].setMap(null);
    }
  });
});
