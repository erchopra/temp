#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require underscore-min
#= require underscore-string.min
#= require backbone-min
#= require select2
#= require bootstrap-datetimepicker
#= require bootbox.min
#= require bootstrap-multiselect
#= require bootstrap-tooltip

#= require_self

$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

$("*").on "ajax:beforeSend", (e, xhr, settings)->
  xhr.setRequestHeader("X-CSRF-Token", $('meta[name="csrf-token"]').attr('content'))
