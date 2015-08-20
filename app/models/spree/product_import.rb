require 'csv'
require 'roo'

class Spree::ProductImport < Spree::Base 
  preference :translate_products, :boolean, default: false 

  has_attached_file :csv_import, :path => ":rails_root/lib/etc/product_data/data-files/:basename.:extension"
  validates_attachment :csv_import, presence: true, :content_type => { content_type: ['application/excel','application/vnd.ms-excel','application/vnd.msexcel', "application/pdf","application/vnd.ms-excel"  , "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]} 



  def add_products!
    import_products
    header = @products_csv.row(1)
    (3..@products_csv.last_row).each do |row| 
     product = Spree::ImportProduct.new(Hash[[header.map(&:to_sym), @products_csv.row(row)].transpose]) 
     product_found = Spree::Product.find_by(slug: product.slug.split)
     if product_found
        new_variant = Spree::Variant.create(clean_variant(product))
        new_variant.product = product_found
        new_variant.price = product.retail_price
        add_option_type(product, new_variant)
        new_variant.stock_items.each do |stock_item|
          Spree::StockMovement.create(quantity: product.stock_items_count, stock_item: stock_item)
        end 
        new_variant.save!
     else 

       new_product = Spree::Product.create!(name: product.name_en, description: product.description_en,
                                     meta_keywords: "#{product.slug}, #{product.name_en}, the Squirrelz",
                                     meta_description: product.meta_description_en, meta_title: product.meta_title_en,
                                     available_on: Time.zone.now, price: product.retail_price, cost_price: product.retail_price,
                                     shipping_category: Spree::ShippingCategory.find_or_create_by!(name: 'Shipping'))

        add_translations(new_product, product) 
        new_product.tag_list = product.product_tags if product.product_tags.present?
        add_product_property(product, new_product)
        add_product_taxons(product, new_product)
        new_product.save!
     end 
    end
  end
  
  def add_product_taxons(product, new_product) 
     taxons = product.instance_values.select {|key, value| key.match(/category_/) && value.present? }
     if taxons.present?
       new_taxons = taxons.each_value.map {|taxon_name| find_taxon(taxon_name)}
       new_taxons.map {|taxon| new_product.taxons.push(taxon) if find_taxon(taxon.try(:name)).present? && !new_product.taxons.include?(taxon) } 
     end 
  end 

  def update_products!

  end 
  
  def add_option_type(product, new_variant)
    option_values = product.instance_values.select { |key, value| key.match(/option_/) && value.present? }
    if option_values.present?
      option_values.map do |key, value| 
        option_type = find_option_type(key.gsub(/option_/, "").capitalize) 
        option_value = Spree::OptionValue.joins(:translations).find_or_create_by!(option_type: option_type, name: value, presentation: value)
        new_variant.option_values << option_value
      end 
    end
  end 

  def add_product_property(product, new_product)
   new_product = Spree::Product.find_by(slug: product.slug)
   product_properties  = product.instance_values.select { |key, value| key.match(/property_/) && value.present? }
   if product_properties.present?
     product_properties.map do |key, value| 
       property = find_property(key.gsub(/property_/, "").capitalize) 
       Spree::ProductProperty.create!(property: property, value: value, product: new_product) 
     end 
   end 
 end 

  private 
  
  def import_products 
    options = {headers: true, header_converters: :symbol, skip_blanks: true, encoding: 'ISO-8859-1', extension: :xlsx }
    @products_csv =  Roo::Spreadsheet.open(self.csv_import.path, options)
  end

  def clean_variant(variant)
    variant.instance_values.symbolize_keys.reject {|key, value| !Spree::Variant.attribute_method?(key) || value.nil? }
  end 

  def find_property(property)
    Spree::Property.joins(:translations).find_or_create_by(name: property, presentation: property)
  end 
  
  def find_option_type(option)
    Spree::OptionType.joins(:translations).find_or_create_by(name: option, presentation: option)
  end 
  
  def find_taxon(taxon)
    Spree::Taxon.joins(:translations).find_by(name: taxon) 
  end

  def add_translations(new_product, product) 
     product_translation = new_product.update_attributes(name: product.name_cn, description: product.description_cn, locale: :cn)
  end
end
