require 'spec_helper'

shared_examples_for 'tokenable' do
  UUID_REGEX = /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/

  before do
    @tokenable = build(described_class.to_s.underscore.to_sym, token: nil)
    @tokenable.save
  end

  it 'expects token to changed from nil to a random uuid' do
    expect(@tokenable.reload.token).not_to eq(nil)
  end

  it 'expects token to be an uuid' do
    expect(@tokenable.reload.token).to match(UUID_REGEX)
  end
end