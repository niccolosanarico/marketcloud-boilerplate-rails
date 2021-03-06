// http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
$(document).on('turbolinks:load', function() {

    // Manage interaction between user and cart
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

      $(this).prop('disabled', true);
      $(this).parents('form').submit();
    });

    // Make sure to re-enable buttons disabled when submitting the form
    $("[id^=form_cart_item_]").on("ajax:success", function(e, data, status, xhr) {
      $(this).find('.btn-number').prop('disabled', false);

      // Update the cart
      $.ajax({
        url: "cart.js",
        type: "GET",
        success: function(data){
            // Do nothing, the loaded js script will update the DOM.
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            console.log("Status: " + textStatus);
            console.log("Error: " + errorThrown);
        }
      });
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
