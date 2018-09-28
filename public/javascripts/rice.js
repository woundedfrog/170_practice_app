$( document ).ready(function() {
  jQuery.fn.highlight = function ( className) {
    return this.each(function () {
        this.innerHTML = this.innerHTML.replace(/-?[\d+()\+\%]/g, function(matched) {return "<span class=\"" + className + "\">" + matched + "</span>";});
    });
};

$("p").highlight("highlight");


  $("#search").keyup(function(){
    var current_query = $("#search").val().toLowerCase();

    if ($(".unit-grid-cols")[0]) {

      $(".unit-grid-cols").hide();

      $(".unit-grid-cols").each(function(){
        current_name = this.getElementsByTagName('h6')[0].innerHTML.toLowerCase();
    // console.log(name);
        if (current_name.indexOf(current_query) >= 0){
          $(this).show();
        }
      });

    } else {
      $(".sc-grid-cols").hide();

      $(".sc-grid-cols").each(function(){
        current_name = this.getElementsByTagName('h6')[0].innerHTML.toLowerCase();
    // console.log(name);
        if (current_name.indexOf(current_query) >= 0){
          $(this).show();
        }
      });
    }

  }); //search function end


});



function checkMe() {
    if (confirm("Are you sure you want to delete profile? It can't be undone!")) {
        return true;
    } else {
        return false;
    }
};

// var docWidth = document.documentElement.offsetWidth;
//
// [].forEach.call(
//   document.querySelectorAll('*'),
//   function(el) {
//     if (el.offsetWidth > docWidth) {
//       console.log(el);
//     }
//   }
// );
