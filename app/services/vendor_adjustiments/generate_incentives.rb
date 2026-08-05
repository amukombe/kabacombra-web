module VendorAdjustiments
  class GenerateIncentives

    def initialize(vendor_payment)
      @payment = vendor_payment
      @territory = vendor_payment.territory
      @user = vendor_payment.user
    end

    def call
      create_payment_incentive
      create_warehouse_incentive
      create_rebate
    end

    private

    ###########################################################
    # PAYMENT INCENTIVE
    ###########################################################

    def create_payment_incentive

      total_paid_today =
        VendorPayment.where(
          payment_date: @payment.payment_date
        ).sum(:amount)

      percentage =
        if total_paid_today >= 500_000_000
          3
        else
          2
        end

      amount =
        @payment.amount.to_d *
        percentage / 100

      create_adjustment(
        category: :payment_incentive,
        amount: amount,
        description: "#{percentage}% Payment Incentive",
        calculation_base_amount: @payment.amount,
        calculation_rate: percentage
      )

    end

    ###########################################################
    # WAREHOUSE INCENTIVE
    ###########################################################

    def create_warehouse_incentive

      quantity =
        InventoryItem
          .joins(:inventory)
          .where(
            inventories: {
              territory_id: @territory.id
            }
          )
          .where(
            "DATE(inventories.created_at)=?",
            @payment.payment_date
          )
          .sum(:quantity_received)

      amount = quantity.to_d * 1_000

      return if amount.zero?

      create_adjustment(
        category: :warehouse_incentive,
        amount: amount,
        description: "Warehouse Incentive",
        calculation_base_amount: quantity,
        calculation_rate: 1_000
      )

    end

    ###########################################################
    # REBATE
    ###########################################################

    def create_rebate

      quantity =
        InventoryItem
          .joins(:inventory)
          .where(
            inventories: {
              territory_id: @territory.id
            }
          )
          .where(
            "DATE(inventories.created_at)=?",
            @payment.payment_date
          )
          .sum(:quantity_received)

      amount = quantity.to_d * 2_500

      return if amount.zero?

      create_adjustment(
        category: :rebate,
        amount: amount,
        description: "Purchase Rebate",
        calculation_base_amount: quantity,
        calculation_rate: 2_500
      )

    end

    ###########################################################

    def create_adjustment(
      category:,
      amount:,
      description:,
      calculation_base_amount:,
      calculation_rate:
    )

      VendorAdjustiment.create!(
        territory: @territory,
        user: @user,
        purchase_type: PurchaseType.first,
        adjustment_date: @payment.payment_date,
        adjustment_type: :credit,
        adjustment_category: category,
        amount: amount,
        calculation_base_amount: calculation_base_amount,
        calculation_rate: calculation_rate,
        source_type: "VendorPayment",
        source_id: @payment.id,
        ref_no: @payment.payment_no,
        description: description
      )

    end

  end
end