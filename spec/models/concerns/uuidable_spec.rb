require 'spec_helper'

shared_examples_for 'uuidable' do
  UUID_REGEX = /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/

  before do
    @uuidable = build(described_class.to_s.underscore.to_sym, token: nil)
    @uuidable.generate_unique_uuid(column)
    @uuidable.save
  end

  it 'expects token to changed from nil to a random uuid' do
    expect(@uuidable.reload.send(column)).not_to eq(nil)
  end

  it 'expects token to be an uuid' do
    expect(@uuidable.reload.send(column)).to match(UUID_REGEX)
  end
end