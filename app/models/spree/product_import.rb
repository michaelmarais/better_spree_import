require 'csv'
require 'roo'
#require 'spreadsheet'

class Spree::ProductImport < Spree::Base 
  preference :upload_products, :boolean, default: false
  preference :upload_variants, :boolean, default: false
  preference :translate_products, :boolean, default: false 


  has_attached_file :csv_import, :path => ":rails_root/lib/etc/product_data/data-files/:basename.:extension"
  validates_attachment :csv_import, presence: true, :content_type => { content_type: ['text/csv','text/comma-separated-values','text/csv','application/csv','application/excel','application/vnd.ms-excel','application/vnd.msexcel', "application/pdf","application/vnd.ms-excel",     
                     "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                     "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]} 

  validates_inclusion_of :preferred_upload_variants, in: [true], if: lambda {|u| !u.preferred_upload_products },  message: "What are you doing Walt! Choose to Upload products or Variants!" 
  validates_inclusion_of :preferred_upload_products, in: [true], if: lambda {|u| !u.preferred_upload_variants },  message: "What are you doing Walt! Choose to Upload either products or Variants!"


  def add_products!
    import_products
    header = @products_csv.row(1)

    (2..@products_csv.last_row).each do |row| 
      product = Spree::ImportProduct.new(Hash[[header.map(&:to_sym), @products_csv.row(row)].transpose])  
      binding.pry

     new_product = Spree::Product.find_by(slug: product.slug)
     if new_product
       clean = product.instance_values.symbolize_keys.reject {|key, value| !Spree::Product.attribute_method?(key) || value.nil?}
       new_product.update_attributes(clean)
     else 

     binding.pry
     new_product = Spree::Product.create!(name: product.name, description: product.description,
                                     meta_title: product.meta_title, meta_description: product.meta_description,
                                     meta_keywords: "#{product.slug}, #{product.name}, the Squirrelz",
                                     available_on: Time.zone.now, price: product.price, cost_price: product.price,
                                     shipping_category: Spree::ShippingCategory.find_or_create_by!(name: 'Shipping'))


     end 
      add_translations(new_product, product) if preferred_translate_products
      new_product.tag_list = product.product_tags
      new_product.slug = product.slug
      add_product_option_type(product, new_product)
      add_product_property(product, new_product)
      add_product_taxons(product, new_product)
      new_product.save!
    end
  end

  def add_variants! 
     import_products
     variants = @products_csv.map { |variant|  Spree::ImportVariant.new(variant)  } 

     variants.each do |variant|
       find_variant = Spree::Variant.find_by(sku: variant.sku) if variant.sku
       if find_variant
          clean = variant.instance_values.symbolize_keys.reject {|key, value| !Spree::Variant.attribute_method?(key) || value.nil? }
          find_variant.update_attributes(clean)
          find_variant.stock_items.each do |stock_item|
            Spree::StockMovement.create(quantity: variant.stock_items_count, stock_item: stock_item)
          end 
          find_variant.save!
       else 
          new_variant = Spree::Variant.new(clean_variant(variant))
          new_variant.product = Spree::Product.find_by(slug: variant.product_slug.split)
          new_variant.stock_items.each do |stock_item|
            Spree::StockMovement.create(quantity: variant.stock_items_count, stock_item: stock_item)
          end 
          new_variant.save!
       end 
    end 
  end

  #repeating too much can try and make this one method 

  def add_product_option_type(product, new_product) 
   if product.option_type.present? 
     product_option = product.option_type.split(",").map(&:strip)
     option_types = product_option.map {|option_type| find_option_type(option_type) }
     option_types.map {|option| new_product.option_types.push(option) if find_option_type(option.try(:name)).present? && !new_product.option_types.include?(option) } 
   end 
  end 
  
  def add_product_taxons(product, new_product) 
   if product.product_taxons.present? 
     seperate_taxons = product.product_taxons.split(",").map(&:strip)
     taxons = seperate_taxons.map {|taxon_name| find_taxon(taxon_name)}
     taxons.map {|taxon| new_product.taxons.push(taxon) if find_taxon(taxon.try(:name)).present? && !new_product.taxons.include?(taxon) } 
   end 
  end 

  def add_product_property(product, new_product)
   new_product = Spree::Product.find_by(slug: product.slug)
   if product.spree_property.present? 
     seperate_properties = product.spree_property.split(",").map(&:strip)
     seperate_product_properties = product.product_property.split(",").map(&:strip)
     properties = seperate_properties.map {|property| find_property(property) }

     properties.map do |property| 
       seperate_product_properties.map do |product_property| 
         Spree::ProductProperty.create!(property: property, value: product_property, product: new_product) if product_property
       end 
     end 
   end 
 end 

  private 

  def clean_variant(variant)
    variant.instance_values.symbolize_keys.reject {|key, value| !Spree::Variant.attribute_method?(key) || value.nil? }
  end 

  def find_property(property)
    Spree::Property.joins(:translations).find_or_create_by(name: property)
  end 
  

  def find_option_type(option_type)
    Spree::OptionType.joins(:translations).find_by(name: option_type) 
  end 

  def find_taxon(taxon)
    Spree::Taxon.joins(:translations).find_by(name: taxon) 
  end


  def add_translations(new_product, product) 
     product_translation = new_product.update_attributes(name: product.cn_name, description: product.cn_description,
                                 meta_title: product.cn_meta_title, meta_description: product.cn_meta_description, 
                                 meta_keywords: product.cn_meta_keywords, locale: :cn)
  end
  
  def import_products 
    options = {headers: true, header_converters: :symbol, skip_blanks: true, encoding: 'ISO-8859-1', extension: :xls }
    @products_csv =  Roo::Spreadsheet.open(self.csv_import.path, options)
  end
end
