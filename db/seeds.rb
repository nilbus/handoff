# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.find_or_create_by(email: 'dr-peters@cardio.med')  { |user| user.password = 'test' }
User.find_or_create_by(email: 'dr-johnson@pcp.local')  { |user| user.password = 'test' }
User.find_or_create_by(email: 'dr-erickson@pulmo.med') { |user| user.password = 'test' }
