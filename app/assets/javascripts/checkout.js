// http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
$(document).on('turbolinks:load', function() {

    // Address selection at checkout
    $('#selectBillingAddress').hide();

    $('#sameShippingAndBilling').change(function(){
        if(this.checked) {
            $('#selectBillingAddress').fadeOut('slow');
            // Uncheck the form
            $(this).parents('.form-horizontal').find('#selectBillingAddress .radio :radio').prop('checked', false);
          }
        else
            $('#selectBillingAddress').fadeIn('slow');

    });
});
