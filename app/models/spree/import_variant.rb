require 'date'

module Spree 
  class ImportVariant
    attr_accessor :name, :description, :slug, :meta_description,
                  :meta_keywords, :meta_keywords, :meta_title,
                  :price, :vendor, :product_slug

    def initialize(csv_row)
              @heigh   =  csv_row[:height].to_f 
              @width   =  csv_row[:width].to_f 
              @depth   =  csv_row[:depth].to_f  
           #@is_master =  csv_row[:is_master].to_i
          @product_slug   =  csv_row[:product_slug]
            @csv_price =  csv_row[:cost_price].to_i 
      @cost_currenct   =  csv_row[:cost_currency].to_i 
      #@track_inventory =  csv_row[:track_inventory].to_i
      @tax_category_id =  csv_row[:tax_category_id].to_i 
      @stock_items_count     =  csv_row[:stock_items_count].to_i 
    end

    def find_product(slug)
      Spree::Product.joins(:translations).find_by_slug(slug)
    end 

   class String
    def to_bool
      return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
      return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
     end
   end 
  end
end 
