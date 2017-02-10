RSpec.shared_examples 'failed post request' do
  it 'return a 400 code' do
    expect(response.status).to eq(400)
  end

  it 'contain error message' do
    body = JSON.parse(response.body)
    expect(body).to include('error')
  end

  it 'be a JSON' do
    expect(response.headers).to include('Content-Type' => 'application/json')
  end
end
