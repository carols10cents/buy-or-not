$ ->
  initLocalStorage = ->
    localStorage.lastSyncTime = new Date().toISOString()
    localStorage.num          = 0
    localStorage.total        = 0
    localStorage.releases     = '[]'

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
          $('#search').attr('disabled', false)

  updateDisplay = ->
    prettyDate = $.timeago Date.parse localStorage.lastSyncTime
    $('.sync-stats').html "You last synced with Discogs #{prettyDate}."
    $('.collection-num').html localStorage.num
    $('.collection-total').html localStorage.total
    $('#results').html ''
    if localStorage.releases == '[null]'
      localStorage.releases = '[]'
    if localStorage.releases?.length > 0
      releases = JSON.parse(localStorage.releases)
      releaseStrings = $.map releases, (r, i) ->
        "#{r.artists} - #{r.title}"
      $.each releaseStrings.sort(), (i, r) ->
        $('#results').append("<tr><td>#{r}</td></tr>")

  $('#sync-collection').on 'click', (event) ->
    $(this).text('Syncing...')
    $(this).attr('disabled', true)
    initLocalStorage()
    updateDisplay()
    syncCollection(1)

  $('#results').filterable()

  if $('.collection').length > 0
    if localStorage.lastSyncTime?
      updateDisplay()
    else
      initLocalStorage()
      $('#notice').removeClass('hidden')
      $('#notice').html 'Syncing with Discogs: <span class="collection-num">0</span> out of <span class="collection-total">0</span>.<br />This only needs to happen the first time you log in on a new device.'
      $('#search').attr('disabled', true)
      syncCollection(1)
