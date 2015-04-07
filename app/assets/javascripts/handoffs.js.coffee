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
    annotationsContainer.show()
    $('.annotations').append annotationsContainer
    @positionAnnotations()

  handleReplyClick: (event) ->
    button = $(event.target)
    replyVisible = button.closest('.reply').find('.reply-content').is(':visible')
    if replyVisible
      # submit form
    else
      event.preventDefault()
      id = button.closest('.annotations-for-id').data('id')
      @showReplyContentFor(id)

  showReplyContentFor: (id) ->
    annotationsContainer = @annotationsContainerFor(id)
    annotationsContainer.find('.btn-reply').removeClass('btn-default').addClass('btn-success')
    replyContent = annotationsContainer.find('.reply-content')
    replyContent.show()
    replyContent.find('textarea').focus()

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

new AnnotationRenderer()
