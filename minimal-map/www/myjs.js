$("document").ready(function() {
  $(".darkmode-toggle").click(function() {
    if($(".darkmode-toggle")[0].innerText === "🌞") {
          $(".darkmode-toggle")[0].innerText = "🌙";
    } else {
      $(".darkmode-toggle")[0].innerText = "🌞";
    }

  });
});
    