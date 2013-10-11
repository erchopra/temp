#= require_tree .
#= require_self


# ------------------- Menu Templates -------------------

$("#menu_template_pricing_type").on "change", ->
  if $('#menu_template_pricing_type').val() == 'menu_level'
    $(".js-hide-show").show()
  else
    $(".js-hide-show").hide()


# ------------------- Dynamically adding nested fields -------------------

$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('fieldset').hide()
  event.preventDefault()

$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  if $(this).data("insertion-point")?
    $($(this).data("insertion-point")).append($(this).data('fields').replace(regexp, time))
  else
    $(this).before($(this).data('fields').replace(regexp, time))
    
  event.preventDefault()

# ------------------- Deprecated? -------------------

$ ->
menus = $('#menu_template_id').html()
$('#event_vendor_id').change ->
  vendor = $('#event_vendor_id :selected').text()
  options = $(menus).filter("optgroup[label='#{vendor}']").html()
  console.log(options)
  if options
    $('.js-event-toggle-menu').show()
    $('#event_menu_id').html(options)
  else
    $('#event_menu_id').empty()

# ------------------- Locations ------------------- 

$('#location_location_type').on 'change', ->
  location_type = $('#location_location_type :selected').text()
  $('.js-event-toggle-location-type').show()
  if location_type == 'Spot'
    $('.js-event-toggle-location-type-delivery').hide()
    $('.js-event-toggle-location-type-spot').show()
  if location_type == 'Delivery'
    $('.js-event-toggle-location-type-spot').hide()
    $('.js-event-toggle-location-type-delivery').show()

$('#location_building_id').on 'change', ->
    building_id = $('#location_building_id :selected').val()
    callback = (response) -> 
      $( '#location_building_address_address1').val(response.address1)
      $( '#location_building_address_notes').val(response.address2)
      $( '#location_building_address_city').val(response.city)
      $( '#location_building_address_state').val(response.state)
      $( '#location_building_address_zip_code').val(response.zip_code)
      $( '#location_building_address_country').val(response.country)
    $.get '/admin/buildings/'+String(building_id), {}, callback, "json"

# ------------------- Event Creation -------------------

$('#event_account_id').on 'change', ->
    callback = (response) -> 

      $el = $("#event_location_id")
      $el.empty()
      $.each response.locations, (index, location) ->
        $el.append $("<option></option>").attr("value", location.id).text(location.name)

      $el = $("#event_contact_id")
      $el.empty()
      $.each response.contacts, (index, contact) ->
        $el.append $("<option></option>").attr("value", contact.id).text(contact.name)

      $("#event_location_id").trigger("change")

    $.get '/accounts/'+$('#event_account_id :selected').val(), {}, callback, "json"

$('#event_location_id').on 'change', ->
    callback = (response) -> 

      if response.location_type == "spot"
        $("#event_quantity").val(response.expected_participation)
      else
        $("#event_quantity").val(0)

    $.get '/accounts/'+$('#event_account_id :selected').val() + '/locations/'+$('#event_location_id :selected').val(), {}, callback, "json"

$('#preference_preference_type').on 'change', ->
  preference_type = $('#preference_preference_type :selected').text()
  $('.js-event-toggle-preference-type').show()
  if preference_type == 'Vendor'
    $('.js-event-toggle-preference-type-cuisine').hide()
    $('.js-event-toggle-preference-type-vendor').show()
  if preference_type == 'Cuisine'
    $('.js-event-toggle-preference-type-vendor').hide()
    $('.js-event-toggle-preference-type-cuisine').show()

# ------------------- Event Vendors -------------------

$('#event_vendor_cuisine').on 'change', ->
    cuisine = $('#event_vendor_cuisine :selected').val()
    callback = (response) -> 
      $el = $("#event_vendor_vendor")
      $el.empty()
      $.each response, (index, vendor) ->
        $el.append $("<option></option>").attr("value", vendor.id).text(vendor.name)
      $el.trigger("change")
    $.get '/vendors/get_vendors_by_cuisine_and_product?cuisine='+cuisine+'&product='+$('#event_vendor_product').val(), {}, callback, "json"

$('#event_vendor_vendor').on 'change', ->
  vendor_id = $('#event_vendor_vendor :selected').val()
  unless vendor_id?
    $el = $("#event_vendor_menu_template")
    $el.empty()
  else
    callback = (response) -> 
      $el = $("#event_vendor_menu_template")
      $el.empty()
      $.each response, (index, menu_template) ->
        $el.append $("<option></option>").attr("value", menu_template.id).text(menu_template.name)
    $.get '/vendors/'+vendor_id+'/get_vendor_menu_templates_by_product?product='+$('#event_vendor_product').val(), {}, callback, "json"

# ------------------- Line Items ------------------- 

$('.line_item_type_id').on 'change', ->
  line_item_type = $('option:selected', this).text()

  if line_item_type == "Menu-Fee"
    $('.js-menu-fee-message').show()
    $('.js-non-menu-fee-data').hide()
  else
    $('.js-menu-fee-message').hide()
    $('.js-non-menu-fee-data').show()

  if line_item_type.toLowerCase().indexOf('tax') != -1
    $( '#line_item_tax_rate_expense_'.concat($(this).attr("unique-id"))).val(0)
    $( '#line_item_tax_rate_revenue_'.concat($(this).attr("unique-id"))).val(0)


$('.line_item_percentage_of_subtotal').on 'change', ->
  if $(this).is(':checked')
    $('#line_item_after_subtotal_'.concat($(this).attr("unique-id"))).prop('checked', true);

$('.line_item_after_subtotal').on 'change', ->
  if !$(this).is(':checked')
    $('#line_item_percentage_of_subtotal_'.concat($(this).attr("unique-id"))).prop('checked', false);

# ------------------- Event Financials Transaction Method ------------------- 

$('#transaction_method').on 'change', ->
  payment_method = $('#transaction_method :selected').text()
  if payment_method == 'CC'
    $('.js-transaction-method-toggle-extra-info').show()
  else
    $('.js-transaction-method-toggle-extra-info').hide()

# ------------------- Modal Initialization ------------------- 

realWidth = (obj) ->
  clone = obj.clone()
  clone.css("visibility", "hidden")
  $("body").append(clone)
  width = clone.outerWidth()
  clone.remove()
  width

$(".auto_size_modal").modal(
  show: false
  backdrop: true
  keyboard: true
).css
  width: "auto"
  height: "auto"

  "margin-left": ->
    -(realWidth($(this))/2)

# The following numbers should probably be extracted from CSS, but they'll
# be hardcoded for now.
# 50: Header height+padding
# 60: Bottom height+padding
# 15: Additional bottom padding
# 30: Body padding

$(".auto_size_modal_body").css
  "max-height": ($(window).height()*0.8 - (50+60+15+30))

# ------------------- DateTimePicker ------------------- 

$(".form_datetime").datetimepicker
  format: "dd MM yyyy - HH:ii P"
  showMeridian: true
  autoclose: true
  todayBtn: true
  showOnTextFieldClick: false

$(".form_date").datetimepicker
  format: "dd MM yyyy"
  showMeridian: true
  autoclose: true
  todayBtn: true
  showOnTextFieldClick: false
  dateOnly: true

# ------------------- Confirm Dialog -------------------
# http://stackoverflow.com/questions/14192009/how-can-i-display-delete-confirm-dialog-with-bootstraps-modal-not-like-brows

$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look below for implementations
  false # always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  html = """
         <div class="modal" id="confirmationDialog">
           <div class="modal-header">
             <a class="close" data-dismiss="modal">×</a>
             <h3>#{message}</h3>
           </div>
           <div class="modal-footer">
             <a data-dismiss="modal" class="btn">Cancel</a>
             <a data-dismiss="modal" class="btn btn-primary confirm">OK</a>
           </div>
         </div>
         """
  $(html).modal()
  $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)

# ------------------- Multi-select -------------------
->
$(".multiselect").multiselect
  visible: true
  buttonClass: "btn"
  buttonWidth: 250
  buttonContainer: "<div class=\"btn-group\" />"
  maxHeight: false
  buttonText: (options) ->
    if options.length is 0
      "None selected <b class=\"caret\"></b>"
    else if options.length > 2
      options.length + " selected  <b class=\"caret\"></b>"
    else
      selected = ""
      options.each ->
        selected += $(this).text() + ", "

      selected.substr(0, selected.length - 2) + " <b class=\"caret\"></b>"

# ------------------- SSP Persistence -------------------
$(".ssp_persistence_update").click ->
  $("#ssp_persistence_action").val("update")
  $("#ssp_persistence_id").val($(this).data("ssp_persistence_id"))
  $("#ssp_form").submit()

$(".ssp_persistence_delete").click ->
  $("#ssp_persistence_action").val("delete")
  $("#ssp_persistence_id").val($(this).data("ssp_persistence_id"))
  $("#ssp_form").submit()

$("#ssp_persistence_add").click ->
  $("#ssp_persistence_action").val("add")
  $("#ssp_persistence_name").val($(this).data("ssp_persistence_name"))
  $("#ssp_persistence_type").val($(this).data("ssp_persistence_type"))
  $("#ssp_form").submit()


# ------------------- Event Cancellation Reason ------------------- 

$('#event_status').on 'change', ->
  event_status = $('#event_status :selected').text()
  if event_status == 'Canceled'
    $('.js-event-cancellation-reason').show()
  else
    $('.js-event-cancellation-reason').hide()




