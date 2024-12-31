class InventoryAllocator
    def initialize(nile_product, quantity, territory_id)
      @nile_product = nile_product
      @quantity = quantity
      @territory_id = territory_id
    end
  
    def allocate
        rm_quantity = @quantity
      
        inventory_items = InventoryItem
                            .joins(:inventory,dispatch_item: { order_item: :nile_product })
                            .where(nile_products: { id: @nile_product.id }, inventories:{territory_id:@territory_id})
                            .oldest
      
        inventory_items.each do |inventory_item|
          puts "========Initial remaining_quantity: #{inventory_item.remaining_quantity}"
          puts "========Initial quantity_sold: #{inventory_item.quantity_sold}"
          break if rm_quantity <= 0
      
          # Calculate the quantity that can be allocated from this inventory item
          allocatable_quantity = [inventory_item.remaining_quantity, rm_quantity].min
           #current remaining 60, rm_quantity = 30, allocatable =[60,30].min ==30
           puts "=======Allocatable quantity: #{allocatable_quantity}"
          # Update inventory item fields
          inventory_item.remaining_quantity -= allocatable_quantity
          rm_quantity = (inventory_item.remaining_quantity - allocatable_quantity)
          #inventory_item.quantity_sold += @allocatable_quantity
          inventory_item.quantity_sold = (inventory_item.quantity_sold || 0) + allocatable_quantity
          inventory_item.save!
      
          # Reduce the remaining quantity to be allocated
          rm_quantity -= allocatable_quantity
          puts "======Updated remaining_quantity: #{inventory_item.remaining_quantity}"
          puts "======Updated quantity_sold: #{inventory_item.quantity_sold}"
        end
      
        #raise "Insufficient stock for product: #{@nile_product.name}" if rm_quantity > 0
    end 

    def deallocate
      # Start with the quantity that was allocated
      reverse_quantity = @quantity
      
      inventory_items = InventoryItem
                          .joins(:inventory, dispatch_item: { order_item: :nile_product })
                          .where(nile_products: { id: @nile_product.id }, inventories: { territory_id: @territory_id })
                          .order(created_at: :asc)
      
      inventory_items.each do |inventory_item|
        puts "========Initial remaining_quantity: #{inventory_item.remaining_quantity}"
        puts "========Initial quantity_sold: #{inventory_item.quantity_sold}"
        break if reverse_quantity <= 0
    
        # Calculate the quantity to reverse from this inventory item
        reversible_quantity = [inventory_item.quantity_sold, reverse_quantity].min
        puts "=======Reversible quantity: #{reversible_quantity}"
        
        # Update inventory item fields
        inventory_item.remaining_quantity += reversible_quantity
        inventory_item.quantity_sold -= reversible_quantity
        inventory_item.save!
        
        # Reduce the quantity left to reverse
        reverse_quantity -= reversible_quantity
        puts "======Updated remaining_quantity: #{inventory_item.remaining_quantity}"
        puts "======Updated quantity_sold: #{inventory_item.quantity_sold}"
      end
    end
    
  end
  