class PermittedParams < Struct.new(:params, :user)

 # emails
  # ------------------------------
  def email
    params.require(:email).permit(*email_attributes)
  end

  def email_attributes
    [:email, :email_list]
  end

 # location
  # ------------------------------
  def location
    params.require(:location).permit(*location_attributes)
  end

  def location_attributes
    [:name, :location_type, :expected_participation, :privacy, 
      :service_event_instructions, :connectivity_instructions, 
      :delivery_event_instructions, :building_address_notes, :contact_id, :building_id, 
      :account_id]
  end

  # market
  # ------------------------------
  def market
    params.require(:market).permit(*market_attributes)
  end

  def market_attributes
    [:name, :default_tax_rate]
  end

  # vendor product types
  # ------------------------------
  def vendor_product_type
    params.require(:vendor_product_type).permit(*vendor_product_type_attributes)
  end

  def vendor_product_type_attributes
    [:vendor_id, :product_type, :status]
  end

  # account pricing tiers
  # ------------------------------
  def account_pricing_tier
    params.require(:account_pricing_tier).permit(*account_pricing_tier_attributes)
  end

  def account_pricing_tier_attributes
    [:account_id, :product, :pricing_tier_id]
  end

  # contact
  # ------------------------------

  def contact
    params.require(:contact).permit(*contact_attributes)
  end

  def contact_attributes
    [:name, :position, :email, :phone_number, :mobile_number, :fax_number, :primary_contact, 
      :event_notifications, :billing_notifications, :sms]
  end

  # building
  # ------------------------------
  
  def building
    params.require(:building).permit(*building_attributes)
  end

  def building_attributes
    [:name, :insurance_requirements, :insurance_required, 
      :parking_information, :loading_information, :site_directions, :market_id, 
      :contact_title, :contact_name, :contact_phone, :contact_cell, 
      :contact_fax, :contact_email, :address_id, :contact_id, :timezone,
      address_attributes: [:id, :name, :address1, :address2, :city, 
      :state, :zip_code, :country]]
  end

  # event
  # ------------------------------
  def event
    params.require(:event).permit(*event_attributes)
  end

  def event_attributes
    [:name, :account_id, :quantity, :product, :menu_name, :meal_period,
      :status, :contact_id, :event_start_time, :event_end_time, :service_style,
      :setup_start_time, :setup_end_time, :individual_label, :utensils_plates_napkins, 
      :serving_utensils, :sternos, :chaffing_frames, :internal_event_notes, :cancellation_reason,
      :external_account_notes, :building_instructions, :location_instructions, :location_id,
      :created_by_id, :canceled_within_24_hours,
      event_vendors_attributes: [:id, :external_vendor_notes]]
  end



  # event_vendor
  # ------------------------------
  def event_vendor
    params.require(:event_vendor).permit!
  end

  # inventory_item
  # ------------------------------

  def inventory_item
    # params.require(:inventory_item).permit(*inventory_item_attributes)
    params.require(:inventory_item).permit!
  end

  def inventory_item_attributes
    [:name, :description, :cogs, :perks_price, :retail_price, :tag_list, 
      :option_list, :meal_type, :product_types_allowed]
  end

  # menu
  # ------------------------------

  def menu
    params.require(:menu).permit(:name, :cogs, :sell_price, :pricing_type)
  end

  def menu_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end

  # menu item
  # ------------------------------

  def menu_item
    params.require(:menu_item).permit(:featured, :sell_price, :inventory_item_id)
  end

  def menu_item_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end


  # menu_template
  # ------------------------------

  def menu_template
    params.require(:menu_template).permit(:name, :pricing_type, :product_type, 
      :expiration_date, :start_date, :cogs, :sell_price, :retail_price, :all_items,
      menu_level_discounts_attributes: [:id, :min_participation, :cogs, 
        :sell_price, :retail_price, :_destroy])
  end

  def menu_template_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end

  # menu_template_inventory_item
  # ------------------------------

  def menu_template_inventory_item
    params.require(:menu_template_inventory_item).permit!
  end

  # menu_template_group
  # ------------------------------

  def menu_template_group
    params.require(:menu_template_group).permit!
  end

  # pricing_tier
  # ------------------------------

  def pricing_tier
    params.require(:pricing_tier).permit(:name, :gross_profit)
  end

  def pricing_tier_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end

  # line_item
  # ------------------------------

  def line_item
    params.require(:line_item).permit!
  end

  # vendor
  # ------------------------------

  def vendor
    params.require(:vendor).permit!
  end

  def vendor_attributes
    [:name, :legal_name, :description, :website, :image_file_name, 
    :image_content_type, :image_file_size, :image_updated_at, :cuisine_list, :product_type_config,
    :default_tax_rate, :address, :vendor_manager_id, address_attributes: [:id, :name, 
    :address1, :address2, :city, :state, :zip_code, :country]]
  end

  # account
  # ------------------------------

  def account
    params.require(:account).permit(*account_attributes)
  end

  def account_attributes
    [:name, :website, :account_type, :active, :address_id, :image, 
    :account_exec_id, :sales_rep_id, :account_manager_id,
    address_attributes: [:id, :name, :address1, :address2, :city, :state, 
    :zip_code, :country]]
  end

  # menu_level_discounts
  # ------------------------------

  def menu_level_discount
    params.require(:menu_level_discount).permit(*menu_level_discount_attributes)
  end

  def menu_level_discount_attributes
    [:min_participation, :cogs, :sell_price, :event_id, :retail_price]
  end

  # billing_references
  # ------------------------------

  def billing_reference
    params.require(:billing_reference).permit(*billing_reference_attributes)
  end

  def billing_reference_attributes
    [:name, :tag_list]
  end

  # preferences
  # ------------------------------

  def preference
    params.require(:preference).permit(*preference_attributes)
  end

  def preference_attributes
    [:account_id, :vendor_id, :disposition, :preference_type, :cuisine]
  end

  # ssp_persistences
  # ------------------------------

  def ssp_persistence
    params.require(:ssp_persistence).permit(*ssp_persistence_attributes)
  end

  def ssp_persistence_attributes
    [:ssp_persistence_type, :name, :parameters]
  end

  # user
  # ------------------------------

  def user
    params.require(:user).permit(*user)
  end

  def user
    [:email]
  end

 # issue
  # ------------------------------
  def issue
    params.require(:issue).permit(*issue_attributes)
  end

  def issue_attributes
    [:title, :description, :priority, :status, :assigner_id, :assignee_id, :subject_id,
    :subject_type, :due_date, :open_date]
  end

   # comment
  # ------------------------------
  def comment
    params.require(:comment).permit(*comment_attributes)
  end

  def comment_attributes
    [:issue_id, :user_id, :description]
  end
end
