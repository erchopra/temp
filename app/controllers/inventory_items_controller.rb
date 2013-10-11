class InventoryItemsController < ApplicationController

  respond_to :html

  def index
    respond_with(@inventory_items = current_vendor.inventory_items)
  end

  def show
    respond_with(@inventory_item = InventoryItem.find(params[:id]), @vendor = current_vendor)
  end

  def edit
    @inventory_item = current_vendor.inventory_items.find(params[:id])
  end

  def new
    respond_with(
      @inventory_item = current_vendor.inventory_items.build)
  end

  def create
    @inventory_item = inventory_items.create(permitted_params.inventory_item)

    if @inventory_item.save
      flash[:notice] = "Inventory item created."
      redirect_to new_vendor_inventory_item_path(current_vendor)
    else
      flash[:error] = "Error creating inventory item. - " + @inventory_item.errors.full_messages.join(", ")
      redirect_to new_vendor_inventory_item_path(current_vendor)
    end
  end

  def update
    @inventory_item = current_vendor.inventory_items.find(params[:id])
    if @inventory_item.update_attributes(permitted_params.inventory_item)
      flash[:notice] = "Inventory item updated."
      redirect_to vendor_path(current_vendor, :selected => "inventory_items")
    else
      flash[:error] = "Error updating inventory item."
      redirect_to vendor_path(current_vendor, :selected => "inventory_items")
    end
  end

  def destroy

    @inventory_item = current_vendor.inventory_items.find(params[:id])
    if @inventory_item.destroy
      flash[:notice] = "Inventory item deleted."
      redirect_to vendor_path(current_vendor, :selected => "inventory_items")
    else
      flash[:error] = "Error deleting inventory item."
      redirect_to vendor_path(current_vendor, :selected => "inventory_items")
    end

  end

  protected

    def inventory_items
      @inventory_items ||= current_vendor.inventory_items
    end

    def current_vendor
      @vendor ||= Vendor.find(params[:vendor_id])
    end
end