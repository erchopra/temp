Application.EventDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#event-details')

    _.bindAll @, "selectTab"

    @delegateEvents()

  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


# This will specifically get called don the events show action
Application.events.show = ()->
  window.eventDetails = new Application.EventDetails()

$("#event-button-invoice").click (event) ->
  if document.getElementById("event-button-invoice").className.indexOf("disabled") != -1
    return false
  else
    return confirm('Are you sure? Invoicing will lock the event.')

$(".event-document-buttons").click (event) ->
  if document.getElementById("event-button-invoice").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-invoice-summary").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-quote").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-packing-slip").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-purchase-order").className.indexOf("disabled") != -1
    return false

  $('.event-document-buttons').find('.btn').addClass("disabled");

$("a").tooltip
  selector: ""
  placement: "right"

