Health =
  permissions: 'public'
  meta:
    name: 'name'
    age: 'age'
  form: []
  schema: {}
  children:
    allergy: require './allergy'
    # immunization: require './immunization'

exports = module.exports = Health
