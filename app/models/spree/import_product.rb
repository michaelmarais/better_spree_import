require 'date'

module Spree
  class ImportProduct
    attr_accessor :name_en, :name_cn, :brand_en, :brand_cn, :vendors, 
                  :product_tags, :category_collection, :category_collection,
                  :category_type, :category_sub_category, :property_style, 
                  :property_gender, :property_material, :option_color, :option_size, :property_dimensions, 
                  :weight, :weight_units, :description_en, :description_cn,
                  :stock_items_count, :retail_price, :slug, :squirrelz_sku, :meta_description_en, 
                  :meta_description_cn, :meta_title_en, :meta_title_cn, :vendor, :cost_currency


    def initialize(csv_row)
      @slug = csv_row[:slug]
      @name_en = csv_row[:name_en] 
      @name_cn = csv_row[:name_cn]
      @brand_en = csv_row[:brand_en]
      @brand_cn = csv_row[:brand_cn]
      @vendors = csv_row[:vendors]
      @option_color = csv_row[:option_color]
      @option_size  = csv_row[:option_size]
      @cost_currency = "CNY"
      @product_tags = csv_row[:product_tags]
      @category_collection = csv_row[:category_collection]
      @category_type, = csv_row[:category_type]
      @category_sub_category = csv_row[:category_sub_category]
      @property_gender = csv_row[:property_gender]
      @property_material = csv_row[:property_material]
      @property_style = csv_row[:property_style]
      @style = csv_row[:style]
      @weight = remove_zeros(csv_row[:width].to_f)
      @weight_units = csv_row[:weight_units]
      @description_en =  csv_row[:description_en]
      @description_cn  = csv_row[:description_cn]
      @meta_description_en = csv_row[:meta_description_en]
      @meta_description_cn = csv_row[:meta_description_cn]
      @meta_title_en = csv_row[:meta_title_en]
      @meta_title_cn = csv_row[:meta_title_cn]
      @stock_items_count = remove_zeros(csv_row[:stock_items_count].to_i) 
      @retail_price = remove_zeros(csv_row[:retail_price].to_f)
      @sku = csv_row[:sku]
      @meta_description = csv_row[:meta_description]
      @meta_title = csv_row[:meta_title]
      @vendor  = csv_row[:vendor]
    end 
    
    def remove_zeros(csv)
      csv.equal?(0) || csv.equal?(0.00) ? nil : csv 
    end 
  end
end 
