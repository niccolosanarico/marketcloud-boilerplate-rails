// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


// $(document).ready(function(){
// http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
$(document).on('turbolinks:load', function() {

    // Call SEGMENT pageview
    analytics.page();

    //search button in header//
    $(".search-item").click(function(event) {
       event.preventDefault();
  	   var selText = $(this).html();
       //working version - for multiple buttons - updates the search title //
       $(this).parents('.input-group-btn').find('.dropdown-toggle').html(selText+' <span class="caret"></span>');
       $(this).parents('.input-group-btn').find('#category_field').val(selText);

  	});

    // Sticky footer
    setFooterStyle();
    window.onresize = setFooterStyle;
});

function setFooterStyle() {
    var docHeight = $(window).height();
    var footerHeight = $('#footer').outerHeight();
    var footerTop = $('#footer').position().top + footerHeight;
    if (footerTop < docHeight) {
        $('#footer').css('margin-top', (docHeight - footerTop) + 'px');
    } else {
        $('#footer').css('margin-top', '');
    }
    $('#footer').removeClass('invisible');
}
