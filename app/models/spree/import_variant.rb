require 'date'

module Spree 
  class ImportVariant
    attr_accessor :name, :description, :slug, :meta_description,
                  :meta_keywords, :meta_keywords, :meta_title,
                  :price, :vendor, :product_slug, :sku, :stock_items_count

    def initialize(csv_row = nil)
      @sku     =  csv_row[:sku]
      @heigh   =  remove_zeros(csv_row[:height].to_f)
      @width   =  remove_zeros(csv_row[:width].to_f)
      @depth   =  remove_zeros(csv_row[:depth].to_f) 
      #@is_master =  csv_row[:is_master].to_i
      @product_slug   =  csv_row[:product_slug]
      @csv_price =  remove_zeros(csv_row[:cost_price].to_i)
      @cost_currency   =  remove_zeros(csv_row[:cost_currency].to_i)
      #@track_inventory =  csv_row[:track_inventory].to_i
      @tax_category_id =  remove_zeros(csv_row[:tax_category_id].to_i)
      @stock_items_count  =  remove_zeros(csv_row[:stock_items_count].to_i) 
    end

    def remove_zeros(csv)
      csv.equal?(0) || csv.equal?(0.00) ? nil : csv 
    end 
  end 
end 
