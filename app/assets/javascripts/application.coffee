# Javascript Rendering Pipeline
#
# This file gets included by the application layout, after the dependencies file is loaded.
#
# This is a standard asset pipeline manifest file which loads each of the controller specific
# javascript, as you see below. If your controller is not added here, just go ahead and add it.

# INCLUDE SUB JAVASCRIPT BELOW:
# -----------------------------
#
#= require ./helpers
#
#= require ./vendors
#= require ./accounts
#= require ./events
#= require ./billing_references
#= require ./admin/dashboard
#
#= require_self
#
#
# GLOBAL APPLICATION JAVASCRIPT BEHAVIOR
# --------------------------------------
# Application.onReady will get called on DOM ready for every view that gets rendered
# with the application.html.layout.  This function is responsible for
#
# 1)  Routing to any controller, and action specific javascript functions which follow
#     the naming convention
#
# 2)  Loading any global javascript functions or helpers and configuration
#
#

Application.onReady = ()->
  # The group function gets called on all controller actions that match group.
  # e.g. on the VendorsController#show action view that gets rendered:
  #
  # body.id = 'vendors_show'
  [group,parts...] = $('body').attr('id').split('_')

  action = parts.join('_')

  Application.trigger "before:boot"

  # The group function in this case would be Application.vendors
  # If that exists, call that function:
  Application[group]?.call?(window)

  # The specific action function would be Application.vendors.show
  # If that e function:
  Application[group]?[action]?.call?(window)

  Application.configureBootstrapBehaviors()
  Application.fields.setupCustomFields()

  Application.trigger "after:boot"

$(Application.onReady)

