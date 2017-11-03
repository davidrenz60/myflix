if Rails.env.test?
  Myflix::Application.config.secret_token = "f6dab24141c46363f54840a52331247f0a4c0c93c3cef55643905f47f2c697af1fc317ef3a79dde13d837d9df58e0dbad4216532e614b597c2c592e2b1a8d1b5"
  Myflix::Application.config.secret_key_base = "1f3f1ce10e4327da89e0ddae3c5f11441ed73401982a07a11a955c4f9f390e765fa11d16a7d70baf67f34393e476f06c5fea28c1f1013bed8c940f32fd1c3e99"
else
  Myflix::Application.config.secret_token = ENV['SECRET_TOKEN']
  Myflix::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']
end

