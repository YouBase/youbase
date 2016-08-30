Allergy =
  permissions: 'public'
  meta: {}
  form: [
    "allergen"
    type: "submit"
    style: "btn-info"
    title: "OK"
  ]
  schema:
    title: "Allergy"
    type: "object"
    properties:
      allergen:
        title: "Allergen"
        type: "string"
    required: [ "allergen" ]
  children: {}

exports = module.exports = Allergy
