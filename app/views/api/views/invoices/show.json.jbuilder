json.invoice do
  json.id @invoice.id
  json.number @invoice.number
  json.date @invoice.date
  json.company @invoice.company
  json.billing_for @invoice.billing_for
  json.emails @invoice.emails
  json.created_at @invoice.created_at
  json.updated_at @invoice.updated_at
end