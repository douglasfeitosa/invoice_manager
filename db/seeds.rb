user = User.create!(email: 'invoice@invoice.com')
user.update(token: 'd5fd41ca-b44b-4d18-b7db-8f0d2cb0140e')

Invoice.create!(
  user: user,
  number: '1234567489',
  date: DateTime.new(2021, 12, 18),
  company: 'Husky',
  billing_for: 'DFG',
  total: 10.0,
  emails: 'douglasfeitosa@outlook.com'
)