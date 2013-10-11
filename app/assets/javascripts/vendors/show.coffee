Application.VendorDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#vendor-details')

    _.bindAll @, "selectTab"

    @setupFormBindings()

    @delegateEvents()

  setupFormBindings: ()->
    @$('#product-config-section form').ajaxError (e, request, settings)=>
      console.log "Error", arguments

    @$('#product-config-section form').on "ajax:success", (e, data, status, xhr)=>
      Application.successMessage @$('#product-config-section')


  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


# This will specifically get called on the vendors show action
Application.vendors.show = ()->
  window.vendorDetails = new Application.VendorDetails()