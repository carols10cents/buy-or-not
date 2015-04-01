$ ->
  updateDisplay = ->
    if localStorage.lastSyncTime?
      $('.sync-stats').html "You last synced on #{localStorage.lastSyncTime}"
    $('.collection-num').html localStorage.num
    $('.collection-total').html localStorage.total
    $('.search').html ''
    releases = JSON.parse(localStorage.releases)
    if releases.length > 0
      $.each releases, (i, r) ->
        $('.search').append("<div>#{r.artists} - #{r.title}</div>")

  updateDisplay()

  $('#sync-collection').on 'click', (event) ->
    $(this).text('Syncing...')
    $(this).attr('disabled', true)
    localStorage.lastSyncTime = new Date()
    localStorage.num          = 0
    localStorage.total        = 0
    localStorage.releases     = JSON.stringify []
    updateDisplay()
    syncCollection(1)

  syncCollection = (page) ->
    $.get '/collection/sync',
      { page: page },
      (data) ->
        localStorage.num   = parseInt(localStorage.num) + data.num
        localStorage.total = data.total

        previousReleases      = JSON.parse(localStorage.releases)
        localStorage.releases = JSON.stringify(previousReleases.concat data.releases)

        updateDisplay()
        if data.page < data.total_pages
          syncCollection(page + 1)
        else
          $('#sync-collection').text('Sync Now')
          $('#sync-collection').attr('disabled', false)
