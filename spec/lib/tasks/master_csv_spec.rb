require 'rails_helper'

RSpec.describe 'master_csv' do
  describe 'import_with_line' do
    subject(:task) { Rake.application['master_csv:import_with_line'] }

    it 'import_with_line' do
      file = file_fixture('master.csv').read
      allow_any_instance_of(Aws::S3::Client).to receive_message_chain(:get_object, :body, :read).and_return(file)
      expect { task.invoke }.not_to raise_error
    end
  end
end
