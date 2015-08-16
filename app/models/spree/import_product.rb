require 'date'

module Spree
  class ImportProduct
    attr_accessor :name, :description, :slug, :meta_description,
                  :meta_keywords, :meta_keywords, :promotionable,
                  :meta_title, :price, :vendor, :option1, :option2, 
                  :weight, :quantity, :product_tags, :type, :option_value,
                  :taxons, :option_type, :cn_name, :cn_description,
                  :cn_meta_description, :cn_meta_title, :cn_meta_keywords

    def initialize(csv_row)
       @name = csv_row[:name]
       @cn_name = csv_row[:cn_name]
       @description = csv_row[:description]
       @cn_description = csv_row[:cn_description]
       @slug =  csv_row[:slug]
       @cn_slug = csv_row[:slug]
       @meta_description = csv_row[:meta_description]
       @cn_meta_description = csv_row[:cn_meta_description]
       @meta_keywords = csv_row[:meta_keywords] 
       @cn_meta_keywords = csv_row[:cn_meta_keywords]
       @promotionable =  csv_row[:promotionable]
       @meta_title = csv_row[:meta_title] 
       @cn_meta_title = csv_row[:cn_meta_title]
       @price = remove_zeros(csv_row[:price].to_i)
       @vendor = csv_row[:vendor]
       @product_tags = csv_row[:product_tags]
       @type = csv_row[:type]
       @option_type = csv_row[:option_type]
       @taxons = csv_row[:taxons]
    end

    def remove_zeros(csv)
      csv.equal?(0) || csv.equal?(0.00) ? nil : csv 
    end 
  end
end 
