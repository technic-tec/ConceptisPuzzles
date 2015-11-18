$(document).ready(
  ->
    $('.login').show()
    $('.logout').hide()
    $('.user-info').hide()
    $('.login').click(
      ->
        $.ajax
          url: '/login'
          crossDomain: true
          dataType: 'application/json'
          success: (data,  textStatus,  jqXHR) ->
            console.log(data)
            $('.user-info').text("Welcome, #{data.name}!")
            $('.login').hide()
            $('.user-info').show()
            $('.logout').show()
            $('.flash-note').text("Login success!")
          error: (jqXHR, textStatus, errorThrown ) ->
            errors = $.parseJSON(jqXHR.responseText).errors
            console.log(errorThrown)
            console.log(errors)
            $('.flash-note').text("Login failed! #{errors}")
    )
    $('.logout').click(
      ->
        $.ajax
          url: '/logout'
          crossDomain: true
          dataType: 'application/json'
          success: (data,  textStatus,  jqXHR) ->
            console.log(data)
            $('.user-info').hide()
            $('.logout').hide()
            $('.login').show()
            $('.flash-note').text("Logout success!")
          error: (jqXHR, textStatus, errorThrown ) ->
            console.error(errorThrown)
            $('.flash-note').text("Logout failed! #{errorThrown}")
    )
)
