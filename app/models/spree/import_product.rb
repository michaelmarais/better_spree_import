require 'date'

module Spree
  class ImportProduct
    attr_accessor :name_en, :name_cn, :brand_en, :brand_cn, :vendors, :category_collection,
                  :category_type, :category_sub_category, :style, 
                  :gender, :material, :color, :size:, :dimensions, 
                  :weight, :weight_units, :description_en, :description_cn,
                  :qty, :retail_price, :slug, :sku, :meta_description, :meta_title, :vendor

    # missing :name_en, :name_cn, :meta_description, shipping_category, :meta_title
    
    #attr_accessor :name, :description, :slug, :meta_description,
                  #:meta_keywords, :meta_keywords, :promotionable,
                  #:meta_title, :price, :vendor, :option1, :option2, 
                  #:weight, :quantity, :product_tags, :type, :option_value,
                  #:product_taxons, :option_type, :cn_name, :cn_description,
                  #:cn_meta_description, :cn_meta_title, :cn_meta_keywords,
                  #:spree_property, :product_property

    def initialize(csv_row)
       @name_en = csv_row[:name]
       @name_cn = csv_row[:cn_name]
       @description_en = csv_row[:description]
       @cn_description_cn = csv_row[:cn_description]
       @slug =  csv_row[:slug]
       @meta_description = csv_row[:meta_description]
       @meta_title = csv_row[:meta_title] 
       @cn_meta_title = csv_row[:cn_meta_title]
       @retail_price = remove_zeros(csv_row[:retail_price].to_i)
       @vendor = csv_row[:vendor]
       @product_tags = csv_row[:product_tags]
       @spree_property = csv_row[:spree_property]
       @product_property = csv_row[:product_property]
       @option_type = csv_row[:option_type]
       @product_taxons = csv_row[:product_taxons]
    end

    def remove_zeros(csv)
      csv.equal?(0) || csv.equal?(0.00) ? nil : csv 
    end 
  end
end 
