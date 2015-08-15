require 'csv'

class Spree::ProductImport < Spree::Base 
  preference :upload_products, :boolean, :default_false
  preference :translate_products, :boolean, :default_false 
  preference :upload_variants, :boolean, :default_false 
  preferenct :update_variants, :boolean, :default_false

  has_attached_file :csv_import, :path => ":rails_root/lib/etc/product_data/data-files/:basename.:extension"
  validates_attachment :csv_import, presence: true,
	    :content_type => { content_type: 'text/csv' }

  def add_products!
    import_products 
    #new_product =  product.instance_values.symbolize_keys.reject {|key, value| !Spree::Product.attribute_method?(key) || value.nil? }
    products = @products_csv.map { |product|  Spree::ImportProduct.new(product)  }

    products.each do |product|
      new_product = Spree::Product.create!(name: product.name, description: product.description,
                                     meta_title: product.meta_title, meta_description: product.meta_description,
                                     meta_keywords: "#{product.slug}, #{product.name}, the Squirrelz",
                                     available_on: Time.zone.now, price: product.price,
                                     shipping_category: Spree::ShippingCategory.find_by!(name: 'Shipping'))

      add_translations(new_product, product) if has_preference?(:translate_products)

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
   if has_preferenc?(:update_variants)
      variants.each do |variant|
        clean_variant = variant.instance_values.symbolize_keys.reject {|key, value| !Spree::Variant.attribute_method?(key) || value.nil? }
        find_variant = Spree::Variant.find_by(sku: variant.sku.split)
        find_variant.update_attributes(clean_variants)
      end 
   else
    variants.each do |variant|
      clean_variant = variant.instance_values.symbolize_keys.reject {|key, value| !Spree::Variant.attribute_method?(key) || value.nil? }
      new_variant = Spree::Variant.new(clean_variant)
      new_variant.product = Spree::Product.find_by(slug: variant.product_slug.split)
      new_variant.save!
    end 
  end


  #repeating too much can try and make this one method 
  def add_product_taxons(product, new_product) 
   if product.taxons.present? 
     seperate_taxons = product.taxons.split(" ").map(&:strip)
     taxon = seperate_taxons.map {|taxon_name| find_taxon(taxon_name)}
     
     new_product.taxons << taxon if find_taxon(taxon).present? 
   end 
  end 

  def add_product_option_type(product, new_product) 
   if product.option_type.present? 
     product_option = product.option_type.split(" ").map(&:strip)
     option_type = product_option.map {|option_type| find_option_type(option_type) }
     new_product.option_types << option_type if find_option_type(option_type).present? 
   end 
  end 

  def add_product_property(product, new_product)
   if product.type.present? 
     product_option = product.type.split(" ").map(&:strip)
     type = product_option.map {|property| find_property(property) }
     
     new_product.product_properties << type if find_property(type).present? 
   end 
  end 

  private 

  def find_property(property)
    Spree::ProductProperty.joins(:translations).find_by(value: property)
  end 

  def find_option_type(option_type)
    Spree::OptionType.joins(:translations).find_by(name: option_type) 
  end 

  def find_taxon(taxon)
    Spree::Taxon.joins(:translations).find_by(name: taxon) 
  end

  def import_products 
    options = {headers: true, header_converters: :symbol, skip_blanks: true}
    @products_csv = CSV.read(self.csv_import.path, options)
  end

  def add_translations(new_product, product) 
     product_translation = new_product.update_attributes(name: product.cn_name, description: product.cn_description,
                                 meta_title: product.cn_meta_title, meta_description: product.cn_meta_description, 
                                 meta_keywords: product.cn_meta_keywords, locale: :cn)
  end
end
