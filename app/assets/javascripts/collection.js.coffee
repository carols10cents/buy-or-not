$ ->
  window.buyOrNot ||= {}

  $('#sync-collection').on 'click', (event) ->
    $(this).text('Syncing...')
    $(this).attr('disabled', true)
    window.buyOrNot.lastSyncTime = new Date()
    window.buyOrNot.num = 0
    window.buyOrNot.total = 0
    window.buyOrNot.releases = []
    updateDisplay()
    syncCollection(1)

  syncCollection = (page) ->
    $.get '/collection/sync',
      { page: page },
      (data) ->
        window.buyOrNot.num = window.buyOrNot.num + data.num
        window.buyOrNot.total = data.total
        window.buyOrNot.releases.push(data.releases)
        updateDisplay()
        if data.page < data.total_pages
          syncCollection(page + 1)
        else
          $('#sync-collection').text('Sync Now')
          $('#sync-collection').attr('disabled', false)

  updateDisplay = ->
    $('.collection-num').html window.buyOrNot.num
    $('.collection-total').html window.buyOrNot.total
    if window.buyOrNot.releases.length > 0
      $('.search').html JSON.stringify window.buyOrNot.releases
