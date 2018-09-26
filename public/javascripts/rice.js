$( document ).ready(function() {
  jQuery.fn.highlight = function ( className) {
    return this.each(function () {
        this.innerHTML = this.innerHTML.replace(/-?[\d()\+\%]/g, function(matched) {return "<span class=\"" + className + "\">" + matched + "</span>";});
    });
};

$("p").highlight("highlight");
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
