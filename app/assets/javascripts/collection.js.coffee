$ ->
  $('#sync-collection').on 'click', (event) ->
    $(this).text('Syncing...')
    $(this).attr('disabled', true)
    syncCollection(1)

  syncCollection = (page) ->
    $.get '/collection/sync',
      { page: page },
      (data) ->
        console.log data
        $('#sync-collection').text('Sync Now')
        $('#sync-collection').attr('disabled', false)
