ready = function() {
  $("#sync").click(function(){
    account = $('input[name="pixnet_user[account]"]').val();
    location.href = "/pixnet/users/sync/" + account;
  })

  $('input[name="pixnet_user[account]"]').blur(function(){
    var span = $("#account-span");
    var div = $("#account-div");

    $.get( "https://emma.pixnet.cc/blog?format=json&user=" + $(this).val(), function() {
      }).done(function( data ){
        span.removeClass('glyphicon-remove');
        div.removeClass('has-error');
        span.addClass('glyphicon-ok');
        div.addClass('has-success');
        $('input[type="submit"]').prop('disabled', false);
        $('#sync').attr("disabled", false);
      })
      .fail(function( data ){
        span.addClass('glyphicon-remove');
        div.addClass('has-error');
        span.removeClass('glyphicon-ok');
        div.remove('has-success');
        $('input[type="submit"]').prop('disabled', true);
        $('#sync').attr("disabled", true);
      });

  });

}

$(document).on('turbolinks:load', ready)
