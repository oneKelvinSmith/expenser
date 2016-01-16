import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr('string'),
  admin: DS.attr('boolean'),
  createdAt: DS.attr('date'),
  updatedAt: DS.attr('date')
});
