# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

domains = [
  { name: 'hsts.badssl.com', port: 80 },
  { name: 'no-sct.badssl.com', port: 80 },
  { name: 'no-subject.badssl.com', port: 80 },
  { name: '10000-sans.badssl.com', port: 80 },
  { name: 'client.badssl.com', port: 80 },
  { name: 'preact-cli.badssl.com', port: 80 },
  { name: 'dh512.badssl.com', port: 80 },
  { name: 'revoked.badssl.com', port: 80 },
  { name: 'tls-v1-2.badssl.com', port: 1012 },
  { name: 'client-cert-missing.badssl.com', port: 80 },
  { name: 'very.badssl.com', port: 80 },
  { name: 'http-textarea.badssl.com', port: 80 },
  { name: 'mozilla-modern.badssl.com', port: 80 }
]
domains.each do |domain|
  Domain.create(name: domain[:name], port: domain[:port])
end
