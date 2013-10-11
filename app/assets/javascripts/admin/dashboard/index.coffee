#= require_self
#= require_tree .

Application.DashboardDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#admin-details')

    _.bindAll @, "selectTab"

    @delegateEvents()

  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


Application.dashboard = ()->

Application.dashboard.index = ()->
  window.dashboardDetails = new Application.DashboardDetails()
