class AnnotationRenderer
  constructor: ->
    @showAnnotations()
    @initializeEvents()
    @positionAnnotations()

  showAnnotations: ->
    @annotationsTemplate().hide()
    $('.annotations').show()

  initializeEvents: ->
    $(document).on 'click', '.btn-annotate', (event) =>
      id = $(event.target).closest('.annotatable').attr('id')
      @showAnnotateFormFor(id)
    $('.annotations').on 'click', '.btn-reply', (event) =>
      @handleReplyClick(event)
    $('.annotations').on 'focus', '.annotations-for-id :input', (event) =>
      $(event.target).closest('.annotations-for-id').addClass('raised')
    $('.annotations').on 'blur', '.annotations-for-id :input', (event) =>
      $(event.target).closest('.annotations-for-id').removeClass('raised')

  showAnnotateFormFor: (id) ->
    @createAnnotationsContainer(id) unless @annotationsContainerFor(id).length
    @showReplyContentFor(id)

  annotationsContainerFor: (id) ->
    $('.annotations-for-id').filter ->
      $(this).data('id') == id

  createAnnotationsContainer: (id) ->
    annotationsContainer = @annotationsTemplate().clone()
    annotationsContainer.attr('data-id', id)
    annotationsContainer.find('.resource-id').val(id)
    annotationsContainer.find('.annotation').remove()
    annotationsContainer.find('.author').addClass('template-temporary')
    annotationsContainer.show()
    $('.annotations').append annotationsContainer
    @positionAnnotations()

  handleReplyClick: (event) ->
    event.preventDefault()
    button = $(event.target)
    replyVisible = button.closest('.reply').find('.reply-content').is(':visible')
    if replyVisible
      @ajaxReply(event) if @readyToSubmit(button)
    else
      id = button.closest('.annotations-for-id').data('id')
      @showReplyContentFor(id)

  ajaxReply: (event) ->
    button = $(event.target)
    buttonPriorText = button.text()
    button.prop 'disabled', true
    button.text 'loading…'
    @submitForm button.closest('form'), (response) =>
      button.text buttonPriorText
      button.prop 'disabled', false
      replyBox = button.closest('.reply')
      if response
        @renderAnnotationResponse(replyBox, response)
        @resetReplyForm(replyBox)

  renderAnnotationResponse: (insertBefore, response) ->
    insertBefore.closest('.annotations-for-id').find('.template-temporary').remove()
    insertBefore.before($(response))

  resetReplyForm: (replyBox) ->
    replyBox.find('textarea').val('')
    replyBox.find('.btn-reply').removeClass('btn-success').addClass('btn-default')
    replyBox.find('.reply-content').hide()

  submitForm: (form, onComplete) ->
    $.ajax
      url: form.attr('action')
      type: 'POST'
      data: form.serialize()
      success: onComplete
      error: ->
        alert "There was an error submitting that. Maybe try again?"
        onComplete()

  showReplyContentFor: (id) ->
    annotationsContainer = @annotationsContainerFor(id)
    annotationsContainer.find('.btn-reply').removeClass('btn-default').addClass('btn-success')
    replyContent = annotationsContainer.find('.reply-content')
    replyContent.show()
    replyContent.find('textarea').focus()

  readyToSubmit: (button) ->
    # Assume comment, for now
    commentText = button.closest('.reply').find('textarea')
    notBlank = commentText.val().replace(/\s+/g, '').length > 0
    notBlank

  annotationsTemplate: ->
    $('.annotations-for-id[data-id=template]')

  positionAnnotations: ->
    annotationGroups = $('.annotations-for-id')
    annotationGroups.each ->
      annotationGroup = $(this)
      annotatable = $(document.getElementById(annotationGroup.data('id'))).closest('.annotatable')
      return unless annotatable.length
      yPosition = annotatable.position().top
      annotationGroup.css position: 'absolute', top: yPosition
    groupsSortedVertically = annotationGroups.sort (a, b) ->
      if $(a).css('top') > $(b).css('top') then 1 else -1
    $('.annotations').append(groupsSortedVertically)

new AnnotationRenderer()
