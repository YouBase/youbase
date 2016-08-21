Health =
  permissions: 'public'
  meta:
    name: 'name'
    age: 'age'
  form: []
  schema:
    title: "Health Profile"
    type: "object"
    properties:
      name:
        title: "Name"
        type: "string"
    required: [ "name" ]
  children:
    allergy: require './allergy'
    immunization: require './immunization'

exports = module.exports = Health
