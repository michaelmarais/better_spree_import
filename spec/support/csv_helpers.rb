module CsvHelpers 
  module Feature
      VARIANT_HEADERS = "sku, weight, height, width, depth, is_master, product_slug, cost_price, cost_currency, track_inventory, stock_items_count\r\n" 
      PRODUCTS = "slug, cn_slug, name, cn_name, description, cn_description, price, product_tags, meta_title, cn_meta_title, meta_description, cn_meta_description, meta_keywords, vendor, option_type, type, taxons\r\n"


      def successfull_import
         @rows = ["quillingcard-greetingcard-small-love, Daves Quilling Cards,  Daves Quilling Cards Rooted in Vietnam each artist is assigned to a single design, 24.00, Small Love Cards from Quilling Card, quilling-card, recycled quilling cards, cards paper, the squirrelz, Graphic, Greeting Cart, The Taxon\r\n"]
        StringIO.new.tap do |sio|
          sio << PRODUCTS
          @rows.each { |row| sio << row }
          sio.rewind
        end
      end 

      def successfull_globalize_import
        @rows = ["quillingcard-greetingcard-small-love, 可爱动物贺卡, Daves Quilling Cards, 可爱动物贺卡,  Daves Quilling Cards Rooted in Vietnam each artist is assigned to a single design, 可爱的小动物们乖乖的躺在那里,  24.00, Small Love Cards from Quilling Card, quilling-card, 爱动物贺卡, recycled quilling cards, 爱动物贺卡, cards paper, the squirrelz, Graphic, Greeting Cart, The Taxon\r\n"]
        StringIO.new.tap do |sio|
          sio << PRODUCTS
          @rows.each { |row| sio << row }
          sio.rewind
        end
      end 

      def missing_globalize_fields
         @rows = ["quillingcard-greetingcard-small-love, nil, Daves Quilling Cards, nil,  Daves Quilling Cards Rooted in Vietnam each artist is assigned to a single design, 可爱的小动物们乖乖的躺在那里,  24.00, Small Love Cards from Quilling Card, quilling-card, 爱动物贺卡, recycled quilling cards, 爱动物贺卡, cards paper, the squirrelz, Graphic, Greeting Cart, The Taxon\r\n"]
        StringIO.new.tap do |sio|
          sio << PRODUCTS
          @rows.each { |row| sio << row }
          sio.rewind
        end
      end 

      def successfull_variant_import
        @rows = ["B7833HH4, 2.2, 4.6, 5.2, 4.8, 1, test-product, 0.0, CNY, 0, 2\r\n"] 
        StringIO.new.tap do |sio|
          sio << VARIANT_HEADERS
          @rows.each { |row| sio << row }
          sio.rewind
        end
      end 

      def update_variants_import
        @rows = ["SKU-2, 2.2, , , , , , , , , 5\r\n"]
        StringIO.new.tap do |sio|
          sio << VARIANT_HEADERS
          @rows.each { |row| sio << row }
          sio.rewind
        end
      end 
    end 
  end 
