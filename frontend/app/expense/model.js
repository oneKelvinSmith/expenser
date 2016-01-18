import DS from 'ember-data';

export default DS.Model.extend({
  datetime: DS.attr('date'),
  description: DS.attr('string'),
  amount: DS.attr('number'),
  comment: DS.attr('string'),
  user: DS.belongsTo('user')
});
