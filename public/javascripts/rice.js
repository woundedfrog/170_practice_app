
$( document ).ready(function() {

    // ScrollReveal().reveal('.units', { delay: 50 });
    //   ScrollReveal().reveal('.sc', { delay: 50 });

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
  $('.exit-button2').show();
  // $('.exit-button2').css("visibility", "visible")

  $('main').css("visibility", "hidden")
    e.preventDefault();
  var path = this.href;
  $('#popout').load(path + ' .popping', function() {

    $('.back-button').hide();

  // highlight function
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


  });

});


$(document).on('click', '.exit-button2', function(e){
  $('#popout').hide();
  $('.exit-button2').hide();

  $('main').css("visibility", "visible")
  $('#popout').find('.popping').remove('.popping');
});

$(document).on('click', '.sc-container', function(e){
  $('#popout').hide();
  $('.exit-button2').hide();

  $('main').css("visibility", "visible")
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

  // // $('.profile_imgs').addClass('hide');
  //
  // $('.mobile').css('visibility', 'hidden');
  $('.full_unit_imgs').css('visibility', 'visible');
  $('.mobile-button').addClass('hide');

  $('.profile_imgs').css('visibility', 'hidden');
  $('.full_unit_imgs').css('visibility', 'visible');
  $('.full_unit_imgs').css('display', 'block');
  $('.profile_imgs').removeClass('show');
  $('.profile_imgs').css('display', 'contents');


  $('.profile-stat-col-container').addClass('profile-adj');
  $('.profile-stat-container').addClass('stat-cont-opacity');
};

function  showUnitsOnly(type) {
  $('.container').removeClass('hide');
  $('.btn').removeClass('btn-success').addClass('btn-warning');
  $('#'+type).removeClass('btn-warning').addClass('btn-success');
  $('.main-container').show();
  $('.units').show();
  $('.units').hide();
  $('.' + type).show();
};

function  showUnitsTier(type) {
  $('.container').removeClass('hide');
  $('.btn').removeClass('btn-success').addClass('btn-warning');
  $('#'+type).removeClass('btn-warning').addClass('btn-success');
  $('.main-container').show();
  $('.catagory_div').show();
  $('.catagory_div').hide();
  $('.0').hide();
  $('.' + type).show();
};

function  showAllUnits(type) {
  $('.container').removeClass('hide');
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

function goBack(e) {
  // if (document.referrer.indexOf(window.location.host) !== -1) {
  // window.history.back();
  if (e == 'units') {
    window.location = window.location.pathname.substring(0,14) + '/sort_by/tier';
  } else {
    window.location = window.location.pathname.substring(0,14);
  };
};

$(document).ready(function() {
  $('.main-container').hide();
  $('.0').show();
});

// back to top scroll button

window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    document.getElementById("myBtn").style.display = "block";
  } else {
    document.getElementById("myBtn").style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}

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

var loader = $(document).on('click', '.profile_imgs', function(e){
  // console.log('clicked');
  // $('.profile_imgs').addClass('show');
  $('.profile_imgs').css('visibility', 'hidden');
  $('.full_unit_imgs').css('visibility', 'visible');
  $('.full_unit_imgs').css('display', 'block');
  $('.profile_imgs').removeClass('show');
  $('.profile_imgs').css('display', 'contents');


  $('.profile-stat-col-container').addClass('profile-adj');
  $('.profile-stat-container').addClass('stat-cont-opacity');
});

$(document).on('click', '.full_unit_imgs', function(e){
  // console.log('clicked');
  $('.profile_imgs').addClass('show');
  $('.profile_imgs').css('visibility', 'visible');
  $('.full_unit_imgs').css('display', 'none');
  $('.profile_imgs').css('display', 'unset');


  $('.profile-stat-col-container').addClass('profile-adj');
  $('.profile-stat-container').addClass('stat-cont-opacity');
});

$(document).on('click', '.exit-button2', function(e){
  $('.profile_imgs').css('visibility', 'visible');
    $('.profile_imgs').css('display', 'unset');
  $('.profile-stat-col-container').css('position', 'unset');
  $('.profile-stat-col-container').removeClass('profile-adj');
  $('.profile-stat-container').removeClass('stat-cont-opacity');
});
