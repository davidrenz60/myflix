shared_examples "require sign in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "tokenable" do
  it "sets a token when the model is created" do
    expect(model.token).to be_present
  end
end