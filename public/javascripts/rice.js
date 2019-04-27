
$( document ).ready(function() {
  // remove thsi popout hide method if needed.
  $('#popout').hide();

  if($("#viewing_profile").length != 0 && window.innerWidth < 768) {
      $("header").hide();
  };

  jQuery.fn.highlight = function ( className) {

    return this.each(function () {
        this.innerHTML = this.innerHTML.replace(/-?[\d+()\+\%]/g, function(matched) {return "<span class=\"" + className + "\">" + matched + "</span>";});
      });

};

// THIS IS FOR THE POPUP info when clicking on a unit. Delete if not using;
$(document).on('click', '.linkaddress', function(e){
  $('#popout').show();
  $('main').hide();
    e.preventDefault();
  var path = this.href;
  $('#popout').load(path + ' .popping');
});

$(document).on('click', '.profile-row-container', function(e){
$('#popout').hide();
$('main').show();
  $('#popout').find('.popping').remove('.popping');
});

//  ^^^^^ THIS IS FOR THE POPUP info when clicking on a unit. Delete if not using;

$('p').each(function() {
  // checks if a <p> element has img imbedded.
  // if it does, then it skips the HIGHLIGHTING, else it highlights
  var name = $(this).children("img").length == 0;  // checks if the img element returns 0 or not

  if (name) {
    $(this).highlight("highlight");
  } else  {
      return;
    }
});

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

function mobileHide() {
  $('.mobile').addClass('show');
  $('.mobile-button').addClass('hide');
};

function  showUnitsOnly(type) {
  $('.btn').removeClass('btn-success').addClass('btn-warning');
  $('#'+type).removeClass('btn-warning').addClass('btn-success');
  $('.main-container').show();
  $('.units').show();
  $('.units').hide();
  $('.' + type).show();
};

function  showUnitsTier(type) {
  $('.btn').removeClass('btn-success').addClass('btn-warning');
  $('#'+type).removeClass('btn-warning').addClass('btn-success');
  $('.main-container').show();
  $('.catagory_div').show();
  $('.catagory_div').hide();
  $('.0').hide();
  $('.' + type).show();
};

function  showAllUnits(type) {
  $('.btn').removeClass('btn-success').addClass('btn-warning');
  $('#'+type).removeClass('btn-warning').addClass('btn-success');
  $('.main-container').show();
  $('.catagory_div').show();
  $('.units').show();
};

function checkMe(name) {
    if (confirm("Are you sure you want to delete '" + name.toUpperCase() + "' profile? It can't be undone!")) {
        return true;
    } else {
        return false;
    }
};

function goBack() {
  window.history.back();
};

$(document).ready(function() {
  $('.main-container').hide();
  $('.0').show();
});

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
