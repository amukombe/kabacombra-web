class BackfillExistingPaymentAllocations < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      INSERT INTO payment_allocations
      (
        sale_payment_id,
        sale_id,
        amount,
        allocated_at,
        created_at,
        updated_at
      )
      SELECT
        sale_payments.id,
        sale_payments.sale_id,
        sale_payments.amount,
        COALESCE(
          sale_payments.payment_date,
          sale_payments.created_at
        ),
        NOW(),
        NOW()
      FROM sale_payments
      WHERE sale_payments.sale_id IS NOT NULL
        AND NOT EXISTS
        (
          SELECT 1
          FROM payment_allocations
          WHERE payment_allocations.sale_payment_id = sale_payments.id
            AND payment_allocations.sale_id = sale_payments.sale_id
        )
    SQL
  end

  def down
    execute <<~SQL
      DELETE FROM payment_allocations
    SQL
  end
end