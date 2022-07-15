class Item < ApplicationRecord
  before_destroy :delete_empty_invoices

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def delete_empty_invoices
    invoices.each do |invoice|
      if invoice.items.count == 1
        InvoiceItem.find_by(id: invoice.id).destroy
        invoice.destroy
      end
    end
  end
end
