Immunization =
  permissions: 'public'
  meta: {}
  form: [
    "immunization"
    type: "submit"
    style: "btn-info"
    title: "OK"
  ]
  schema:
    title: "Immunization"
    type: "object"
    properties:
      immunization:
        title: "Immunization"
        type: "string"
    required: [ "immunization" ]

exports = module.exports = Immunization
