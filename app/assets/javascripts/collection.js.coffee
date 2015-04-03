$ ->
  updateDisplay = ->
    if localStorage.lastSyncTime?
      prettyDate = $.timeago Date.parse localStorage.lastSyncTime
      $('.sync-stats').html "You last synced with Discogs #{prettyDate}."
    $('.collection-num').html localStorage.num
    $('.collection-total').html localStorage.total
    $('#results').html ''
    releases = JSON.parse(localStorage.releases)
    if releases.length > 0
      releaseStrings = $.map releases, (r, i) ->
        "#{r.artists} - #{r.title}"
      $.each releaseStrings.sort(), (i, r) ->
        $('#results').append("<li>#{r}</li>")

  updateDisplay()

  $('#sync-collection').on 'click', (event) ->
    $(this).text('Syncing...')
    $(this).attr('disabled', true)
    localStorage.lastSyncTime = new Date().toISOString()
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
          $('#results').filterable('refresh')
          $('#sync-collection').text('Sync Now')
          $('#sync-collection').attr('disabled', false)

  $('#results').filterable()
