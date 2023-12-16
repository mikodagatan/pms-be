require 'base64'
require 'openssl'
require 'json'

class Jwt
  class << self
    SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'default_secret_key'

    def encode(payload, algorithm = 'HS256')
      header = { typ: 'JWT', alg: algorithm }
      encoded_header = base64_url_encode(header.to_json)
      encoded_payload = base64_url_encode(payload.to_json)
      signature = generate_signature("#{encoded_header}.#{encoded_payload}", algorithm)

      "#{encoded_header}.#{encoded_payload}.#{signature}"
    end

    def decode(token, algorithm = 'HS256')
      encoded_header, encoded_payload, signature = token.split('.')
      payload = JSON.parse(base64_url_decode(encoded_payload))

      return nil if payload['exp'] && Time.now.to_i > payload['exp'].to_i

      payload if valid_signature?("#{encoded_header}.#{encoded_payload}", signature, algorithm)
    end

    def base64_url_encode(data)
      Base64.encode64(data).tr('+/', '-_').gsub(/[\n=]/, '')
    end

    def base64_url_decode(data)
      data += '=' * (4 - data.length.modulo(4))
      Base64.decode64(data.tr('-_', '+/'))
    end

    def generate_signature(data, algorithm)
      digest = OpenSSL::Digest.new(algorithm.gsub('HS', 'sha'))
      hmac = OpenSSL::HMAC.digest(digest, SECRET_KEY, data)
      base64_url_encode(hmac)
    end

    def valid_signature?(data, signature, algorithm)
      expected_signature = generate_signature(data, algorithm)
      secure_compare(expected_signature, signature)
    end

    def secure_compare(expected_signature, actual_signature)
      return false unless expected_signature.bytesize == actual_signature.bytesize

      expected_bytes = expected_signature.unpack("C#{expected_signature.bytesize}")
      res = 0

      actual_signature.each_byte { |byte| res |= byte ^ expected_bytes.shift }
      res.zero?
    end
  end
end
