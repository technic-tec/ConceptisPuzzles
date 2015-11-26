$(document).ready(
  ->
    $('.login-btn').click(
      ->
        uri = '/login?uri='+window.location
        child = window.open(uri)
        leftDomain = false
        retry = 0
        interval = setInterval(
          ->
            try
              if `child.document.domain == document.domain`
                retry++
                if (leftDomain or retry == 5) and `child.document.readyState == "complete"`
                  clearInterval(interval)
                  window.addEventListener("message",
                    (e)->
                      data = $.parseJSON(e.data)
                      child.close()
                      if data.errors || !data.name
                        error = data.errors || "invalid response"
                        $('.flash-note').text("Login failed! #{data.errors}")
                      else
                        $('.user-info').text("Welcome, #{data.name}!")
                        $('.login').hide()
                        $('.logout').show()
                        $('.flash-note').text("Login success!")
                  , false)
                  child.postMessage("info",  "*")
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
          dataType: 'json'
          success: (data,  textStatus,  jqXHR) ->
            $('.logout').hide()
            $('.login').show()
            $('.flash-note').text("Logout success!")
          error: (jqXHR, textStatus, errorThrown ) ->
            console.error(errorThrown)
            $('.flash-note').text("Logout failed! #{errorThrown}")
    )
)
