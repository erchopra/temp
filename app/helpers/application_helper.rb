module ApplicationHelper

  def flash_class(type)
    case type
    when :alert
      "alert-error"
    when :error
      "alert-error"
    when :notice
      "alert-success"
    else
      ""
    end
  end

  def body_class
    "#{ controller_name }"
  end

  def body_id
    "#{ controller_name }_#{ action_name }"
  end

  def all_inventory_items_for_vendor vendor_id
    Vendor.find(vendor_id).inventory_items.map { |a| [a.name, a.id]}
  end

  # dynamically adding nested fields
  # ------------------------------------------

  def link_to_add_fields(name, f, association, additional_params={})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    data = {id: id, fields: fields.gsub("\n", "")}
    data[:insertion_point] = additional_params[:insertion_point] unless additional_params[:insertion_point].nil?
    link_to(name, '#', class: "add_fields " + (additional_params[:class].nil? ? "" : additional_params[:class]), data: data)
  end

  # help with links
  ## ---------------------
  def url_with_protocol url
    /^http/.match(url) ? url : "http://#{url}"
  end

  def friendly_boolean field
    field ? "Yes" : "No"
  end

  def icon name
    css_class = "icon #{name}"
    content_tag(:i, nil, :class => css_class)
  end

end
