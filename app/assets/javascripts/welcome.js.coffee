SHARED_PASSWORD = 'test'

logIn = (userEmail) ->
  $form = $('form.new_user')
  $form.find('#user_email').val(userEmail)
  $form.find('#user_password').val(SHARED_PASSWORD)
  setTimeout ->
    $form.submit()
  , 500

showLoading = ($button) ->
  $button.text 'Logging in…'

initializePrefillLoginButtons = ->
  $buttons = $('.prefill-login')
  $buttons.each ->
    $button = $(this)
    $button.click ->
      logIn($button.data('user-email'))
      showLoading($button)

$ ->
  initializePrefillLoginButtons()
