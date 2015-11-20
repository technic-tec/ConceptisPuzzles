$(document).ready(
  ->
    $('.login-btn').click(
      ->
        uri = '/login?uri='+window.location
        child = window.open(uri)
        leftDomain = false
        setIntevel(
          ->
            try
              if (child.document.domain == document.domain)
                if (leftDomain && child.document.readyState == "complete")
                  clearInterval(interval)
                  window.addEventListener("message",
                    (e)->
                      console.log(e.data)
                      data = $.parseJSON(e.data)
                      child.close()
                      if data.errors || !data.success || !data.username
                        error = data.errors || "invalid response"
                        $('.flash-note').text("Login failed! #{data.errors}")
                      else
                        $('.user-info').text("Welcome, #{data.username}!")
                        $('.login').hide()
                        $('.logout').show()
                        $('.flash-note').text("Login success!")
                  , false)
                  child.postMessage("{ \"quest\": \"username\" }",  "*")
              else
                leftDomain = true
            catch e
              if child.closed
                clearInteval(inteval)
                alert("closed")
                return
              leftDomain = true
        , 500)
    )
    $('.logout-btn').click(
      ->
        $.ajax
          url: '/logout'
          crossDomain: true
          dataType: 'application/json'
          success: (data,  textStatus,  jqXHR) ->
            console.log(data)
            $('.logout').hide()
            $('.login').show()
            $('.flash-note').text("Logout success!")
          error: (jqXHR, textStatus, errorThrown ) ->
            console.error(errorThrown)
            $('.flash-note').text("Logout failed! #{errorThrown}")
    )
)
