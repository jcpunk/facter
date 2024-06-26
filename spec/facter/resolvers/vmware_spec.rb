# frozen_string_literal: true

describe Facter::Resolvers::Vmware do
  subject(:vmware_resolver) { Facter::Resolvers::Vmware }

  before do
    allow(Facter::Core::Execution).to receive(:execute).with('vmware -v', logger: an_instance_of(Facter::Log)).and_return(output)
  end

  after do
    vmware_resolver.invalidate_cache
  end

  context 'when vmware command exists' do
    context 'when it returns invalid format' do
      let(:output) { 'vmware fusion 7.1' }

      it 'returns nil' do
        expect(vmware_resolver.resolve(:vm)).to be_nil
      end
    end

    context 'when it returns valid format' do
      let(:output) { 'VmWare Fusion' }
      let(:result) { 'vmware_fusion' }

      it 'returns nil' do
        expect(vmware_resolver.resolve(:vm)).to eq(result)
      end
    end
  end

  context 'when vmware command do not exists' do
    let(:output) { '' }

    it 'returns nil' do
      expect(vmware_resolver.resolve(:vm)).to be_nil
    end
  end
end
