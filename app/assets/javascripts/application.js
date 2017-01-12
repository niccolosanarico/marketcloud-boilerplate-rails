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
    // Google Analytics
    ga('send', 'pageview', window.location.pathname);

    // Address selection in cart
    $('#selectBillingAddress').hide();

    $('#sameShippingAndBilling').change(function(){
        if(this.checked)
            $('#selectBillingAddress').fadeOut('slow');
        else
            $('#selectBillingAddress').fadeIn('slow');

    });


    //image selection for a product //
    $(".img-available").click(function(event) {
       event.preventDefault();
  	   var selImg = $(this).attr('src');
       //working version - for multiple buttons - updates the search title //
       $(this).parents('.img-for-product').find('.img-selected').attr("src", selImg);

  	});

    //search button //
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

    // http://bootsnipp.com/snippets/featured/buttons-minus-and-plus-in-input
    $('.btn-number').click(function(e){
      e.preventDefault();

      fieldName = $(this).attr('data-field');
      type      = $(this).attr('data-type');
      var input = $("input[id='"+fieldName+"']");
      var currentVal = parseInt(input.val());

      if (!isNaN(currentVal)) {
        if(type == 'minus') {

         if(currentVal > 1) {
             input.val(currentVal - 1).change();
         }
         if(parseInt(input.val()) == 1) {
             $(this).prop('disabled', true);
         }

       } else if(type == 'plus') {
         input.val(currentVal + 1).change();
       }
      } else {
          input.val(1);
      }
    });

    $('.input-number').focusin(function(){
       $(this).data('oldValue', $(this).val());
    });

    $('.input-number').change(function() {

        valueCurrent = parseInt($(this).val());

        id = $(this).attr('id');

        if(valueCurrent >= 1) {
            $(".btn-number[data-type='minus'][data-field='"+id+"']").prop('disabled', false);
        } else {
            $(this).val($(this).data('oldValue'));
        }
    });
    $(".input-number").keydown(function (e) {
            // Allow: backspace, delete, tab, escape, enter and .
            if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
                 // Allow: Ctrl+A
                (e.keyCode == 65 && e.ctrlKey === true) ||
                 // Allow: home, end, left, right
                (e.keyCode >= 35 && e.keyCode <= 39)) {
                     // let it happen, don't do anything
                     return;
            }
            // Ensure that it is a number and stop the keypress
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                e.preventDefault();
            }
        });

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
    console.log("called");
    $('#footer').removeClass('invisible');
}
