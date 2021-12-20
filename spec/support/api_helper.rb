module APIHelper
  def serialize_error(error)
    {
      "error" => error
    }
  end

  def serialize_invoice(invoice)
    {
      invoice: {
        id: invoice.id
      }
    }
  end
end