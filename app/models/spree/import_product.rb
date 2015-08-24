module Spree
  class ImportProduct
    attr_accessor :name_en, :name_cn, :brand_en, :brand_cn, :vendors, 
                  :product_tags, :category_collection, :category_collection,
                  :category_type, :category_sub_category, :category_brand, :property_style, 
                  :property_gender, :property_material, :option_color, :option_size, :property_dimensions,  
                  :weight, :weight_units, :description_en, :description_cn,
                  :stock_items_count, :retail_price, :slug, :squirrelz_sku, :meta_description_en, 
                  :meta_description_cn, :meta_title_en, :meta_title_cn, :vendor, :cost_currency


    def initialize(args)
      @cost_currency = "CNY"
      args.each do |k,v|
        if k.include?("stock_items_count")
          instance_variable_set("@#{k}", remove_zeros(v.to_i)) 
        else 
          instance_variable_set("@#{k}", v) 
        end 
      end
    end 
    
    def remove_zeros(csv)
      csv.equal?(0) || csv.equal?(0.00) ? nil : csv 
    end 
  end
end 
